import QtQuick
import Quickshell.Io

Item {
    id: root

    required property QtObject barTheme
    property int usage: 0
    property var _p: null

    implicitWidth: lbl.implicitWidth
    implicitHeight: barTheme.barHeight

    Process {
        id: proc

        command: ["sh", "-c", "head -1 /proc/stat"]

        stdout: SplitParser {
            onRead: function(d) {
                var p = d.trim().split(/\s+/);
                var tot = 0;
                for (var i = 1; i < 8; i++) tot += parseInt(p[i])
                var act = tot - parseInt(p[4]) - parseInt(p[5]);
                if (root._p) {
                    var dt = tot - root._p.tot, da = act - root._p.act;
                    if (dt > 0)
                        root.usage = Math.round(da / dt * 100);

                }
                root._p = {
                    "tot": tot,
                    "act": act
                };
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
        text: "\uf4bc " + root.usage + "%"
        color: root.usage >= 90 ? root.barTheme.critical : root.usage >= 70 ? root.barTheme.warning : root.barTheme.foreground

        font {
            family: root.barTheme.fontFamily
            pixelSize: root.barTheme.fontSize
        }

    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: lp.running = true
    }

    Process {
        id: lp

        command: ["floating-terminal", "s-tui"]
    }

}
