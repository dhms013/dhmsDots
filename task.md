# Task: Port Omarchy shell framework -> dhms shell

Goal of this effort (started in chat "analyze the quickshell in omarchy/"):
adopt the omarchy Quickshell architecture (plugin host, registry-driven bar,
Commons/Ui kits, shell.json persistence, IPC surface) as OUR shell, rebranded
and wired to our own ecosystem. Adjustments/compat can follow later.

## Locations

- Framework source (read-only reference): `omarchy/shell/`
- NEW ported shell (live here, stowed): `.config/shell/`  (repo root, i.e.
  `~/.dhmsDots/.config/shell`, stowed by stow to `~/.config/shell`)
- IPC wrapper bin: `bin/dhms-shell`  (forwards `qs ipc` calls, like omarchy-shell)
- Old shell (still at `quickshell/.config/quickshell/`) stays untouched until
  switchover is decided.

## Corrections from user (2026-08-24)

1. RESOLVED: shell lives in stow package `shell/` → repo path
   `~/.dhmsDots/shell/.config/shell`, stowed to `~/.config/shell`
   (add "shell" to STOW_PKGS in packages/scripts/dotfiles.sh).
2. This desktop PC has NO battery and NO fingerprint reader: `dhms.battery` goes
   into disabledPlugins + no battery widget in default layout; fingerprint menu
   rows carry `when:` guards so they self-hide here; per-device tuning later on
   the laptop.
3. Analyze `bin/` vs `omarchy/bin/`; write new `bin/dhms-*` scripts for every
   omarchy helper the shell still needs, instead of only inlining logic.

## Rebrand mapping (applied)

| Omarchy                                   | Ours                                        |
|-------------------------------------------|---------------------------------------------|
| `$OMARCHY_PATH` env                        | `$DHMSDOTS_PATH` (fallback `$HOME/.dhmsDots`)|
| `omarchyPath` QML property                 | `dotsPath`                                  |
| Plugin ids `omarchy.*`                     | `dhms.*`                                    |
| Layer namespaces `omarchy-*`               | `dhms-*`                                    |
| `~/.config/omarchy/{shell.json,plugins,shell.toml}` | `~/.config/quickshell/{...}`       |
| `~/.local/state/omarchy/`                  | `~/.local/state/dhms/`                      |
| Theme dir `<...>/omarchy/current/theme`    | `$HOME/.config/themes/current/theme`        |
| Current background link                    | `$HOME/.config/themes/current/background`   |
| Backgrounds dir                            | `$HOME/.config/themes/current/theme/backgrounds` |
| Bundled default shell.json                 | `shell/config/shell.json`                   |
| Menu definition (defaultMenuPath)          | `shell/plugins/menu/menu.jsonc` (in-tree; NO userMenuPath / extensions merge) |

## Script reuse (point 4) — bin analysis done

NEW `bin/dhms-*` scripts ported from `omarchy/bin/` (rebranded, bash -n clean):

- IPC wrappers: `dhms-shell` (paths fixed → `$DHMSDOTS_PATH/shell/.config/shell`
  with `~/.config/shell` fallback), `dhms-menu`, `dhms-osd`,
  `dhms-notification-send` (app_name `dhms-action`)
- Audio: `dhms-audio-{output-set-default,input-set-default,output-sink,
  sink-availability,audio-tuning}` (wpctl/pactl based)
- Network: `dhms-network-status`, `dhms-network-band`, `dhms-dns` (sudoers
  machinery rebranded; polkit fallback works without shipping sudoers file)
- Monitor/brightness: `dhms-monitor-state`, `dhms-display-text-size`,
  `dhms-hyprland-monitor-scaling`, `dhms-brightness-display`,
  `dhms-brightness-keyboard` (brightnessctl/ddcutil present)
- Power: `dhms-powerprofiles-list/set`, `dhms-system-stats`
- Guards/helpers: `dhms-cmd-present/missing`, `dhms-pkg-present/missing`,
  `dhms-hw-laptop-closed`, `dhms-toggle-nightlight`,
  `dhms-weather-icon/location` (state under ~/.local/state/dhms)
- Adapted: `dhms-theme-bg-set` (symlink to
  ~/.config/themes/current/background + background-set + shell IPC)

Deliberately NOT ported (retired plugins / replaced in QML):
- battery*, lock-fingerprint/password, clipboard-paste/open, reminder daemon,
  tailscale-send, voxtype, wifiqr/network-qr,
  default-agent/browser/editor/terminal, channel-current, speed-test overlay
  script (namespace-only), menu-timezone + capture-screenrecording +
  theme/bg-switchers + launch-floating-terminal-with-presentation (QML now uses
  floating-terminal / screenrecord / dhms-shell summons directly)
- fonts ecosystem dropped entirely

Ported later (2026-08-25): dhms-network-speedtest, dhms-disk-speedtest,
dhms-hyprland-session-locked, dhms-system-wake (for lock + speedtest panels).

Remaining omarchy-string matches in shell tree are provenance comments only.

## Menu (point 5)

