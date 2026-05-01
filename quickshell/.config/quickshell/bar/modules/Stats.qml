import QtQuick
import Quickshell.Io

Row {
    property var theme: ({
    })
    property real cpuVal: 0
    property real cpuSmooth: 0
    property real numCores: 12
    property real ramVal: 0
    property real ramSwap: 0
    property real ramTotal: 0

    spacing: 10
    anchors.verticalCenter: parent ? parent.verticalCenter : undefined

    StatPill {
        label: "CPU"
        value: cpuVal
        suffix: "%"
        accent: cpuVal > 85 ? (theme.red || "#f38ba8") : (theme.accent || "#89b4fa")
        trackColor: theme.dim || "#45475a"
        textColor: theme.fg || "#cdd6f4"
    }

    StatPill {
        label: "RAM"
        value: ramVal
        suffix: "G"
        extraText: "/" + (ramTotal + ramSwap) + "G"
        accent: ramVal > (ramTotal * 0.85) ? (theme.red || "#f38ba8") : (theme.accent || "#cba6f7")
        trackColor: theme.dim || "#45475a"
        textColor: theme.fg || "#cdd6f4"
    }

    Process {
        id: cpuProc

        command: ["bash", "-c", "ps -eo pcpu --no-headers | awk '{sum+=$1} END {print sum}'"]
        running: true

        stdout: SplitParser {
            onRead: (data) => {
                const text = data.trim();
                const raw = parseFloat(text);
                if (!isNaN(raw) && raw >= 0) {
                    const val = Math.min(100, Math.round(raw / numCores));
                    cpuSmooth = cpuSmooth * 0.7 + val * 0.3;
                    cpuVal = Math.round(cpuSmooth);
                }
            }
        }

    }

    Process {
        id: ramProc

        command: ["bash", "-c", "awk '/MemTotal:/ {mt=$2} /MemAvailable:/ {ma=$2} /SwapTotal:/ {st=$2} /SwapFree:/ {sf=$2} END {printf \"%.1fG/%.1fG\\n\", (mt-ma+st-sf)/1048576, (mt+st)/1048576}' /proc/meminfo"]
        running: true

        stdout: SplitParser {
            onRead: (data) => {
                const text = data.trim();
                const match = text.match(/^([\d.]+)G\/([\d.]+)G$/);
                if (match) {
                    ramVal = parseFloat(match[1]);
                    ramTotal = parseFloat(match[2]);
                }
            }
        }

    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = false;
            cpuProc.running = true;
            ramProc.running = false;
            ramProc.running = true;
        }
    }

}
