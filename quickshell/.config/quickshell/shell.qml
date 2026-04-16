// import "settings"

import QtQuick
import QtQuick.Layouts
//@ pragma UseQApplication
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "bar"
import "bar/modules"
import "dock"
import "launcher"

ShellRoot {
    id: shell

    readonly property string homeDir: Quickshell.env("HOME") || ""
    readonly property string currentDir: homeDir + "/.config/themes/current"
    readonly property string themeNamePath: currentDir + "/theme.name"
    readonly property string themeColorsPath: currentDir + "/theme/colors.toml"
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

    QtObject {
        id: powerActions

        property bool open: false
        property string title: ""
        property string message: ""
        property var command: null
        property int selectedIndex: 0

        function requestAction(titleText, messageText, cmd) {
            title = titleText;
            message = messageText;
            command = cmd;
            selectedIndex = 0;
            open = true;
        }

        function close() {
            open = false;
            command = null;
            selectedIndex = 0;
        }

        function moveSelection(delta) {
            selectedIndex = (selectedIndex + delta + 2) % 2;
        }

        function activateSelected() {
            if (selectedIndex === 0)
                close();
            else
                confirm();
        }

        function confirm() {
            if (!command) {
                close();
                return ;
            }
            if (Array.isArray(command))
                Quickshell.execDetached(command);
            else
                Quickshell.execDetached(["bash", "-lc", command]);
            close();
        }

    }

    Process {
        id: themeLoader

        command: ["bash", "-lc", "cat " + shell.themeColorsPath + " 2>/dev/null"]
        running: true
        onExited: {
            if (themeLoader.stdout.buf.length > 10)
                parseToml(themeLoader.stdout.buf);

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

        command: ["bash", "-lc", "if command -v inotifywait >/dev/null 2>&1; then " + "  exec inotifywait -m -e close_write " + shell.themeNamePath + "; " + "else " + "  last=''; " + "  while true; do " + "    cur=$(stat -c %Y " + shell.themeNamePath + " 2>/dev/null || echo missing); " + "    if [ \"$cur\" != \"$last\" ]; then printf 'changed\\n'; last=\"$cur\"; fi; " + "    sleep 3; " + "  done; " + "fi"]
        running: true

        stdout: SplitParser {
            onRead: (_) => {
                themeLoader.stdout.buf = "";
                themeLoader.running = false;
                themeLoader.running = true;
            }
        }

    }

    Bar {
        launcher: appLauncher
        notifServer: notifServer
        powerActions: powerActions
        settings: settingsState
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
        powerActions: powerActions
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

    NotificationPanel {
        id: notifPanel
        theme: shell.palette
        settings: settingsState
        focus: true
    }

    OsdService {
        id: osdService
    }

    Osd {
        service: osdService
        settings: settingsState
        theme: shell.palette
    }

    NotificationServer {
        id: notifServer
    }

IpcHandler {
        function handle() {
            settingsWindow.showing = true;
        }

        target: "openSettings"
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

    PanelWindow {
        id: powerConfirm

        visible: powerActions.open
        color: "transparent"
        exclusiveZone: 0
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
        onVisibleChanged: {
            if (visible)
                powerConfirm.forceActiveFocus();

        }
        Keys.onPressed: (event) => {
            if (!powerActions.open)
                return ;

            if (event.key === Qt.Key_Left || event.key === Qt.Key_Up) {
                powerActions.moveSelection(-1);
                event.accepted = true;
            } else if (event.key === Qt.Key_Right || event.key === Qt.Key_Down || event.key === Qt.Key_Tab) {
                powerActions.moveSelection(1);
                event.accepted = true;
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                powerActions.activateSelected();
                event.accepted = true;
            } else if (event.key === Qt.Key_Escape) {
                powerActions.close();
                event.accepted = true;
            }
        }

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: powerActions.close()

            Rectangle {
                id: powerConfirmCard

                width: 320
                implicitHeight: contentColumn.implicitHeight + 32
                radius: 14
                color: shell.bg
                border.color: shell.dim
                border.width: 1
                anchors.centerIn: parent
                opacity: powerActions.open ? 1 : 0
                scale: powerActions.open ? 1 : 0.96

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                    }
                }

                ColumnLayout {
                    id: contentColumn

                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    Text {
                        text: powerActions.title
                        color: shell.fg
                        font.pixelSize: 14
                        font.family: "JetBrainsMono Nerd Font Propo"
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: powerActions.message
                        color: shell.muted
                        font.pixelSize: 10
                        font.family: "JetBrainsMono Nerd Font Propo"
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Rectangle {
                            id: cancelButton

                            Layout.fillWidth: true
                            height: 32
                            radius: 9
                            color: powerActions.selectedIndex === 0 ? Qt.alpha(shell.accent, 0.16) : Qt.alpha(shell.dim, 0.45)
                            border.color: powerActions.selectedIndex === 0 ? Qt.alpha(shell.accent, 0.5) : Qt.alpha(shell.dim, 0.7)
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "Cancel"
                                color: powerActions.selectedIndex === 0 ? shell.accent : shell.fg
                                font.pixelSize: 10
                                font.family: "JetBrainsMono Nerd Font Propo"
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onEntered: powerActions.selectedIndex = 0
                                onClicked: powerActions.close()
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: 120
                                }

                            }

                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 120
                                }

                            }

                        }

                        Rectangle {
                            id: confirmButton

                            Layout.fillWidth: true
                            height: 32
                            radius: 9
                            color: powerActions.selectedIndex === 1 ? Qt.alpha(shell.red, 0.28) : Qt.alpha(shell.red, 0.2)
                            border.color: powerActions.selectedIndex === 1 ? Qt.alpha(shell.red, 0.72) : Qt.alpha(shell.red, 0.45)
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "Confirm"
                                color: powerActions.selectedIndex === 1 ? shell.fg : shell.red
                                font.pixelSize: 10
                                font.family: "JetBrainsMono Nerd Font Propo"
                                font.weight: Font.DemiBold
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onEntered: powerActions.selectedIndex = 1
                                onClicked: powerActions.confirm()
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: 120
                                }

                            }

                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 120
                                }

                            }

                        }

                    }

                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 140
                        easing.type: Easing.OutCubic
                    }

                }

                Behavior on scale {
                    NumberAnimation {
                        duration: 170
                        easing.type: Easing.OutCubic
                    }

                }

            }

        }

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
            themePicker.showing = true;
        }

        target: "openThemePicker"
    }

    IpcHandler {
        function handle() {
            bgPicker.showing = true;
        }

        target: "openBackgroundPicker"
    }

    IpcHandler {
        function handle() {
            appLauncher.openScreenrecord();
        }

        target: "openScreenrecord"
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

    IpcHandler {
        function handle() {
            osdService.showMediaStatus();
        }

        target: "osdMedia"
    }

    IpcHandler {
        function handle() {
            osdService.mediaPlayPause();
        }

        target: "osdMediaPlayPause"
    }

    IpcHandler {
        function handle() {
            osdService.mediaNext();
        }

        target: "osdMediaNext"
    }

    IpcHandler {
        function handle() {
            osdService.mediaPrev();
        }

        target: "osdMediaPrev"
    }

    // Click Catcher Here
    ClickCatcher {
        active: appLauncher.showing || themePicker.showing || bgPicker.showing || notifServer.panelOpen
        onClicked: {
            appLauncher.showing = false;
            themePicker.showing = false;
            bgPicker.showing = false;
            notifServer.panelOpen = false;
        }
    }

}
