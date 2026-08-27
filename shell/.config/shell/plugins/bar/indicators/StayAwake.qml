import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarIndicator {
    id: root

    // The dhms.idle service is disabled in this setup; idle locking runs as
    // system hypridle and flips with the `toggle-idle` script. The indicator
    // mirrors that process instead of a service.
    property bool hypridleRunning: true

    function toggle() {
        Util.execDetached("toggle-idle");
        // hypridle takes a beat to appear/disappear; re-probe shortly after.
        probeRestart.restart();
    }

    active: !root.hypridleRunning
    activeText: "󰅶"
    inactiveText: "󰅶"
    activeTooltipText: "Stay Awake — idle lock off"
    inactiveTooltipText: "Allow Idle Lock"
    onPressed: function() {
        root.toggle();
    }
    Component.onCompleted: hypridleProbe.running = true

    Process {
        id: hypridleProbe

        command: ["bash", "-c", "pgrep -x hypridle >/dev/null && echo on || echo off"]

        stdout: SplitParser {
            onRead: function(line) {
                root.hypridleRunning = String(line).trim() === "on";
            }
        }

    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: hypridleProbe.running = true
    }

    Timer {
        id: probeRestart

        interval: 600
        onTriggered: hypridleProbe.running = true
    }

}