`menu.jsonc` mirrors `quickshell/.config/quickshell/launcher/MenuData.qml` tree:
Update / Setup{Background,DNS,Docker,Install{Packages,Themes},Power Profile,
Remove,Themes,Timezone,Security{Fingerprint,Fido2}} / System{Suspend,Lock,
Logout,Reboot,Shutdown}. Providers kept: `apps` (native), `power-profiles`,
new `themes`. Fonts provider dropped. userMenuPath support deleted.

## Deliberately disabled by default (missing deps/conflicts/hardware)

All plugin dirs for disabled features have been deleted (idle, nightlight,
reminders, agents, tailscale, dropbox, wifiqr). `disabledPlugins[]` is empty.
Battery plugin is enabled but its indicator auto-hides on this desktop
(no `/sys/class/power_supply/BAT*`); reappears on laptop. Lock is enabled —
active lock is hyprlock (`/etc/pam.d/hyprlock` present, works on desktop +
laptop); the Quickshell overlay lock is dormant and would need
`/etc/pam.d/dhms-lock-password` if ever wired (see "Pending adjustments"
item 2). Fingerprint menu row self-hides via `when:` guard.

## Pending adjustments (LATER, do not forget)

1. DONE (2026-08-24): switchover executed — stow package `shell` linked,
   autostart.lua + restart-services launch `quickshell -p ~/.config/shell`,
   keybindings.lua rewired to dhms-shell IPC (see "Switchover" section).
   Old quickshell dir untouched but no longer launches.
2. PENDING (2026-08-29): PAM for the Quickshell overlay lock —
   `/etc/pam.d/dhms-lock-password` missing on both machines. Only matters if
   the shell lock overlay (`plugins/lock/`, `PamContext` config
   "dhms-lock-password", Service.qml:321) is ever wired in — it is currently
   unbound and `dhms-shell shell lock` returns "missing-pam". hyprlock (the
   active lock, SUPER+CTRL+L) uses its own `/etc/pam.d/hyprlock` and works
   today on desktop (password) + laptop (fingerprint). If/when wanted:
   `sudo cp /etc/pam.d/system-login /etc/pam.d/dhms-lock-password` per machine.
   Fingerprint PAM (`dhms-lock-fingerprint`) optional.
3. Idle strategy stays as-is (system hypridle + toggle-idle via StayAwake
   indicator); nightlight needs gammastep/hyprsunset backend — deferred.
4. Retire old `quickshell/.config/quickshell` once user decides; migrate any
   wanted pieces (KeybindViewer SUPER+SHIFT+/, notification panel SUPER+N,
   clear-notifications SHIFT+DEL — binds commented out in keybindings.lua).
5. `install.sh`: ensure `DHMSDOTS_PATH=$HOME/.dhmsDots` exported in session env
   (uwsm env). STOW_PKGS already includes "shell".
6. Theme pipeline: `theme-set` should also push colors via
   `dhms-shell shell applyTheme <b64 colors> <b64 shell>` for live reload
   (or rely on shell restart initially).
7. AppLibrary "remove launcher entry" is a no-op until we write an equivalent
   of omarchy-remove-launcher-entry.
8. Laptop: fingerprint rows/PAM, per-device plugin tuning (battery already
   enabled — indicator auto-hides when no /sys/class/power_supply/BAT*).
9. DNS: optionally ship etc/sudoers.d/dhms-dns + install dhms-dns to /usr/bin
   for passwordless provider switching (works via polkit today).
10. DONE (2026-08-29): `inotify-tools` installed → PluginRegistry live-watches
    `~/.config/dhms/plugins`. Hot-reload now works; `dhms shell rescanPlugins`
    also stays available to force a re-walk.

## Switchover (done 2026-08-24)

- `stow shell` → `~/.config/shell` live; production path everywhere is the
  STOWED one: quickshell matches IPC instances by exact `-p` string, so
  autostart and bin/dhms-shell both use `$HOME/.config/shell` (wrapper falls
  back to repo path when unstowed).
- `restart-services` left generic; NEW `bin/restart-quickshell` handles the
  shell bounce (keybind SHIFT+ALT+DEL + hypridle on_unlock_cmd use it).
- New bins: `dhms-audio-output-volume`, `dhms-audio-input-mute`,
  `dhms-brightness-keyboard-mute` (media keys with OSD).
- keybindings.lua: apps/menu/power/emoji/background/themes/screenrecord +
  volume/brightness/mic all via dhms-shell or new scripts; SUPER+N,
  SHIFT+DEL, SUPER+SHIFT+/ commented out pending migration.
- Verified live: menu routes toggle open/closed, emoji + image-picker toggles,
  volume 100→95% with OSD, mic mute toggle, brightness step, lua syntax OK,
  hyprctl reload clean.

## Drill-height freeze + System icon (2026-08-25 late night V)

