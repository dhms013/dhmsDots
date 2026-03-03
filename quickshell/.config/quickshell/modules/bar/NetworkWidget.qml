import QtQuick
import Quickshell.Io

Item {
    id: root

    required property QtObject barTheme
    property real rx: 0
    property real tx: 0
    property real rxS: 0
    property real txS: 0

    function fmt(b) {
        if (b >= 1.04858e+06)
            return (b / 1.04858e+06).toFixed(1) + "MB/s";

        if (b >= 1024)
            return (b / 1024).toFixed(0) + "KB/s";

        return b.toFixed(0) + "B/s";
    }

    implicitWidth: lbl.implicitWidth
    implicitHeight: barTheme.barHeight

    Process {
        id: proc

        command: ["sh", "-c", "awk 'NR>2&&!/lo:/{gsub(\":\",\" \",$1);r+=$2;t+=$10}END{print r,t}' /proc/net/dev"]

        stdout: SplitParser {
            onRead: function(d) {
                var p = d.trim().split(/\s+/);
                if (p.length < 2)
                    return ;

                var nr = parseInt(p[0]), nt = parseInt(p[1]);
                if (root.rx > 0) {
                    root.rxS = (nr - root.rx) / 2;
                    root.txS = (nt - root.tx) / 2;
                }
                root.rx = nr;
                root.tx = nt;
            }
        }

    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }

    Text {
        id: lbl

        anchors.centerIn: parent
        text: "\uf062" + root.fmt(root.txS) + "  \uf063" + root.fmt(root.rxS)
        color: root.barTheme.foreground

        font {
            family: root.barTheme.fontFamily
            pixelSize: root.barTheme.fontSize
        }

    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: sp.running = true
    }

    Process {
        id: sp

        command: ["floating-terminal", "speedtest-cli"]
    }

}
