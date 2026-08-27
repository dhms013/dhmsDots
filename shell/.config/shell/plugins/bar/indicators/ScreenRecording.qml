import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarIndicator {
    id: root

    property bool recording: false

    function refresh() {
        if (!root.bar || statusProc.running)
            return ;

        statusProc.command = ["pgrep", "--quiet", "-f", "^gpu-screen-recorder"];
        statusProc.running = true;
    }

    active: recording
    activeText: "󰻂"
    inactiveText: "󰻂"
    activeTooltipText: "Stop recording"
    inactiveTooltipText: "Screen Recording"
    onBarChanged: refresh()
    Component.onCompleted: refresh()
    onPressed: function() {
        if (root.bar)
            root.bar.run(root.recording ? "screenrecord --stop-recording" : "dhms-shell shell toggle dhms.menu '{\"menu\":\"trigger.capture.screenrecord\"}'");

    }

    // Auto-refresh like StayAwake: poll every 5s + re-probe after click
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: refresh()
    }

    Timer {
        id: probeRestart

        interval: 600
        onTriggered: refresh()
    }

    Connections {
        function onRefreshRequested() {
            root.refresh();
        }

        target: root.indicatorHost
        ignoreUnknownSignals: true
    }

    Process {
        id: statusProc

        onExited: function(exitCode) {
            root.recording = exitCode === 0;
        }
    }

}