Issue 1: root→Setup/System drill showed only ~2 items; direct summon (SUPER+ESC)
showed full 5. Root cause: freezeCardTop() pins maxRowsHeight to the OPENING
view's content height; drilldown inherited root's 3-row ceiling. Omarchy's root
is big so it never bites them; with our small root + menu.maxRows config it does.
Fix: skip the freeze ceiling when maxVisibleRows > 0 — a fixed-viewport menu
is supposed to grow to its cap on every level, not inherit the opening view's
smaller size. (freezeCardTop still runs so cardTop/position is stable; only
maxRowsHeight is ignored.)

Issue 2: System menu missing icon — I wrote empty "" in the menu.jsonc rebuild.
Omachy's original icon is U+F011 (nerd-font power glyph ef 80 91). Patched
via python; confirmed UTF-8 encoding correct, JSONC still parseable.

## Corrections round: theme keybind + menu structure (2026-08-25 late night IV)

- SUPER+CTRL+SHIFT+SPACE opened the custom menu because themePicker routed to
  {"menu":"setup.themes"} — a route deleted in the omarchy-layout rebuild →
  fell back to root. Fixed: themePicker now runs the switcher pipe directly
  (`theme=$(dhms-theme-switcher); [ -n "$theme" ] && theme-set "$theme"`,
  POSIX test since Hyprland exec uses sh). Cancel path verified end-to-end:
  picker opens, hide → done-file written empty → script exits without apply
  (ImagePicker.cancel() → finishDoneFile; never use image-selector apply()
  hook for themes — it relinks the WALLPAPER).
- User corrected task-1 answer: menu is NOT omarchy's flat layout. Restored
  their original tree: root = Update / Setup / System only;
  Setup => Background, DNS, Docker, Install{Packages,Themes}, Power
  Profiles(provider: Performance/Balance/Power-Saver), Remove, Timezone,
  Security{Fingerprint,Fido2}; System => Suspend, Lock, Logout, Reboot,
  Shutdown. No separate Themes provider entry (Install>Themes covers install).
  Root hugs at 3 rows; Setup caps at maxRows=5 + scroll; min 1 row floor.
- All routes re-verified post-rebuild (root/setup/.security/.install/
  .power-profile/system); binds table shows themes bind registered.

## Four-task batch: menu layout, theme picker, missing scripts, StayAwake (2026-08-25 late night III)

