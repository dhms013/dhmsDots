import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: barWindow

    // ── Load waybar CSS (theme file + style.css) ──────────────────────
    property string cssAccum: ""

    function applyTheme(css) {
        function get(key) {
            var m = new RegExp("@define-color\\s+" + key + "\\s+(#[0-9a-fA-F]{3,8})\\s*;").exec(css);
            return m ? m[1] : null;
        }

        var v;
        v = get("background");
        if (v)
            theme.background = v;

        v = get("foreground");
        if (v)
            theme.foreground = v;

        v = get("accent");
        if (v)
            theme.accent = v;

        v = get("warning");
        if (v)
            theme.warning = v;

        v = get("critical");
        if (v)
            theme.critical = v;

        v = get("base-bg");
        if (v)
            theme.background = v;

    }

    WlrLayershell.namespace: "quickshell:bar"
    color: "transparent"
    height: theme.barHeight
    Component.onCompleted: cssReader.running = true

    anchors {
        top: true
        left: true
        right: true
    }

    // ── SINGLE SOURCE OF TRUTH for all bar styling ─────────────────────
    // Change height, font, colors HERE only. All widgets read from this.
    QtObject {
        id: theme

        // Layout
        property int barHeight: 28
        property int fontSize: 10
        property string fontFamily: "JetBrainsMono Nerd Font"
        property int sectionRadius: 13
        // Colors — replaced at runtime from waybar CSS
        property color background: "#1e2a24"
        property color foreground: "#c9d1d9"
        property color accent: "#6bbf7a"
        property color warning: "#e5c07b"
        property color critical: "#e06c75"
    }

    Process {
        id: cssReader

        command: ["sh", "-c", "cat $HOME/.config/themes/current/theme/waybar.css" + "    $HOME/.config/waybar/style.css 2>/dev/null || true"]
        onRunningChanged: {
            if (!running) {
                barWindow.applyTheme(barWindow.cssAccum);
                barWindow.cssAccum = "";
            }
        }

        stdout: SplitParser {
            onRead: function(line) {
                barWindow.cssAccum += line + "\n";
            }
        }

    }

    // ── Bar layout — mirrors waybar config.jsonc sections ────────────
    Item {
        anchors.fill: parent

        RowLayout {
            anchors.fill: parent
            spacing: 0

            // LEFT  — border-radius: 0 0 13px 0
            BarSection {
                Layout.fillWidth: false
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                bottomRightRadius: theme.sectionRadius
                barTheme: theme

                contentItem: BarLeft {
                    barTheme: theme
                }

            }

            Item {
                Layout.fillWidth: true
            }

            // CENTER — border-radius: 0 0 13px 13px
            BarSection {
                Layout.fillWidth: false
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                bottomLeftRadius: theme.sectionRadius
                bottomRightRadius: theme.sectionRadius
                barTheme: theme

                contentItem: BarCenter {
                    barTheme: theme
                }

            }

            Item {
                Layout.fillWidth: true
            }

            // RIGHT — border-radius: 0 0 0 13px
            BarSection {
                Layout.fillWidth: false
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                bottomLeftRadius: theme.sectionRadius
                barTheme: theme

                contentItem: BarRight {
                    barTheme: theme
                }

            }

        }

    }

}
