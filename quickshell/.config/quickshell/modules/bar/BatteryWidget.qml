import QtQuick
import Quickshell.Io

Item {
    id: root

    required property QtObject barTheme
    property bool hasBat: false
    property int cap: 0
    property string stat: "Discharging"
    readonly property var chg: ["\uf71c", "\uf086", "\uf087", "\uf088", "\uf71d", "\uf089", "\uf71e", "\uf08a", "\uf08b", "\uf085"]
    readonly property var dis: ["\uf07a", "\uf07b", "\uf07c", "\uf07d", "\uf07e", "\uf07f", "\uf080", "\uf081", "\uf082", "\uf079"]

    function icon() {
        if (stat === "Full")
            return "\uf085";

        if (stat === "Not charging" || (stat === "Charging" && cap >= 100))
            return "\uf1e6";

        var i = Math.min(Math.floor(cap / 10), 9);
        return stat === "Charging" ? chg[i] : dis[i];
    }

    implicitWidth: hasBat ? lbl.implicitWidth : 0
    implicitHeight: barTheme.barHeight
    visible: hasBat

    Process {
        id: proc

        command: ["sh", "-c", "cap=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null|head -1);stat=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null|head -1);[ -z \"$cap\" ]&&echo NOBAT||echo \"$cap $stat\""]

        stdout: SplitParser {
            onRead: function(d) {
                var s = d.trim();
                if (s === "NOBAT") {
                    root.hasBat = false;
                    return ;
                }
                root.hasBat = true;
                var p = s.split(" ");
                if (p[0])
                    root.cap = parseInt(p[0]);

                if (p.length >= 2)
                    root.stat = p.slice(1).join(" ");

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
        text: root.cap + "%" + root.icon()
        color: root.cap <= 10 ? root.barTheme.critical : root.cap <= 20 ? root.barTheme.warning : root.stat === "Charging" ? root.barTheme.accent : root.barTheme.foreground

        font {
            family: root.barTheme.fontFamily
            pixelSize: root.barTheme.fontSize
        }

    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: mp.running = true
    }

    Process {
        id: mp

        command: ["custom-menu", "power"]
    }

}
