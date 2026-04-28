import QtQuick
import Quickshell.Io

Item {
    id: root

    property var theme: ({
    })
    property string netDown: "0K"
    property string netUp: "0K"
    property bool highTraffic: false
    property int lastRx: 0
    property int lastTx: 0

    function _formatNetSpeed(bytes) {
        if (bytes >= 1.04858e+06)
            return (bytes / 1.04858e+06).toFixed(1) + "M";

        if (bytes >= 1024)
            return (bytes / 1024).toFixed(0) + "K";

        return "0K";
    }

    function _calcSpeed(newRx, newTx) {
        const down = newRx - lastRx;
        const up = newTx - lastTx;
        lastRx = newRx;
        lastTx = newTx;
        netDown = _formatNetSpeed(down);
        netUp = _formatNetSpeed(up);
        highTraffic = down > 1.04858e+06 || up > 1.04858e+06;
    }

    implicitWidth: 60
    implicitHeight: 20

    Timer {
        interval: 500
        repeat: true
        running: true
        onTriggered: {
            netSpeedProc.running = false;
            netSpeedProc.running = true;
        }
    }

    Process {
        id: netSpeedProc

        command: ["bash", "-lc", "iface=$(ip -o route get 8.8.8.8 | grep -oP 'dev \\K\\w+'); [ -z \"$iface\" ] && echo \"0:0\" || echo \"$(cat /sys/class/net/$iface/statistics/rx_bytes):$(cat /sys/class/net/$iface/statistics/tx_bytes)\""]
        running: true

        stdout: SplitParser {
            onRead: (data) => {
                const parts = (data.trim() || "0:0").split(":");
                const newRx = parseInt(parts[0]) || 0;
                const newTx = parseInt(parts[1]) || 0;
                if (root.lastRx > 0) {
                    root._calcSpeed(newRx, newTx);
                } else {
                    root.lastRx = newRx;
                    root.lastTx = newTx;
                }
            }
        }

    }

    Text {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: "⇣ " + root.netDown + " ⇡ " + root.netUp
        color: theme.fg
        font.pixelSize: 11
        font.family: "JetBrainsMono Nerd Font"
        opacity: 1
    }

}
