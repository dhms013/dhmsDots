import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "modules"

PanelWindow {
    id: root

    property var launcher:      null
    property var calendarPopup: null
    property var notifServer: null

    property string bg:        "#1e1e2e"
    property string fg:        "#cdd6f4"
    property string accent:    "#89b4fa"
    property string dim:       "#45475a"
    property string highlight: "#cba6f7"
    property string red:       "#f38ba8"
    property string green:     "#a6e3a1"
    property string muted:     "#585b70"

    readonly property bool barOnBottom: (settings?.barPosition || "top") === "bottom"
    readonly property string barStyle: settings?.barStyle || "flat"
    readonly property bool styleFlat: barStyle === "flat"
    readonly property int barHeight: styleFlat ? 30 : 28
    readonly property int edgeMargin: styleFlat ? 0 : 5
    readonly property int sideMargin: styleFlat ? 0 : 6
    readonly property int reservedSpace: styleFlat ? 30 : 33
    readonly property int barRadius: styleFlat ? 0 : 10

    anchors {
        top: !barOnBottom
        bottom: barOnBottom
        left: true
        right: true
    }
    margins {
        top: barOnBottom ? 0 : root.edgeMargin
        bottom: barOnBottom ? root.edgeMargin : 0
        left: root.sideMargin
        right: root.sideMargin
    }
    implicitHeight: root.barHeight
    color: "transparent"
    exclusiveZone: root.reservedSpace

Item {
        anchors.fill: parent

        Rectangle {
            id: leftBg
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: leftSection.width + 24
            color: root.bg
            topLeftRadius: 0
            topRightRadius: 0
            bottomLeftRadius: 0
            bottomRightRadius: 20
            border.width: 1
            border.color: root.fg
        }

        Item {
            id: leftSection
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            height: root.barHeight
            width: leftRow.implicitWidth

            Row {
                id: leftRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Stats {
                    anchors.verticalCenter: parent.verticalCenter
                    theme: ({
                        fg: root.fg,
                        accent: root.accent,
                        highlight: root.highlight,
                        dim: root.dim,
                        red: root.red,
                        green: root.green,
                        muted: root.muted,
                        bg: root.bg
                    })
                }

                Indicators {
                    anchors.verticalCenter: parent.verticalCenter
                    notifServer: root.notifServer
                    accent: root.accent
                    muted: root.muted
                    red: root.red
                    green: root.green
                    fg: root.fg
                }
            }
        }

        

        Item {
            id: centerSection
            anchors.centerIn: parent
            anchors.verticalCenter: parent.verticalCenter
            height: root.barHeight

            Binding on width {
                value: Math.max(workspaceItem.implicitWidth + 20, 80)
                when: workspaceItem.width > 0
            }

            Rectangle {
                anchors.fill: parent
                color: root.bg
                topLeftRadius: 0
                topRightRadius: 0
                bottomLeftRadius: 20
                bottomRightRadius: 20
                border.color: root.fg
            }

            Workspaces {
                id: workspaceItem
                anchors.centerIn: parent
                theme: ({
                    fg: root.fg,
                    muted: root.muted,
                    accent: root.accent,
                    dim: root.dim,
                    bg: root.bg
                })
            }
        }

        Rectangle {
            id: rightBg
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: rightSection.width + 24
            color: root.bg
            topLeftRadius: 0
            topRightRadius: 0
            bottomLeftRadius: 20
            bottomRightRadius: 0
            border.width: 1
            border.color: root.fg
        }

        Item {
            id: rightSection
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            height: root.barHeight
            width: rightRow.implicitWidth

            Row {
                id: rightRow
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12
                layoutDirection: Qt.RightToLeft

                // Text {
                //     anchors.verticalCenter: parent.verticalCenter
                //     text: root.notifServer && root.notifServer.dndEnabled
                //         ? "󰂛"
                //         : root.notifServer && root.notifServer.notifications.length > 0
                //             ? "󱅫"
                //             : "󰂚"
                //     font.pixelSize: 14
                //     font.family: "JetBrainsMono Nerd Font"
                //     color: root.notifServer && root.notifServer.dndEnabled
                //         ? root.red
                //         : root.notifServer && root.notifServer.panelOpen
                //             ? root.accent
                //             : root.fg
                //
                //     Behavior on color { ColorAnimation { duration: 150 } }
                //
                //     MouseArea {
                //         anchors.fill: parent
                //         cursorShape: Qt.PointingHandCursor
                //         acceptedButtons: Qt.LeftButton | Qt.RightButton
                //         onClicked: mouse => {
                //             if (!root.notifServer) return
                //             if (mouse.button === Qt.RightButton) root.notifServer.toggleDnd()
                //             else root.notifServer.togglePanel()
                //         }
                //     }
                // }
                //
                Battery {
                    anchors.verticalCenter: parent.verticalCenter
                    theme: ({
                        fg: root.fg,
                        accent: root.accent,
                        dim: root.dim,
                        muted: root.muted,
                        bg: root.bg
                    })
                }

                Clock {
                    anchors.verticalCenter: parent.verticalCenter
                    theme: ({
                        fg: root.fg,
                        accent: root.accent,
                        dim: root.dim,
                        muted: root.muted,
                        bg: root.bg
                    })
                }

                Tray {
                    anchors.verticalCenter: parent.verticalCenter
                    trayWindow: root
                    theme: ({
                        fg: root.fg,
                        accent: root.accent,
                        dim: root.dim,
                        muted: root.muted,
                        bg: root.bg
                    })
                }
            }
        }
    }
}
