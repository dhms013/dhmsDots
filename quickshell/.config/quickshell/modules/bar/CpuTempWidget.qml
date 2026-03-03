import QtQuick
import Quickshell.Io

Item {
    id: root

    required property QtObject barTheme
    property real temp: 0

    implicitWidth: lbl.implicitWidth
    implicitHeight: barTheme.barHeight

    Process {
        id: proc

        command: ["sh", "-c", "sensors -j 2>/dev/null | python3 -c \"\nimport sys,json\nd=json.load(sys.stdin)\nt=[v2['temp1_input'] for v in d.values() for k2,v2 in v.items() if isinstance(v2,dict) and 'temp1_input' in v2]\nprint(round(max(t))) if t else print(0)\n\" 2>/dev/null || awk '{printf \"%.0f\\n\",$1/1000}' /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo 0"]

        stdout: SplitParser {
            onRead: function(d) {
                var v = parseFloat(d.trim());
                if (!isNaN(v))
                    root.temp = v;

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
        text: " " + root.temp + "°C"
        color: root.temp >= 80 ? root.barTheme.critical : root.temp >= 65 ? root.barTheme.warning : root.barTheme.foreground

        font {
            family: root.barTheme.fontFamily
            pixelSize: root.barTheme.fontSize
        }

    }

}
