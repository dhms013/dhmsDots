import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// Live throughput pill. Same delta math as the network panel's Receiving /
// Sending rows (rx/tx counter deltas between successive `--verbose` samples),
// kept inline so this widget stays self-contained and loads even when the
// network plugin directory is absent.
BarWidget {
  id: root
  moduleName: "dhms.network-speed"

  property string curIface: ""
  property real downloadRate: 0
  property real uploadRate: 0
  property real lastRxBytes: 0
  property real lastTxBytes: 0

  // Throughput sample state (mirrors network/Model.js throughputState).
  property string prevIface: ""
  property real prevRxBytes: 0
  property real prevTxBytes: 0
  property real prevSampleTime: 0

  readonly property string label: "↓ " + formatRate(downloadRate) + " ↑ " + formatRate(uploadRate)
  // The bar's showTooltip gates on this exact flag; without it hover never
  // promotes a pending tooltip.
  readonly property bool tooltipHovered: visible && hover.containsMouse

  function parseKeyValue(raw) {
    var next = {}
    var lines = String(raw || "").split("\n")
    for (var i = 0; i < lines.length; i++) {
      var idx = lines[i].indexOf("\t")
      if (idx === -1) continue
      next[lines[i].substring(0, idx)] = lines[i].substring(idx + 1).trim()
    }
    return next
  }

  function throughputState(previous, sample, now) {
    var prev = previous
    var iface = sample.iface || ""
    var rx = parseFloat(sample.rx_bytes || "0")
    var tx = parseFloat(sample.tx_bytes || "0")
    var previousTime = Number(prev.prevSampleTime || 0)

    if (iface !== (prev.prevIface || "") || previousTime === 0) {
      return {
        prevIface: iface,
        prevRxBytes: rx,
        prevTxBytes: tx,
        prevSampleTime: now,
        downloadRate: 0,
        uploadRate: 0
      }
    }

    var down = Number(prev.downloadRate || 0)
    var up = Number(prev.uploadRate || 0)
    var dt = now - previousTime
    if (dt > 0) {
      down = Math.max(0, (rx - Number(prev.prevRxBytes || 0)) / dt)
      up = Math.max(0, (tx - Number(prev.prevTxBytes || 0)) / dt)
    }

    return {
      prevIface: iface,
      prevRxBytes: rx,
      prevTxBytes: tx,
      prevSampleTime: now,
      downloadRate: down,
      uploadRate: up
    }
  }

  function formatBytes(bytes) {
    var n = Number(bytes)
    if (!isFinite(n) || n < 0) n = 0
    if (n < 1024) return Math.round(n) + " B"
    if (n < 1024 * 1024) return (n / 1024).toFixed(1) + " KB"
    if (n < 1024 * 1024 * 1024) return (n / (1024 * 1024)).toFixed(1) + " MB"
    return (n / (1024 * 1024 * 1024)).toFixed(2) + " GB"
  }

  function formatRate(bytesPerSec) {
    return formatBytes(bytesPerSec) + "/s"
  }

  function update(raw) {
    var next = parseKeyValue(raw)
    var state = throughputState({
      prevIface: prevIface,
      prevRxBytes: prevRxBytes,
      prevTxBytes: prevTxBytes,
      prevSampleTime: prevSampleTime,
      downloadRate: downloadRate,
      uploadRate: uploadRate
    }, next, Date.now() / 1000)

    prevIface = state.prevIface
    prevRxBytes = state.prevRxBytes
    prevTxBytes = state.prevTxBytes
    prevSampleTime = state.prevSampleTime
    downloadRate = state.downloadRate
    uploadRate = state.uploadRate
    curIface = next.iface || ""
    lastRxBytes = parseFloat(next.rx_bytes || "0") || 0
    lastTxBytes = parseFloat(next.tx_bytes || "0") || 0
  }

  visible: !vertical && curIface !== ""
  implicitWidth: visible ? labelText.implicitWidth + Style.spacing.controlPaddingX * 2 : 0
  implicitHeight: barSize

  Behavior on implicitWidth {
    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
  }

  Item {
    anchors.fill: parent
    anchors.leftMargin: Style.space(8)
    anchors.rightMargin: Style.space(8)
    clip: true

    Text {
      id: labelText
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      width: parent.width
      text: root.label
      color: root.bar ? root.bar.barForeground : Color.foreground
      font.family: root.bar ? root.bar.fontFamily : Style.font.family
      font.pixelSize: Style.font.bodySmall
      opacity: 0.85
    }
  }

  MouseArea {
    id: hover
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.ArrowCursor

    onEntered: if (root.bar) root.bar.showTooltip(root, "↓ " + root.formatBytes(root.lastRxBytes) + " ↑ " + root.formatBytes(root.lastTxBytes) + " this session")
    onExited: if (root.bar) root.bar.hideTooltip(root)
  }

  Process {
    id: statsProc
    command: ["dhms-network-status", "--verbose"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.update(text)
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: if (!statsProc.running) statsProc.running = true
  }
}
