import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root

    property var notifServer: null
    property string accent: "#89b4fa"
    property string muted:  "#585b70"
    property string red:    "#f38ba8"
    property string green:  "#a6e3a1"
    property string fg:     "#cdd6f4"

    implicitWidth:  indicatorRow.implicitWidth
    implicitHeight: 28

    function refreshLiveStatus() {
        liveStatusProc.running = false
        liveStatusProc.running = true
    }

    function refreshPowerProfile() {
        powerProfileProc.running = false
        powerProfileProc.running = true
    }

    property bool idleDisabled: false
    property bool notifSilenced: notifServer?.dndEnabled ?? false
    property bool isRecording: false
    property string powerProfile: "balanced"

    function _getPowerProfileIcon(profile) {
        if (profile === "power-saver") return ""
        if (profile === "performance") return ""
        return ""
    }

    function _togglePowerProfile() {
        const current = root.powerProfile
        const profiles = ["power-saver", "balanced", "performance"]
        const idx = profiles.indexOf(current)
        const next = profiles[(idx + 1) % profiles.length]
        root.runCmd("powerprofilesctl set " + next)
        Qt.callLater(refreshPowerProfile)
    }

    Process {
        id: liveStatusProc
        command: ["bash", "-c",
            "printf '%s\\t%s\\t%s\\n' " +
            "\"$(pgrep -x hypridle > /dev/null && echo running || echo stopped)\" " +
            "\"local\" " +
            "\"$(pgrep -f '^gpu-screen-recorder' > /dev/null && echo recording || echo stopped)\""]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split("\t")
                root.idleDisabled = parts[0] === "stopped"
                root.isRecording = parts[2] === "recording"
            }
        }
    }

    Timer {
        interval: 1000
        running:  true
        repeat:   true
        onTriggered: {
            refreshLiveStatus()
            refreshPowerProfile()
        }
    }

    Process {
        id: powerProfileProc
        command: ["bash", "-lc", "powerprofilesctl get 2>/dev/null || echo balanced"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                root.powerProfile = (data.trim() || "balanced");
            }
        }
    }

    // ── shell helpers ─────────────────────────────────────────────
    property int _cmdSeq: 0

    function runCmd(cmd) {
        var escapedCmd = cmd.replace(/"/g, '\\"');
        Qt.createQmlObject(
            'import Quickshell.Io; Process { command: ["bash", "-c", "setsid --fork bash -c \\"export PATH=\\$HOME/.dhmsDots:\\$PATH; ' + escapedCmd + '\\" &"]; running: true }',
            root, "proc" + (++_cmdSeq)
        )
    }

    // ── UI ────────────────────────────────────────────────────────
    Row {
        id:                     indicatorRow
        anchors.verticalCenter: parent.verticalCenter
        spacing:                8

        // power profile indicator
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root._getPowerProfileIcon(root.powerProfile)
            color: root.green
            font.pixelSize: 13
            font.family: "JetBrainsMono Nerd Font"

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root._togglePowerProfile()
            }
        }

        // idle disabled indicator
        Text {
            visible:                root.idleDisabled
            anchors.verticalCenter: parent.verticalCenter
            text:                   "󱫖"
            color:                  root.fg
            font.pixelSize:         13
            font.family:            "JetBrainsMono Nerd Font"

            Behavior on opacity { NumberAnimation { duration: 150 } }

            MouseArea {
                anchors.fill: parent
                cursorShape:  Qt.PointingHandCursor
                hoverEnabled: true
                onClicked:    root.runCmd("toggle-idle")
                onEntered:    parent.opacity = 0.7
                onExited:     parent.opacity = 1.0
            }
        }

        // screen recording indicator — pulsing red when active
        Text {
            id:                     recordingIcon
            visible:                root.isRecording
            anchors.verticalCenter: parent.verticalCenter
            text:                   "󰻂"
            color:                  root.red
            font.pixelSize:         13
            font.family:            "JetBrainsMono Nerd Font"

            SequentialAnimation on opacity {
                loops:   Animation.Infinite
                running: root.isRecording
                NumberAnimation { to: 0.3; duration: 800; easing.type: Easing.InOutSine }
                NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutSine }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape:  Qt.PointingHandCursor
                onClicked: root.runCmd("export PATH=\"$HOME/.dhmsDots/bin:$PATH\"; screenrecord --stop-recording")
            }
        }
    }
}
