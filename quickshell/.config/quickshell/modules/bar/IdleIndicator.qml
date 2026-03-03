import QtQuick
import Quickshell.Io

Item {
    id: root

    required property QtObject barTheme
    property bool off: false

    implicitWidth: visible ? lbl.implicitWidth : 0
    implicitHeight: barTheme.barHeight
    visible: off

    Process {
        id: proc

        command: ["sh", "-c", "pgrep -x hypridle>/dev/null&&echo running||echo stopped"]

        stdout: SplitParser {
            onRead: function(d) {
                root.off = d.trim() === "stopped";
            }
        }

    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }

    Text {
        id: lbl

        anchors.centerIn: parent
        text: "\uf2dc"
        color: root.barTheme.warning

        font {
            family: root.barTheme.fontFamily
            pixelSize: root.barTheme.fontSize
        }

    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: tp.running = true
    }

    Process {
        id: tp

        command: ["sh", "-c", "hypridle &"]
    }

}