User brief: (1) custom menu same layout as omarchy's; (2) theme picker =
background-picker image grid (see omarchy's); (3) fix missing components
(monitor brightness slider!); (4) wire bar StayAwake indicator to toggle-idle.

### Task 3 — missing components / unported scripts
- Systematic sweep: grep'd every `dhms-X` reference in shell tree vs bin/.
  Root cause of missing brightness slider: `dhms-brightness-display` calls
  dhms-brightness-display-ddc / -apple / dhms-hyprland-monitor-focused-apple /
  dhms-hw-display which were NEVER PORTED → exit 127 → state "unavailable" →
  Panel hides slider. Monitor (Xiaomi P27FBB on HDMI-A-1) DOES support DDC/CI.
- Ported (sed omarchy→dhms): dhms-hw-display, dhms-hyprland-monitor-focused-apple,
  dhms-brightness-display-ddc (cache dir renamed), dhms-brightness-display-apple,
  dhms-cmd-present/missing, dhms-pkg-present/missing, dhms-battery-status,
  dhms-battery-low (dhms-hook line dropped), dhms-clipboard-{open,paste-file,paste-text}
  (state paths align: ~/.local/state/dhms/clipboard-history.json).
- Wrote fresh: bin/dhms-toggle-bar (writes/removes
  ~/.local/state/dhms/toggles/bar-off; Bar.qml already watched it).
- VERIFIED: ddc read=15%, set 15% ok, monitor-state line1=15 (slider will show);
  guards exit codes correct; toggle-bar off/on flips hyprland reserved 0x24↔0x0.
- Bar.qml hardening while there: toggles-dir FileView re-arm + 5s fallback
  probe Timer (watcher-drop disease again).
- NOTE discovered: monitor sits at 0x-1080 in Hyprland global layout — layer
  y=-1080 is NORMAL here; use `hyprctl monitors | grep reserved` to check bar.

### Task 4 — StayAwake ↔ toggle-idle
- Rewrote plugins/bar/indicators/StayAwake.qml: no more dhms.idle service
  (disabled); pgrep hypridle probe Process (5s Timer + 600ms post-click),
  active = hypridle STOPPED ("Stay Awake"), click runs Util.execDetached("toggle-idle").
- Verified cycle: toggle-idle start→RUNNING→stop→STOPPED; indicator reads same signal.

### Task 2 — theme picker as image grid (omarchy parity)
- Ported omarchy-menu-images → bin/dhms-menu-images: rows cache/signature
  machinery identical, thumbnails via MAGICK (list.sh recipe, shared cache
  ~/.cache/dhms/image-selector/index.tsv), IPC = dhms-shell image-selector
  open "" rowsB64 selected selectionFile doneFile showLabels filterable;
  blocks on done_file; --print-name prints basename-minus-extension.
- Wrote bin/dhms-theme-switcher: previews from ~/.config/themes/themeLists/*
  (preview.png else first background), symlink farm in
  ~/.cache/dhms/theme-selector/previews, fast-signature rebuild guard,
  current-theme preselect from ~/.config/themes/current/theme.name,
  exec dhms-menu-images --print-name --show-labels --filterable
  --lazy-thumbnails --selected X preview_dir.
- VERIFIED: all 10 themes symlinked; picker layer opened (timeout-blocked as
  designed); close via `dhms-shell shell hide dhms.image-picker`.
- Apply pattern (omarchy parity): `theme=$(dhms-theme-switcher); [[ -n $theme ]] && theme-set "$theme"`.

### Task 1 — custom menu layout = omarchy's structure
- Rebuilt plugins/menu/menu.jsonc with omarchy root order:
  apps(hidden)/learn/trigger/style/setup/install/remove/update/system
  (about omitted — no backend). Content adapted: learn=keybinds+wikis(target links),
  trigger=screenshot/screenrecord, style=background+theme-switcher pipe,
  install=packages/themes (moved out of setup), remove=pkg-remove at root,
  setup keeps dns/docker/timezone/power-profile/security.*.
- VERIFIED: jsonc loads clean, root opens, all six submenu routes summon.

### Enabled battery + clipboard per user
- Removed dhms.battery/dhms.clipboard from BOTH shell.json disabledPlugins
  (fixed trailing-comma breakage sed introduced; both files JSON-valid).
- Battery shows nothing until laptop (no /sys/class/power_supply BAT here).

### Plugin status (updated 2026-08-25)

All enabled plugins: battery, clipboard, lock, speedtest, disk-speedtest, dns,
docker, power-profiles, timezone, security, volume, brightness, monitor, network,
notifications, menu, image-picker, app-library, bar, background, stay-awake,
dnd, screen-recording, polkit, app-launcher.

**Retired entirely** (dirs + indicators deleted, no longer available):
- dhms.idle — system hypridle + toggle-idle is the workflow.
- dhms.reminders, dhms.agents — never ported; user did not request.
- dhms.nightlight — needs gammastep/hyprsunset backend; deferred.
- dhms.tailscale, dhms.dropbox, dhms.wifiqr — service/package deps absent; no demand noted.

**Lock PAM prerequisite**: lock plugin is enabled and SUPER+CTRL+L bound,
but PAM authentication requires `/etc/pam.d/dhms-lock-password` to be
created on each machine (needs sudo). Without it the lock screen displays
but cannot authenticate. Create via:
```
sudo cp /etc/pam.d/system-login /etc/pam.d/dhms-lock-password
```
(fingerprint is optional — guarded by PAM file + fprintd presence).

## AppLibrary.remove implemented + FileView persistence bugs found (2026-08-25 late night II)

- AppLibrary.remove was a deliberate stub ("no equivalent of
  omarchy-remove-launcher-entry"). Implemented as hide-not-uninstall: append
  normalized id to config/launcher.hides (the 38-entry file the user already
  hand-curates). omarchy's script is a real uninstaller (pacman -Rns /
  flatpak, sudo prompts) — out of scope by design here.
- BUG 1 (silent, pre-existing): hides FileView path used `root.shellPath`
  which doesn't exist on the Item → literal "undefined/config/launcher.hides"
  → the user's curated hide file was NEVER loaded. Fixed to
  Quickshell.shellDir (precedent: hiddenEntryScanCommand line ~169).
  Consequence: btop & co now actually filtered.
- BUG 2 (API): quickshell 0.3.x FileView has NO save(); setText() only
  stages; writeAdapter() writes. text() returns last LOADED content — not
  staged text. External-edit notifications need reload(). Same latent bug in
  plugins/notifications/Service.qml flushSettings (DND never persisted!),
  plugins/clipboard/Clipboard.qml saveHistory, plugins/agents/Main.qml
  writeSyncSnapshot — all got writeAdapter() added.
- Watcher re-arm (wallpaper lesson) applied: atomicWrites swaps inode →
  watch dies; onFileChanged re-arms then reload().
- New IPC target "app-library": ping / hide(id) / hidden(id) — closed-loop
  testable + scripted curation.
- Verified: hide→disk+memory ✓; external append seen ✓; external ATOMIC
  replace seen ✓ (re-arm works); log clean after restart.
- E2E pending: notifications DND toggle via UI (no IPC target for it).

## Menu viewport: maxRows knob (2026-08-25 late night)

- User goal: dhms-menu card shows AT MOST 5 items (scroll for the rest),
  never shorter than 1 item (search-empty keeps one row — count===0 branch
  already returned baseRowHeight; close-transition frames show the 46px
  floor live).
- Why their 0.7 edit "did nothing": (a) QML needs restart-quickshell, no
  hot-reload; (b) card is content-sized — availableRowsHeight's 0.7 is only
  a scroll ceiling, not a target height.
- Implemented: shell.json `menu.maxRows` (Menu.qml menuConfig/maxVisibleRows;
  rowListHeight iterates min(count, maxVisibleRows) rows → fixed viewport;
  ListView scrolls overflow). Default 5 in config/shell.json AND user
  ~/.config/shell/shell.json (USER FILE REPLACES DEFAULTS WHOLESALE — no
  deep-merge by design; defaults-only knobs get silently shadowed!).
  Removed my speculative rowHeightFloor/maxHeightPercent knobs.
- Verified via temporary MENU-DEBUG log line (removed after): root 3 items →
  natural 46/95/144px growth; apps 26 items → constant listH 242 (exactly
  5-row viewport); teardown frames floor at 46px.

## SUPER+SPACE apps launcher restored via hidden route (2026-08-25 night)

- Root cause of "both keys open custom menu": #7's Apps removal killed the
  {"menu":"apps"} route, so SUPER+SPACE fell back to root. (Note: our binds
  are intentionally swapped vs omarchy upstream — user wants
  SUPER+SPACE=apps, SUPER+ALT+SPACE=menu; omarchy is the reverse.)
- MenuModel.js: entries now carry `hidden` (parsed from jsonc); isVisible()
  returns false for hidden → excluded from parent listings AND search.
- menu.jsonc: apps node re-added with "hidden": true — routable but invisible.
- keybindings.lua unchanged (apps var already routes {"menu":"apps"}).
- Verified: toggle dhms.menu {"menu":"apps"} opens the apps view; closes
  clean; zero errors.

## Seven-issue batch (2026-08-25)

1. BAR THEMING FIXED: theme-template gained push_shell_theme() — base64 of
   current/theme/{colors.toml,shell.toml} → `dhms-shell shell applyTheme`.
   Created ~/.config/themes/themed/shell.toml.tpl from omarchy's with 3
   exotic tokens flattened (shell_gradient→accent/foreground,
   mix→foreground) since user's sed engine handles only simple {{key}}.
   Verified: bar bg color shifts live across catppuccin/nord/tokyo-night.
2. DNS DEDUPED: dhms-dns (NM-based, wrong backend) DELETED; setup-dns
   (resolved-based, user's) kept + gained `current` subcommand (parses
   resolved.conf → Cloudflare/Google/DHCP/Custom). Callers repointed:
   MenuModel.js GUARD_READERS "setup-dns current", network Panel.qml
   dnsCommand/Custom.
3. TEXT-SIZE SLIDER FIXED: Color.qml user shell.toml path was stale
   (~/.config/quickshell/ → ~/.config/dhms/) — script wrote one file, shell
   watched another, so base-size never persisted and slider recentered.
   Also fixed same-class stale paths: Bar.qml qsConfigDir → ~/.config/dhms;
   PluginRegistry.qml pluginsDir → ~/.config/dhms/plugins (+comment).
   Verified live: bar height 24→35px@16pt→26 via file watch.
4. FINGERPRINT EXPLAINED (not a bug): menu guard is [[ -d /usr/lib/fprintd ]];
   desktop has no fprintd pkg/dir/USB reader (lsusb empty), so entry hides
   by design — same behavior as omarchy's omarchy-hw-fingerprint guard.
   Reappears automatically if fprintd gets installed.
5. MENU HEIGHT KNOB: plugins/menu/Menu.qml availableRowsHeight() caps at
   Math.round(panel.height * 0.7) (~line 158) — raise that factor for taller
   menus; panel.maxRowsHeight additionally caps drilled submenus.
6. SHOW KEYBINDS IMPLEMENTED: ported omarchy-menu-select → dhms-menu-select
   (drives dhms.menu select-mode payload w/ selection/done files) and
   omarchy-menu-keybindings → dhms-menu-keybinds (669-line interactive
   searchable browser+dispatcher; handles fork's __lua binds via lua cache +
   xkbcli keycode resolution; --print mode verified outputting SUPER+Q etc).
   Wired SUPER + K in keybindings.lua (omarchy parity), hyprctl reload done,
   menu layer summon verified.
7. APPS REMOVED from custom menu.jsonc (root now starts at Update); apps
   provider still registered for future use.

Also: restart-quickshell run after path fixes; old ~/.config/quickshell/
dir still pending retirement (empty plugins/, stale shell.json inside).

## background-set + theme-template parity (2026-08-25)

- User rewrote background-set themselves (awww line → dhms-shell -q background
  set). I added realpath + file-exists validation (omarchy parity), removed
  stale swaybg comment. Error cases verified (usage / nonexistent → rc=1,
  symlink untouched).
- theme-template set_background BUG: pushed $LINKED_BG (the constant symlink
  path) over IPC → shell's string-equality guard treated every switch after
  the first as no-op; only watcher fallback repainted. Fixed: resolve real
  target via find, ln -nsf it, push RESOLVED path.
- Also: notify-send placeholder ("check doesnt-exists") → proper message;
  plain ln -sf → ln -nsf for consistency.
- Live regression: 3 consecutive theme-set runs (tokyo-night→catppuccin→nord→
  tokyo-night): each flipped theme.name, linked correct sorted-first bg
  (space-in-filename safe: "1-neon box.jpg"), repainted instantly via IPC.
- KNOWN PENDING (likely user's next issue): shell COLORS/bar/menu do not
  re-theme after theme-set — applyTheme colorsB64 push not wired yet.

## Two real bugs: wrong IPC name + Qt watch drop (2026-08-24 late night)

- User asked if awww daemon runs: NO process (already removed at switchover);
  wallpaper renderer is the shell alone.
- Bug 1: applyExternal called IPC method "set-instant" but Background.qml's
  function is setInstant → "Function not found." — hidden by -q in my earlier
  chain test (false APPLY-CHAIN-OK). Fixed to setInstant. Lesson: never trust
  -q for verification.
- Bug 2: Qt FileView DROPS its file watch after ln -nsf atomically replaces
  the symlink inode → only the FIRST swap per session fired; later swaps
  needed a shell restart. Fixed by re-arming in onFileChanged
  (watchChanges=false; true) before refreshBackground().
- Verified: 3 consecutive symlink swaps all repaint (hash per swap); picker
  path changes screen within 400ms via setInstant push (watcher is the ~1s+
  fallback); no stderr since fix. Restored user's wallhaven PNG pick.

## Root cause found: execDetached no-op + omarchy architecture (2026-08-24 night)

- Omarchy analysis (user asked): NO swaybg anywhere current (only stale
  mention in omarchy-upgrade-to-quattro migration). Backend = the shell
  itself renders (Qt); `awww` exists on system but is NOT in the bg-set
  chain. omarchy-theme-bg-set = `ln -nsf` + immediate
  `omarchy-shell -q background set <path>` IPC push ("plugin also polls this
  symlink, but IPC avoids the visible delay"). bgSwitchProc (QML Process)
  blocks on picker selection then calls bg-set.
- THE BUG: Quickshell.execDetached silently does nothing on quickshell 0.3.1
  — every apply since the first fix spawned nothing. Manual CLI tests passed
  because they bypassed execDetached.
- Fix: ImagePicker.applyExternal(path) uses a real QML Process
  (externalApplyProc) running
    ln -nsf <pick> ~/.config/themes/current/background && dhms-shell background set-instant <pick>
  applySelected fallback → applyExternal. stdout/stderr collected to
  console.warn for debugging.
- Test hook: shell.qml image-selector IPC target gained apply(path) →
  picker.applyExternal. VERIFIED END-TO-END through this exact code path:
  dhms-shell image-selector apply <ship-at-sea> → symlink flipped + pixel-
  hash changed instantly, no restart. Restored glowing-city after test.

## Apply rewrite — deterministic (2026-08-24 late)

- Forensics: user's picks DO fire applySelected (console.info lines in qslog);
  background-set + watcher + IPC each verify green in isolation, yet user saw
  no change. Removed all moving parts from the apply path:
  applySelected fallback now runs
    `ln -nsf <pick> ~/.config/themes/current/background && dhms-shell -q background set-instant <pick>`
  via Util.execDetached. Symlink written directly (persistence) + instant
  in-shell transition (display) — no reliance on watcher, external script,
  or awww.
- QML gotcha recorded: ImagePicker.qml uses bare `home` (resolves through QML
  context chain to shell.qml root property). `root.home` would be a TypeError.
- Fixed stale shell.qml userConfigPath: ~/.config/quickshell/shell.json →
  ~/.config/shell/shell.json.
- Verified exact apply command chain end-to-end: APPLY-CHAIN-OK, symlink flips,
  set-instant transitions instantly. Awaiting user click test.

## Picker delay + apply fixes round 2 (2026-08-24)

- Delay root cause: list.sh only LOOKED UP cached thumbnails (nothing ever
  generated them — no vips on this system, and omarchy's generator lives in
  omarchy-menu-images which we replaced). Picker decoded 81 full-res images
  every open. Rewrote list.sh: magick-based thumbnail generation (1536x864
  cover-crop, Q=82, strip, MAGICK_THREAD_LIMIT=1, flock-guarded, xargs -P
  nproc), index.tsv mapping by path+size+mtime signature. NOTE ImageMagick 7
  spelling: `-gravity center` (not centre). First open primes cache (~4s),
  subsequent opens scan in ~0.2s (measured).
- Apply robustness: fallback now uses Util.execDetached("background-set "
  + shellQuote(path)) — bash -lc guarantees profile PATH; plus console.info
  log line "ImagePicker applying selection: <path>" in qslog for debugging.
  Verified systemd user env PATH includes ~/.dhmsDots/bin.
- Cleaned up 6 orphaned PluginRegistry parker processes from repeated
  restarts (pkill -f 'command -v inotifywait').

## Image picker fixes (2026-08-24)

1. Direct-summon apply: old code cancelled silently when no selectionFile was
   provided (keybind/menu summons) — this was the "background won't update"
   bug. applySelected() now falls back to `background-set <path>` when no
   selection file exists; the Background symlink watcher crossfades it in.
2. Second source dir restored (parity with old quickshell): imageDirs default
   is now newline-separated `~/.config/themes/current/theme/backgrounds` +
   `~/Pictures/backgrounds` — list.sh consumes newline-delimited dirs.
   Verified both dirs appear in scan output.
- Also cleaned up a double-instance situation (old session instance + test
  instance fighting over org.freedesktop.Notifications/polkit). Single instance
  via restart-quickshell now owns both buses.

## Backend alignment (2026-08-24)

- AUR helper: non-issue — nothing ported references yay; user's own scripts
  (pkg-*, theme-install, dhms-update) already use paru.
- Wallpaper: shell OWNS it. dhms.background renders natively (Qt crossfade
  layers); awww-daemon removed from autostart.lua. Background.qml now watches
  ~/.config/themes/current/background (FileView watchChanges → refresh), so
  plain `background-set` applies live — verified by pixel-hash diff of grim
  shots across a symlink swap with no daemon and no IPC call.
- Note: background-set's `awww img` line errors harmlessly while the daemon is
  absent ("Socket file ... not found"); symlink still lands first. Optionally
  guard that line later.

## Bin dedup (2026-08-24)

Deleted as duplicates/remnants:
- `dhms-theme-bg-set` (background-set already symlinks + awww; IPC push dropped)
- `dhms-pkg-present/missing`, `dhms-cmd-present/missing` — MenuModel.js defines
  these as inline bash functions for guard evaluation; bins were redundant
- `dhms-menu` (no callers; dev-gallery entry now shows dhms-shell)

Kept after analysis (NOT duplicates):
- `dhms-brightness-display/keyboard(+mute)` — user's `brightness` lacks
  per-monitor/--no-osd/OSD/ddcutil-per-display features the monitor panel needs
- `dhms-dns` — programmatic provider switching for the network panel;
  `setup-dns` stays the interactive wizard
- `dhms-notification-send` — rich wrapper (glyph hints, app_name=dhms-action
  silencing rules); plain notify-send can't carry those
- everything else has no existing equivalent (audio family, bluetooth,
  monitor trio, powerprofiles, system-stats, weather, hw-laptop-closed)

## Lock/speedtest/disk-speedtest enablement + plugin cleanup + monitor fix (2026-08-25 late night VI)

User brief: enable lock + speedtest + disk-speedtest; remove unused plugins/indicators; fix monitor position.

### Monitor fix — stale duplicate rule
- `monitors.lua` had TWO `HDMI-A-1` entries: correct one (`position = "auto"`,
  `mode = "1920x1080@165.00"` at line 13) + stale one (`position = "0x-1080"`,
  `mode = "preferred"` at line 20). Hyprland applies LAST match → always the
  stale rule → monitor stuck at 0x-1080 offset.
- Fix: replaced both with a catch-all rule (`output = ""`, `mode = "preferred"`,
  `position = "auto"`) + the specific HDMI-A-1 165Hz rule. Works for any
  docking combo (laptop eDP, external DP, unknown future monitors) without
  hardcoded positions.

### Lock plugin enabled
- Ported from omarchy: `dhms-hyprland-session-locked` (jq-based Hyprland
  solitaryBlockedBy lock probe), `dhms-system-wake` (brightness restore).
  lock-password/lock-fingerprint are NOT separate scripts — they're PolkitAgent
  config names (`PamContext.config`) referencing `/etc/pam.d/dhms-lock-password`.
- Lock is safe to enable because: idle service is disabled → no auto-lock;
  SUPER+CTRL+L manual invoke only → user won't get stuck without PAM.
- **Prerequisite noted in task.md**: PAM file must be created per-machine
  with sudo; lock screen shows but can't authenticate without it.

### Speedtest + disk-speedtest panels enabled
- Both are panel plugins (manifest.json kind: "panel"), not standalone services.
  Speedtest calls `dhms-network-status` (portable, already in bin) +
  `dhms-network-speedtest` (curl-based, just ported from omarchy).
  Disk-speedtest calls `dhms-disk-speedtest` (just ported; pure bash, no deps).
- Both panels use the gauge-cluster overlay (qs.Ui.SpeedTestOverlay);
  `dhms-network-status` is already present on this system.

### Plugins + indicators retired
Deleted plugin dirs: `plugins/services/idle`, `plugins/services/nightlight`,
`plugins/agents`, `plugins/reminders`, `plugins/panels/dropbox`,
`plugins/panels/tailscale`, `plugins/panels/wifiqr`.
Deleted indicators: `NightLight.qml`, `Reminder.qml`, `Dictation.qml`
(Dictation depended on dhms-voxtype-status — agents feature, retired).
Remaining indicators: `Dnd.qml`, `ScreenRecording.qml`, `StayAwake.qml`.

`disabledPlugins[]` cleared entirely in both `config/shell.json` and
`~/.config/shell/shell.json`.

### New bin scripts ported
`dhms-hyprland-session-locked`, `dhms-system-wake`, `dhms-network-speedtest`,
`dhms-disk-speedtest` — all sed omarchy→dhms, bash -n clean.

## Screenrecord + DNS batch (2026-08-28)

### Screenrecord
- **Menu** (`plugins/menu/menu.jsonc`): Added `trigger.capture.screenrecord` submenu with 3 options from old quickshell (no audio / desktop audio / desktop+mic), icons `` (old quickshell glyph). Parent menus `Trigger` / `Capture` removed — ALT+PRINT toggles directly.
- **Keybind** (`hypr/.config/hypr/keybindings.lua:22,137`): `ALT+PRINT` runs `screenrecord --stop-recording || dhms-shell shell toggle dhms.menu '{"menu":"trigger.capture.screenrecord"}'` — stops if recording, else opens menu.
- **Indicator** (`plugins/bar/indicators/ScreenRecording.qml`): Auto-refresh every 5s + 600ms post-click probe (mirrors StayAwake pattern). Click behavior matches ALT+PRINT: stop if recording, else toggle menu.
- **Script** (`bin/screenrecord`): Fixed to keep `gpu-screen-recorder` alive (removed `</dev/null >/dev/null 2>&1 & disown` that caused early exit). pgrep `^gpu-screen-recorder` now works for indicator.

### DNS panel
- **Panel.qml `setDns()`**: All 4 pills (DHCP/Cloudflare/Google/Custom) now launch `floating-terminal setup-dns <provider>` via `root.bar.run()`.
- **Probe**: `dnsCommand("")` → `setup-dns current` (non-interactive). `dnsCommand(provider)` builds `setup-dns <provider>`. `pendingDnsProvider` + dead actionProc DNS branch removed.
- **Status**: `floating-terminal setup-dns <provider>` works perfectly from shell → terminal opens, runs `show-logo`, then `setup-dns`, then `show-done` (waits for keypress). **BUT** when invoked from panel via `root.bar.run("floating-terminal setup-dns ...")`, the terminal spawns and immediately closes after `show-logo` — `setup-dns` never runs, `show-done` never reached. The command works perfectly when typed in shell; only fails via panel's `bar.run()` → `Util.execDetached(["bash", "-lc", ...])`.

### Notification shortcuts (kept 3 of 5)
- `SUPER+SHIFT+comma` → dismiss all
- `SUPER+CTRL+comma` → toggle DND
- `SUPER+SHIFT+ALT+comma` → notification history
- Removed: dismiss last, invoke last

## Plugin management suite port + author attribution + bar trim (2026-08-29)

### dhms plugin workflows — full omarchy parity (scope 3, incl. hot-reload)
Ported the whole omarchy shell-plugin CLI suite to `bin/` (sed omarchy→dhms,
bash -n clean, zero omarchy residues):
- `dhms-plugin-{add,catalog,clone,enable,disable,list,remove,update,validate}`,
  `dhms-git-url-check` (transport-helper security gate, allowlist identical),
  `dhms-menu-plugin` (enable/disable/clone/remove picker; clone/remove launch
  our `floating-terminal`, not omarchy's presentation launcher).
- NEW `bin/dhms` CLI that dispatches the `plugin` group: aliases
  `install`→`add`, `rm`→`remove`; help/list/catalog routes through. Only the
  plugin group dispatches today.
- Adaptations vs omarchy (all verified against live runtime):
  - third-party dir `~/.config/dhms/plugins` (PluginRegistry.qml:11); first-party
    tree `$DHMSDOTS_PATH/shell/.config/shell/plugins` (catalog default
    `${DHMSDOTS_PATH:-$HOME/.dhmsDots}`).
  - clone/remove use manifest key `dhms.clonedFrom` / `dhms.clonePaths`
    (update_manifest writes `.dhms = {...}`); registry reads `manifest.dhms`
    (PluginRegistry.qml:152) — not omarchy's `.omarchy`.
  - reserved namespace in validate: `dhms.*` (not `omarchy.*`); catalog
    first-party test `startswith("dhms.")`.
  - IPC via `dhms-shell shell rescanPlugins/enablePlugin/setPluginEnabled/
    listPlugins` (all present in shell.qml).
- E2E verified: `dhms plugin add file:///tmp/... --yes` (clone→validate→install→
  rescan→`list` shows third-party disabled), `dhms plugin remove --yes` (list no
  longer shows it); `git-url-check` refuses `ext::` transport helpers, `-o…`
  options; `validate` rejects reserved `dhms.*`. Real add leaves NO temp junk
  (`.add.tmp.$$` / `.clone.*` / `.bak` cleanup verified).

### dhms.network-speed removed from bar
Dropped the `{ "id": "dhms.network-speed" }` right-layout entry from BOTH
`shell/.config/shell/shell.json` and `~/.config/shell/shell.json` (jq, both
valid, still identical). Widget plugin remains (system-monitor overlay covers
it); network speed visible instead via SystemMonitor.

### Author attribution restored to omarchy
The wholesale rebrand had also overwritten every manifest `author`. Reverted all
32 `"author": "dhms"` → `"author": "Omarchy"` (matching omarchy upstream casing)
across `shell/.config/shell/plugins/**`; `id` values stay `dhms.*`; README's
doc-example `"author": "You"` untouched. The 6 provenance comments in QML/jsonc
that already credit omarchy ("Mirror omarchy's flow", "omarchy's docs/menu.md",
etc.) were deliberately LEFT as omarchy — they are attribution, per user intent.

(End of file - total 551 lines)
