# First-party plugins

These plugins ship with dhms and are discovered by the shell at startup.
They use the same `manifest.json` contract as third-party plugins; the
only difference is that the shell flags them with `__isFirstParty: true`.
First-party non-bar plugins are enabled unless listed in `disabledPlugins[]`;
`dhms.bar` is the default bar option and becomes inactive only while another
`kind: "bar"` plugin is selected. Services and keep-loaded panels are mounted
at startup; other panels, overlays, and menus are loaded on demand.

User-installed plugins live alongside these conceptually but on disk under
`~/.config/dhms/plugins/<plugin-id>/` rather than in this directory.

| Plugin           | id                        | kinds                     | entry point                                            |
|------------------|---------------------------|---------------------------|--------------------------------------------------------|
| Audio            | `dhms.audio`              | `bar-widget`              | `panels/audio/Panel.qml`                               |
| Background       | `dhms.background`         | `service`                 | `background/Background.qml`                            |
| Bar              | `dhms.bar`                | `bar`                     | `bar/Bar.qml`                                          |
| Battery          | `dhms.battery`            | `service`                 | `services/battery/Service.qml`                         |
| Bluetooth        | `dhms.bluetooth`          | `bar-widget`              | `panels/bluetooth/Panel.qml`                           |
| Clipboard mgr    | `dhms.clipboard`          | `overlay`                 | `clipboard/Clipboard.qml`                              |
| Clock            | `dhms.clock`              | `bar-widget`              | `panels/clock/BarWidget.qml`                           |
| dhms menu        | `dhms.menu`               | `menu`, `bar-widget`      | `menu/Menu.qml`, `menu/BarWidget.qml`                  |
| Dev gallery      | `dhms.dev-gallery`        | `panel`                   | `dev-gallery/GalleryPanel.qml`                         |
| Disk speed test  | `dhms.disk-speedtest`     | `panel`                   | `panels/disk-speedtest/Panel.qml`                      |
| Emojis           | `dhms.emojis`             | `overlay`                 | `emojis/Emojis.qml`                                    |
| Image picker     | `dhms.image-picker`       | `overlay`                 | `image-picker/ImagePicker.qml`                         |
| Lock screen      | `dhms.lock`               | `service`                 | `lock/Service.qml`                                     |
| Media            | `dhms.media`              | `service`, `bar-widget`   | `services/media/Service.qml`, `services/media/BarWidget.qml` |
| Monitor          | `dhms.monitor`            | `bar-widget`              | `panels/monitor/Panel.qml`                             |
| Network          | `dhms.network`            | `bar-widget`              | `panels/network/Panel.qml`                             |
| Notifications    | `dhms.notifications`      | `service`                 | `notifications/Service.qml`                            |
| OSD              | `dhms.osd`                | `panel`                   | `osd/Osd.qml`                                          |
| Polkit agent     | `dhms.polkit`             | `service`                 | `polkit/PolkitAgent.qml`                               |
| Power            | `dhms.power`              | `bar-widget`              | `panels/power/Panel.qml`                               |
| Speed test       | `dhms.speedtest`          | `panel`                   | `panels/speedtest/Panel.qml`                           |
| Weather          | `dhms.weather`            | `bar-widget`              | `panels/weather/BarWidget.qml`                         |
| Wi-Fi QR         | `dhms.wifiqr`             | `panel`                   | `panels/wifiqr/Panel.qml`                              |

First-party bar-only widgets also carry manifests next to their QML files,
e.g. `bar/widgets/Workspaces.manifest.json`. Rich popup widgets live in their
own plugin directories, each with its own `manifest.json`.

## Bar

The built-in status bar and default full-bar option. Layout lives in the
top-level `bar:` subtree of `~/.config/shell/shell.json` (with the shell
providing [`config/shell.json`](../config/shell.json) when the user has no
file). See [`bar/README.md`](bar/README.md) for the widget catalogue
and customization schema.

## Image picker

Fullscreen image-grid selector overlay. Used by `dhms-menu-images`
(wallpaper picker) and `dhms-theme-switcher` (theme picker) and any
other caller that wants to present a directory of images with previews.

Two ways to drive it:

- Shell-level summon: `dhms-shell shell summon dhms.image-picker '<jsonPayload>'`.
  The payload can carry `imageDirs`, `imageRows`, `selectedImage`,
  `selectionFile`, `doneFile`, `showLabels`, `filterable`. Best for
  in-shell callers that already speak JSON.
- Direct IPC target: `dhms-shell image-selector open <imageDirs> <imageRowsB64> <selectedImage> <selectionFile> <doneFile> <showLabels> <filterable>`.
  Positional args; `imageRowsB64` is base64-encoded so embedded newlines /
  tabs survive the bash argv handoff. This is what `dhms-menu-images`
  uses. Colors come from the central shell theme singleton; there is no
  per-call override surface.

The selection round-trip remains file-based: callers create a
`selection_file` and `done_file` (both `mktemp`), pass the paths, and
poll `done_file` for existence. The plugin writes the chosen path into
`selection_file` and touches `done_file` when it's done. `cancel` IPC
clears it without writing a selection.

The plugin has `keepLoaded: true` so the layer-shell window survives
between summons within a single shell session.

## Lock screen

Session-lock surface using Quickshell's native `WlSessionLock` and two
separate PAM services: `dhms-lock-password` for password auth and,
only when fingerprints are enrolled, `dhms-lock-fingerprint` for
fingerprint auth. It mirrors the previous lock screen field dimensions,
colors, blurred wallpaper, placeholder, and Hyprland-driven corners.

## Polkit agent

Theme-aware authentication dialog for privileged actions. It uses
Quickshell's native `Quickshell.Services.Polkit.PolkitAgent` backend and
runs inside the long-lived `dhms-shell` process, replacing the old
`polkit-gnome-authentication-agent-1` autostart.

## dhms menu

Quickshell-powered dhms command menu.
The menu UI lives in `menu/Menu.qml` as a first-party `menu` plugin and is
summoned through the shell (`dhms-shell shell summon dhms.menu ...`),
so it shares the long-running `dhms-shell` process instead of starting a
second Quickshell instance.

The menu definition lives in a single in-tree file:

- [`menu.jsonc`](./menu/menu.jsonc), next to `Menu.qml` in the menu plugin

The shell parses that JSONC file at startup (with `watchChanges: true`
so edits take effect without a restart), evaluates `when:` / `checked:`
bash expressions in a single batched subprocess, and executes the
selected `action:` string directly via `Quickshell.execDetached`. The
long-running shell process keeps the parsed menu in memory, so the
keybind → IPC → visible path costs ~30ms cold.
To fork the menu, clone the plugin with `dhms plugin clone dhms.menu`
and edit the copy under `~/.config/dhms/plugins/`.

## Coming soon

- `dhms.theme-switcher` — folds theme switching into the shell.
