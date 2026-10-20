#!/usr/bin/env python3
"""Print a known chat title for the exact session attached to a Herdr agent."""

import json
import os
from pathlib import Path
import re
import sqlite3
import sys
from urllib.parse import quote


def nonblank(value):
    return isinstance(value, str) and bool(value.strip())


def database_title(path, query, session_id):
    # URI read-only mode also prevents accidental creation of a missing database.
    uri = "file:" + quote(str(path.resolve()), safe="/") + "?mode=ro"
    with sqlite3.connect(uri, uri=True, timeout=1) as connection:
        row = connection.execute(query, (session_id,)).fetchone()
    return row[0] if row and nonblank(row[0]) else None


def codex_id(session):
    value = session.get("value")
    if not nonblank(value):
        raise ValueError("Codex session identity is missing")
    if session.get("kind") == "id":
        return value
    if session.get("kind") != "path":
        raise ValueError("Unsupported Codex session identity kind")
    # Read metadata only, never conversation records or nearby sessions.
    with Path(value).expanduser().open("rb") as rollout:
        first_line = rollout.readline(65537)
    if len(first_line) > 65536:
        raise ValueError("Codex session metadata exceeds the read limit")
    record = json.loads(first_line)
    if not isinstance(record, dict):
        raise ValueError("Codex rollout metadata must be a JSON object")
    payload = record.get("payload")
    if record.get("type") != "session_meta" or not isinstance(payload, dict):
        raise ValueError("Codex rollout does not begin with session metadata")
    session_id = payload.get("id")
    if not nonblank(session_id):
        raise ValueError("Codex rollout metadata has no session id")
    # A UUID in the filename must agree with the authoritative metadata.
    encoded = re.search(
        r"[0-9a-fA-F]{8}(?:-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}",
        Path(value).name,
    )
    if encoded and encoded.group().lower() != session_id.lower():
        raise ValueError("Codex rollout filename and metadata disagree")
    return session_id


def codex_title(session):
    session_id = codex_id(session)
    home = Path(os.environ.get("CODEX_HOME") or "~/.codex").expanduser()
    title = None
    index = home / "session_index.jsonl"
    if index.is_file():
        with index.open(encoding="utf-8") as entries:
            for line in entries:
                try:
                    entry = json.loads(line)
                except json.JSONDecodeError:
                    continue
                if isinstance(entry, dict) and entry.get("id") == session_id:
                    title = entry.get("thread_name")
        if nonblank(title):
            return title
    versions = []
    for path in home.glob("state_*.sqlite"):
        match = re.fullmatch(r"state_([0-9]+)\.sqlite", path.name)
        if match and path.is_file():
            versions.append((int(match.group(1)), path))
    if versions:
        # Only the current schema file is authoritative; never use older copies.
        path = max(versions, key=lambda item: item[0])[1]
        try:
            return database_title(
                path, "SELECT name FROM threads WHERE id = ?", session_id
            )
        except sqlite3.OperationalError as error:
            raise ValueError(f"Codex session name unavailable: {error}") from error
    return None


def resolve(info):
    agent = info.get("agent")
    session = info.get("agent_session")
    if session is not None:
        if not isinstance(session, dict) or session.get("agent") != agent:
            raise ValueError("Agent session identity does not match the agent")
    if agent == "codex":
        if session is None:
            raise ValueError("Codex requires an exact session identity")
        return codex_title(session)
    if agent == "opencode":
        if session and session.get("kind") == "id" and nonblank(session.get("value")):
            home = Path(os.environ.get("XDG_DATA_HOME") or "~/.local/share").expanduser()
            return database_title(
                home / "opencode/opencode.db",
                "SELECT title FROM session WHERE id = ?",
                session["value"],
            )
        terminal_title = info.get("terminal_title_stripped")
        if isinstance(terminal_title, str) and terminal_title.startswith("OC | "):
            return terminal_title[len("OC | "):]
        raise ValueError("OpenCode has no exact session id or chat title")
    raise ValueError("Unsupported agent")


def main():
    try:
        info = json.load(sys.stdin)
        if not isinstance(info, dict):
            raise ValueError("Agent information must be a JSON object")
        title = resolve(info)
        if not nonblank(title):
            raise ValueError("No nonblank title exists for the exact chat session")
        print(title)
    except (OSError, ValueError, TypeError, sqlite3.Error) as error:
        print(f"session-title: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
