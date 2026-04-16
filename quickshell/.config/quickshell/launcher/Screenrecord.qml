import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root

    property bool showing: false
    property var theme: ({
    })
    property int selectedIdx: 0
    property var options: [{
        "icon": "",
        "label": "Without audio",
        "cmd": "screenrecord"
    }, {
        "icon": "",
        "label": "With desktop audio",
        "cmd": "screenrecord --with-desktop-audio"
    }, {
        "icon": "",
        "label": "With desktop + microphone audio",
        "cmd": "screenrecord --with-desktop-audio --with-microphone-audio"
    }]

    function runCommand(cmd) {
        Quickshell.execDetached(["bash", "-c", "export PATH=\"$HOME/.dhmsDots/bin:$PATH\"; " + cmd]);
        root.showing = false;
    }

    implicitWidth: 380
    color: "transparent"
    exclusiveZone: 0
    visible: showing
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    onShowingChanged: {
        if (showing) {
            selectedIdx = 0;
            focusTimer.start();
        }
    }

    anchors {
        left: true
        top: true
        bottom: true
    }

    margins {
        left: 5
        top: 5
        bottom: 5
    }

    FocusScope {
        id: focusScope

        anchors.fill: parent
        focus: true
        Keys.onPressed: (e) => {
            if (e.key === Qt.Key_Escape) {
                root.showing = false;
                e.accepted = true;
            } else if (e.key === Qt.Key_Return || e.key === Qt.Key_Enter) {
                const item = root.options[Math.max(0, Math.min(root.selectedIdx, root.options.length - 1))];
                root.runCommand(item.cmd);
                e.accepted = true;
            } else if (e.key === Qt.Key_Down) {
                if (root.selectedIdx < root.options.length - 1)
                    root.selectedIdx++;

                e.accepted = true;
            } else if (e.key === Qt.Key_Up) {
                if (root.selectedIdx > 0)
                    root.selectedIdx--;

                e.accepted = true;
            }
        }

        Rectangle {
            id: card

            anchors.fill: parent
            radius: 12
            color: theme.bg || "#1e1e2e"
            border.color: theme.dim || "#45475a"
            border.width: 1
            clip: true
            opacity: root.showing ? 1 : 0

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 6

                // Header
                Row {
                    Layout.fillWidth: true
                    spacing: 6

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: ""
                        color: theme.accent || "#89b4fa"
                        font.pixelSize: 14
                        font.family: "JetBrainsMono Nerd Font"
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Screen Record"
                        color: theme.fg || "#cdd6f4"
                        font.pixelSize: 13
                        font.family: "JetBrainsMono Nerd Font"
                        font.weight: Font.Medium
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "✕"
                        color: Qt.alpha(theme.muted || "#585b70", 0.5)
                        font.pixelSize: 12

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -6
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.showing = false
                        }

                    }

                }

                // List of options
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: root.options
                    spacing: 4

                    delegate: Rectangle {
                        property bool isSelected: index === root.selectedIdx

                        width: ListView.view.width
                        height: 52
                        radius: 8
                        color: isSelected ? Qt.alpha(theme.accent || "#89b4fa", 0.15) : Qt.alpha(theme.dim || "#45475a", 0.2)
                        border.color: isSelected ? (theme.accent || "#89b4fa") : "transparent"
                        border.width: 2

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 14
                            spacing: 12
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.icon
                                color: isSelected ? (theme.accent || "#89b4fa") : (theme.fg || "#cdd6f4")
                                font.pixelSize: 18
                                font.family: "JetBrainsMono Nerd Font"
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.label
                                color: isSelected ? (theme.accent || "#89b4fa") : (theme.fg || "#cdd6f4")
                                font.pixelSize: 13
                                font.family: "JetBrainsMono Nerd Font"
                                font.weight: isSelected ? Font.Medium : Font.Normal
                            }

                        }

                        MouseArea {
                            anchors.fill: parent
                            z: 1
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: {
                                root.selectedIdx = index;
                            }
                            onClicked: {
                                root.runCommand(modelData.cmd);
                            }
                        }
                    }

                }

                Text {
                    text: "↑↓ nav  ↵ select  esc close"
                    color: Qt.alpha(theme.muted || "#585b70", 0.4)
                    font.pixelSize: 8
                    font.family: "JetBrainsMono Nerd Font"
                    Layout.alignment: Qt.AlignHCenter
                }

            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }

            }

            transform: Translate {
                x: root.showing ? 0 : -20

                Behavior on x {
                    NumberAnimation {
                        duration: 220
                        easing.type: Easing.OutCubic
                    }

                }

            }

        }

    }

    Timer {
        id: focusTimer

        interval: 50
        onTriggered: focusScope.forceActiveFocus()
    }

}
