import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "bar"
import "bar/modules"
import "launcher"

ShellRoot {
    id: shell

    readonly property string homeDir: Quickshell.env("HOME") || ""
    readonly property string currentDir: homeDir + "/.config/themes/current"
    readonly property string themeNamePath: currentDir + "/theme.name"
    readonly property string themeColorsPath: currentDir + "/theme/colors.toml"

    function shellQuote(s) {
        return "'" + String(s).replace(/'/g, "'\\''") + "'";
    }

    function reloadTheme() {
        themeLoader.stdout.buf = "";
        themeLoader.running = false;
        reloadTimer.restart();
    }

    Timer {
        id: reloadTimer
        interval: 200
        onTriggered: {
            themeLoader.running = true;
        }
    }

    property string bg: "#1e1e2e"
    property string fg: "#cdd6f4"
    property string accent: "#89b4fa"
    property string dim: "#45475a"
    property string highlight: "#cba6f7"
    property string red: "#f38ba8"
    property string green: "#a6e3a1"
    property string muted: "#585b70"
    readonly property var palette: ({
        "bg": shell.bg,
        "fg": shell.fg,
        "accent": shell.accent,
        "dim": shell.dim,
        "muted": shell.muted,
        "highlight": shell.highlight,
        "red": shell.red,
        "green": shell.green
    })

    function parseToml(raw) {
        function get(key) {
            const rx = new RegExp('(?:^|\\n)' + key + '\\s*=\\s*"(#[0-9a-fA-F]{3,8})"');
            const m = raw.match(rx);
            return m ? m[1] : null;
        }

        bg = get("background") || bg;
        fg = get("foreground") || fg;
        accent = get("accent") || accent;
        dim = get("color0") || dim;
        muted = get("color8") || muted;
        highlight = get("color5") || highlight;
        red = get("color1") || red;
        green = get("color2") || green;
    }

    Process {
        id: themeLoader

        command: ["bash", "-lc", "cat " + shell.shellQuote(shell.themeColorsPath) + " 2>/dev/null"]
        running: true
        onExited: {
            const raw = (themeLoader.stdout.buf || "").trim();
            if (raw.length > 0)
                parseToml(raw);
            themeLoader.stdout.buf = "";
        }

        stdout: SplitParser {
            property string buf: ""

            onRead: (data) => {
                return buf += data + "\n";
            }
        }

    }

    Process {
        id: themeWatcher

        command: ["bash", "-lc", "qpath=" + shell.shellQuote(shell.themeNamePath) + "; " + "if command -v inotifywait >/dev/null 2>&1; then " + "  exec inotifywait -m -e close_write \"$qpath\"; " + "else " + "  last=''; " + "  while true; do " + "    cur=$(stat -c %Y \"$qpath\" 2>/dev/null || echo missing); " + "    if [ \"$cur\" != \"$last\" ]; then printf 'changed\\n'; last=\"$cur\"; fi; " + "    sleep 1; " + "  done; " + "fi"]
        running: true

        stdout: SplitParser {
            onRead: (_) => {
                reloadTheme();
            }
        }

    }

    Bar {
        launcher: appLauncher
        notifServer: notifServer
        bg: shell.bg
        fg: shell.fg
        accent: shell.accent
        dim: shell.dim
        highlight: shell.highlight
        red: shell.red
        green: shell.green
        muted: shell.muted
    }

    Launcher {
        id: appLauncher

        theme: shell.palette
    }

    ThemePicker {
        id: themePicker

        theme: shell.palette
    }

    BgPicker {
        id: bgPicker

        theme: shell.palette
    }

    EmojiPicker {
        id: emojiPicker

        theme: shell.palette
    }

    Screenrecord {
        id: screenrecord

        theme: shell.palette
    }

    NotificationPanel {
        id: notifPanel

        theme: shell.palette
        focus: true
    }

    OsdService {
        id: osdService
    }

    Osd {
        service: osdService
        theme: shell.palette
    }

    NotificationServer {
        id: notifServer
    }

    KeybindViewer {
        id: keybindViewer

        theme: shell.palette
    }

    IpcHandler {
        function handle() {
            notifServer.togglePanel();
        }

        target: "openNotificationPanel"
    }

    IpcHandler {
        function handle() {
            notifServer.clearAll();
        }

        target: "clearNotifications"
    }

    // ALL IpcHandler here for keybinds
    IpcHandler {
        function handle() {
            keybindViewer.showing = true;
        }

        target: "openKeybindings"
    }

    IpcHandler {
        function handle() {
            appLauncher.mode = "menu";
            appLauncher.showing = true;
        }

        target: "openMenu"
    }

    IpcHandler {
        function handle() {
            appLauncher.mode = "apps";
            appLauncher.appSearchText = "";
            appLauncher.showing = true;
        }

        target: "openApps"
    }

    IpcHandler {
        function handle() {
            themePicker.showing = true;
        }

        target: "openThemes"
    }

    IpcHandler {
        function handle() {
            bgPicker.showing = true;
        }

        target: "openBackgroundPicker"
    }

    IpcHandler {
        function handle() {
            Quickshell.execDetached(["bash", "-c", "if pgrep -f '^gpu-screen-recorder' > /dev/null 2>&1; then " + "export PATH=\"$HOME/.dhmsDots/bin:$PATH\"; screenrecord --stop-recording; " + "else touch /tmp/sr_show; fi"]);
            srCheckTimer.start();
        }

        target: "openScreenrecord"
    }

    Process {
        id: srChecker

        command: ["bash", "-c", "test -f /tmp/sr_show && rm /tmp/sr_show"]
        running: false
        onExited: (exitCode) => {
            if (exitCode === 0)
                screenrecord.showing = true;
        }
    }

    Timer {
        id: srCheckTimer
        interval: 200
        onTriggered: {
            srCheckTimer.stop();
            srChecker.running = false;
            srChecker.running = true;
        }
    }

    IpcHandler {
        function handle() {
            appLauncher.openSystem();
        }

        target: "openSystem"
    }

    IpcHandler {
        function handle() {
            emojiPicker.showing = true;
        }

        target: "openEmojiPicker"
    }

    IpcHandler {
        function handle() {
            osdService.showVolume();
        }

        target: "osdVolume"
    }

    IpcHandler {
        function handle() {
            osdService.volumeStep(5);
        }

        target: "osdVolumeUp"
    }

    IpcHandler {
        function handle() {
            osdService.volumeStep(-5);
        }

        target: "osdVolumeDown"
    }

    IpcHandler {
        function handle() {
            osdService.toggleMute();
        }

        target: "osdVolumeMute"
    }

    IpcHandler {
        function handle() {
            osdService.showBrightness();
        }

        target: "osdBrightness"
    }

    IpcHandler {
        function handle() {
            osdService.brightnessStep(5);
        }

        target: "osdBrightnessUp"
    }

    IpcHandler {
        function handle() {
            osdService.brightnessStep(-5);
        }

        target: "osdBrightnessDown"
    }

    IpcHandler {
        function handle() {
            osdService.showMic();
        }

        target: "osdMic"
    }

    // Click Catcher Here
    ClickCatcher {
        active: appLauncher.showing || themePicker.showing || bgPicker.showing || notifServer.panelOpen || keybindViewer.showing
        onClicked: {
            appLauncher.showing = false;
            themePicker.showing = false;
            bgPicker.showing = false;
            notifServer.panelOpen = false;
            keybindViewer.showing = false;
        }
    }

}
