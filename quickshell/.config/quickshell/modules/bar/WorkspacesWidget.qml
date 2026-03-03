import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Item {
    id: root

    required property QtObject barTheme
    readonly property var kanji: ["一", "二", "三", "四", "五"]

    implicitWidth: row.implicitWidth + 8
    implicitHeight: barTheme.barHeight

    RowLayout {
        id: row

        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: [1, 2, 3, 4, 5]

            delegate: Item {
                required property int modelData
                property bool active: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData
                property bool occupied: {
                    var ws = Hyprland.workspaces.values;
                    for (var i = 0; i < ws.length; i++) if (ws[i].id === modelData) {
                        return true;
                    }
                    return false;
                }

                implicitWidth: wsLbl.implicitWidth + 14
                implicitHeight: 22
                opacity: (active || occupied) ? 1 : 0.25

                Rectangle {
                    anchors.fill: parent
                    radius: 4
                    color: active ? root.barTheme.accent + "25" : "transparent"
                    border.color: active ? root.barTheme.accent : root.barTheme.foreground + "50"
                    border.width: 1
                }

                Text {
                    id: wsLbl

                    anchors.centerIn: parent
                    text: root.kanji[modelData - 1]
                    color: active ? root.barTheme.accent : root.barTheme.foreground

                    font {
                        family: root.barTheme.fontFamily
                        pixelSize: root.barTheme.fontSize + 2
                        bold: active
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }

                    }

                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch("workspace " + modelData)
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                    }

                }

            }

        }

    }

}
