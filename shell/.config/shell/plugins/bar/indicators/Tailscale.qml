import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarIndicator {
  id: root

  property bool running: false

  function refresh() {
    if (!tailscaleProbe.running)
      tailscaleProbe.running = true
  }

  function toggle() {
    // up/down need sudo and the bar has no TTY, so prompt in a terminal.
    Util.execDetached("dhms-floating-terminal dhms-tailscale toggle")
    // tailscaled takes a beat to settle; re-probe shortly after.
    probeRestart.restart()
  }

  active: root.running
  activeText: ""
  inactiveText: ""
  activeTooltipText: "Tailscale connected — click to disconnect"
  inactiveTooltipText: "Tailscale off — click to connect"
  onPressed: function() {
    root.toggle()
  }

  // The Tailscale mark is a 3×3 dot grid — the four corners faded, the rest
  // solid — and Nerd Font has no glyph for it, so draw it like the official
  // logo rather than borrow a generic VPN glyph. Sizing follows the slot the
  // shared bar hands us, so the same code works in horizontal and vertical
  // bars.
  iconComponent: Component {
    Item {
      id: logo

      readonly property real size: Math.min(width, height)
      readonly property real dot: Math.max(2, size * 0.24)
      readonly property real gap: (size - dot) / 2
      readonly property var dots: [
        { gx: 0, gy: 0, o: 0.24 },
        { gx: 1, gy: 0, o: 1.0 },
        { gx: 2, gy: 0, o: 0.24 },
        { gx: 0, gy: 1, o: 1.0 },
        { gx: 1, gy: 1, o: 1.0 },
        { gx: 2, gy: 1, o: 1.0 },
        { gx: 0, gy: 2, o: 0.24 },
        { gx: 1, gy: 2, o: 1.0 },
        { gx: 2, gy: 2, o: 0.24 }
      ]

      Repeater {
        model: logo.dots

        Rectangle {
          required property var modelData
          x: modelData.gx * logo.gap
          y: modelData.gy * logo.gap
          width: logo.dot
          height: logo.dot
          radius: width / 2
          color: root.foreground
          opacity: modelData.o
        }
      }
    }
  }

  Component.onCompleted: root.refresh()

  Process {
    id: tailscaleProbe

    command: ["dhms-tailscale", "status"]

    stdout: SplitParser {
      onRead: function(line) {
        root.running = String(line).trim() === "on"
      }
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: root.refresh()
  }

  Timer {
    id: probeRestart

    interval: 700
    onTriggered: root.refresh()
  }
}
