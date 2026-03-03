import QtQuick
import Quickshell.Io

Item {
    id: root

    required property QtObject barTheme
    property real used: 0
    property real total: 0

    implicitWidth: lbl.implicitWidth
    implicitHeight: barTheme.barHeight

    Process {
        id: proc

        command: ["sh", "-c", "free --bytes | awk 'NR==2{print $3,$2}'"]

        stdout: SplitParser {
            onRead: function(d) {
                var p = d.trim().split(" ");
                if (p.length >= 2) {
                    root.used = Math.round(parseInt(p[0]) / 1.07374e+09 * 10) / 10;
                    root.total = Math.round(parseInt(p[1]) / 1.07374e+09 * 10) / 10;
                }
            }
        }

    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }

    Text {
        id: lbl

        anchors.centerIn: parent
        text: "\uf2db " + root.used + "G/" + root.total + "G"
        color: (root.used / root.total) > 0.9 ? root.barTheme.critical : (root.used / root.total) > 0.7 ? root.barTheme.warning : root.barTheme.foreground

        font {
            family: root.barTheme.fontFamily
            pixelSize: root.barTheme.fontSize
        }

    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: bp.running = true
    }

    Process {
        id: bp

        command: ["floating-terminal", "btop"]
    }

}
