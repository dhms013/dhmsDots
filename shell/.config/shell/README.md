# dhms shell

`dhms-shell` is a single long-running [Quickshell](https://quickshell.org/)
instance that hosts the dhms desktop. Hyprland autostart launches one shell
per graphical session; everything else — the bar, background switcher, panels,
and overlays — runs **inside** the shell as a plugin.

Hosting everything inside one shell means:

- shared services and singletons live once, not once per process
- summoning a panel is an IPC call into a process that is already running,
  not a fresh `quickshell -p ...` cold start
- third-party plugins can be loaded from disk without changing any source
  code in dhms itself

The runtime layout:

```
shell/
  shell.qml              entry point (ShellRoot)
  services/
    PluginRegistry.qml   discovers, validates plugins, looks up enabled state in shell.json
    BarWidgetRegistry.qml unified registry for bar widgets (1p + 3p)
  plugins/
    background/          wallpaper service
    bar/                 first-party plugins (see plugins/README.md)
    clipboard/
    dev-gallery/
    emojis/
    image-picker/
    lock/
    menu/
    notifications/
    osd/
    panels/
      audio/
      bluetooth/
      clock/
      disk-speedtest/
      monitor/
      network/
      power/
      speedtest/
      weather/
      wifiqr/
    polkit/
    services/
      battery/
      media/
```

The plugin discovery path is documented in [plugins/README.md](plugins/README.md).

## Plugin manifest

Every plugin ships a `manifest.json` describing what it is and how the
shell should load it. Minimal example:

```json
{
  "schemaVersion": 1,
  "id": "my.org.cool-clock",
  "name": "Cool clock",
  "version": "1.0.0",
  "author": "You",
  "description": "A clock that does cool things",
  "kinds": ["bar-widget"],
  "entryPoints": { "barWidget": "Widget.qml" },
  "barWidget": {
    "displayName": "Cool clock",
    "category": "Time",
    "allowMultiple": false,
    "defaultSection": "left",
    "defaults": { "format": "HH:mm" },
    "schema": [
      { "key": "format", "type": "string", "label": "Format" }
    ]
  }
}
```

Supported `kinds`:

| Kind         | What it is                                                   |
|--------------|--------------------------------------------------------------|
| `bar-widget` | A component that the active bar can drop into a section      |
| `panel`      | A persistent or summoned floating window (e.g. OSD)          |
| `overlay`    | A fullscreen overlay (e.g. background switcher)              |
| `menu`       | A summoned menu surface                                      |
| `service`    | A headless singleton, no UI                                  |
| `bar`        | A full bar option that can replace the built-in `dhms.bar` |

Only one `bar` plugin is active at a time. Missing or invalid selections fall
back to the built-in `dhms.bar`, so users always have a safe path home.
Panels, overlays, and menus are loaded when summoned. Plugins that need
to outlive a single summon can set `keepLoaded: true` (e.g. the image
picker keeps its overlay window mounted between summons). First-party
services are loaded at startup.

The full schema lives in `services/PluginRegistry.qml`.

## Installing a third-party plugin

A plugin is a **git repo** with a `manifest.json` at its root. Adding one
clones it straight into `~/.config/dhms/plugins/<id>/` (named by the
manifest id); updating is a fast-forward pull of that checkout.

```bash
dhms plugin add https://github.com/acme/dhms-weather.git
dhms plugin update acme.weather       # fetches, shows a diff, fast-forwards
dhms plugin update                    # updates every git-managed plugin
dhms plugin remove acme.weather
```

> ⚠️ **Plugins run as unsandboxed code inside `dhms-shell`.** Adding warns
> you before cloning, plugins land disabled so you can review the code before
> enabling, and updates show a diff of the changes before touching anything.
> Only add repos whose code you are willing to run.

Each command is **interactive** when run bare in a terminal (gum pickers,
confirmation, a diff to review) and fully **non-interactive** when given
arguments. Pass `--yes` to skip every prompt — this is the path for scripts and
AI agents:

```bash
dhms plugin add https://github.com/acme/dhms-weather.git --enable --yes
dhms plugin update --yes
```

The installer never runs plugin code, install hooks, or sudo — it only clones
files, validates the manifest, and toggles enabled state over shell IPC. Since
an installed plugin is a plain git checkout, anything beyond add/update
(pinning a ref, switching branches) is ordinary git in the plugin directory.

### Installing by hand

You can still drop a plugin in without git:

1. Put it in `~/.config/dhms/plugins/<plugin-id>/` with a `manifest.json`
   plus the QML referenced from its `entryPoints`.
2. `dhms-shell shell rescanPlugins`.
3. `dhms plugin enable <id>`. Bar widgets start in
   `barWidget.defaultSection`, or in the center when it is omitted, and can be
   moved with `dhms-shell shell moveBarWidget <id> '<placement>'`; a full bar
   replaces the one in use.

The lower-level IPC equivalents remain available via `dhms-shell shell rescanPlugins`,
`dhms-shell shell enablePlugin <id> '{}'`, and `dhms-shell shell listPlugins`.
The `dhms plugin` commands wrap those calls. `dhms-shell shell moveBarWidget`
and `dhms-shell shell setBarWidget` edit the persisted widget layout in
`shell.json`.

To hack on a built-in plugin safely, clone it into user config instead of
editing the built-in source. The complete plugin directory is copied, including
every declared kind and local dependency. A built-in id such as
`dhms.clock` becomes `<username>.clock` (e.g. `alice.clock`), with `My Clock`
as its display name. The username prefix keeps shared clones from colliding
with each other or with other plugin authors. The `dhms.*` namespace is
reserved for built-ins, so cloning is refused when the username would produce
a reserved id (a `dhms` username included) — set `DHMS_CLONE_PREFIX` to pick a
different prefix.

```bash
dhms plugin clone dhms.clock
```

Cloning switches from the built-in to the new personal plugin, preserving an
existing bar widget's position and settings. Setup > Plugins > Clone provides
the interactive picker, then opens the new `<username>.*` directory in `$EDITOR`.
Existing shortcuts and shell IPC calls made to the built-in id are routed to
the enabled clone, so cloning does not require changing its callers. Removing
an active clone switches back to its built-in source.
Saving a file anywhere under `~/.config/dhms/plugins/` reloads plugin code
automatically; `dhms-shell shell rescanPlugins` remains available to force a reload.

First-party plugins under `$DHMSDOTS_PATH/shell/.config/shell/plugins/`
are discovered the same way and load
by default. Disabling a non-widget records it in `disabledPlugins[]`; disabling
a widget removes it from the bar layout while leaving its component available
to add again. A full bar has no off state and is replaced by enabling another.

## IPC contract

The shell exposes a single `shell` IPC target plus whatever extra targets
individual plugins register (e.g. the image picker's `image-selector`
target, plus `media`, `notifications`, and `background`). The menu
keybind uses the shell target to summon the first-party `dhms.menu`
plugin instead of running a separate Quickshell instance.

| Method                                   | Returns | Effect                                                |
|------------------------------------------|---------|-------------------------------------------------------|
| `ping`                                   | `ok`    | health check                                          |
| `summon <id> <payloadJson>`              | `ok` / `unknown` | load + open a panel/overlay plugin           |
| `hide <id>`                              | —       | close a previously-summoned plugin                    |
| `toggle <id> <payloadJson>`              | —       | summon if closed, hide if open                        |
| `call <id> <method> <arg>`               | string  | call a method on an already-loaded plugin             |
| `rescanPlugins`                          | —       | re-walk plugin dirs and hot-reload plugin code        |
| `reloadConfig`                           | `ok`    | reload `~/.config/shell/shell.json`                      |
| `setPluginEnabled <id> <enabled>`        | `ok` / `unknown` | flip the persisted enabled bit (see note)    |
| `listPlugins`                            | JSON    | every discovered plugin, sorted by name               |
| `enablePlugin <id> <placementJson>`      | `ok` / error | enable a plugin, placing a widget in the bar    |
| `putBarWidget <id> <placementJson>`      | `ok` / error | place a bar widget without duplicating an entry  |
| `moveBarWidget <id> <placementJson>`     | `ok` / error | move a bar widget to another bar section         |
| `setBarWidget <id> <key> <valueJson> <selectorJson>` | `ok` / error | change an inline widget setting      |
| `toggleBarTransparency`                  | `ok` / `no-bar` | flip the bar's transparent look              |
| `applyTheme <colorsB64> <shellB64>`      | `ok`    | swap theme colors and shell variables live             |

Direct invocation:

```
qs ipc -n -p $DHMSDOTS_PATH/shell/.config/shell call -- shell ping
```

Hyprland autostart launches the shell directly with `qs -p
$DHMSDOTS_PATH/shell/.config/shell` (or the stowed `~/.config/shell`).
Use `restart-quickshell` to stop every running instance of that config
and launch one fresh shell process.

A convenience wrapper, [`dhms-shell`](../../../bin/dhms-shell), forwards IPC
calls to the running shell. It does not start the shell.

```
dhms-shell shell ping
dhms-shell shell toggle dhms.menu '{"menu":"root"}'
dhms-shell shell listPlugins
dhms-shell shell rescanPlugins
```

**Note on `setPluginEnabled`:** the `enabled` argument is a string. Only the
literal `"true"` enables the plugin; every other value (including `"True"`,
`"1"`, `"yes"`, or omitted) disables it. This keeps the IPC surface
type-stable across QML's `string`-only IPC arguments.

## Persisted state

There is one user config file. Everything that distinguishes your
customization from the shipped defaults lives in it.

| Path                              | Owner          | Purpose                                                |
|-----------------------------------|----------------|--------------------------------------------------------|
| `~/.config/shell/shell.json`    | the shell      | full layout + per-entry settings + enabled plugin list |
| `~/.config/dhms/plugins/<id>/`  | user           | drop-in third-party plugin source files                |

The `$DHMSDOTS_PATH/shell/.config/shell/config/shell.json` default config
describes the fresh-install state. When the user has no `shell.json`, the
shell uses the defaults verbatim. Once the user customizes anything,
`shell.json` becomes the authoritative file — we do **not** deep-merge
defaults back in.

### shell.json shape

```json
{
  "version": 1,
  "bar": {
    "id": "dhms.bar",
    "position": "top",
    "transparent": false,
    "centerAnchor": "dhms.clock",
    "layout": {
      "left": [
        { "id": "dhms.menu" },
        { "id": "dhms.system-monitor" },
        { "id": "dhms.indicators" },
        { "id": "dhms.weather" }
      ],
      "center": [
        { "id": "dhms.workspaces" },
        { "id": "dhms.keyboard-layout" }
      ],
      "right": [
        { "id": "dhms.tray" },
        { "id": "dhms.clock", "format": "ddd d MMM HH:mm" },
        { "id": "dhms.monitor" },
        { "id": "dhms.network" },
        { "id": "dhms.bluetooth" },
        { "id": "dhms.audio" },
        { "id": "dhms.power" }
      ]
    }
  },
  "plugins": []
}
```

### Storage rules

1. **The active bar option is `bar.id`.** Omit it or set it to `dhms.bar`
   to use the built-in bar. Set it to another plugin id whose manifest declares
   `kind: "bar"` to replace the full bar.
2. **Every plugin instance is one entry.** Either in `bar.layout.<section>`
   for bar widgets, or in `plugins[]` for panels, overlays, services,
   menus, and anything else non-bar.
3. **Settings are inline on the entry.** No `config:` sub-object, no
   separate per-plugin settings file, no merge layers. The fields on each
   entry are the values the plugin sees.
4. **Built-in widget ids are namespaced.** Use ids such as `dhms.clock`,
   `dhms.audio`, and `dhms.network`. The migration rewrites older ids
   like `Clock` and `AudioPanel` forward.
5. **Third-party enabled ⇔ present.** A third-party plugin is enabled iff
   its id appears somewhere in shell.json. For full bar options, that means
   `bar.id`; for bar widgets, plugin enable/disable adds/removes layout entries;
   other plugin kinds are enabled the same way. First-party non-bar plugins
   are enabled unless listed in `disabledPlugins[]`.
6. **Multiple instances** are allowed when a manifest sets
   `allowMultiple: true`. Each instance is independent — e.g. two clock
   widgets in different timezones are just two `{"id":"dhms.clock", "timezone": ...}`
   entries with their own values.
7. **`version: 1` is required** at the top level. The shell will fall back
   to defaults rather than load an unknown version.

Shared services and Pipewire/UPower/Hyprland consolidation are explicitly
out of scope here and deferred to a follow-up after a review pass.
