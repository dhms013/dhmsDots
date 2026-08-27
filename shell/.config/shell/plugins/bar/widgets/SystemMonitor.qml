import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// CPU + RAM readout. RAM shows used/total with swap folded into both sides
// (raw numbers come straight from the script); CPU% is computed here from
// /proc/stat tick deltas between consecutive 1s samples, which is far
// smoother than the instantaneous top-style reading. Hovering reveals the
// per-core breakdown (2-column grid) plus separate RAM/Swap rows.
BarWidget {
  id: root
  moduleName: "dhms.system-monitor"

  property real cpuPct: 0
  property var corePcts: []
  property double ramUsedKb: 0
  property double ramTotalKb: 0
  property double swapUsedKb: 0
  property double swapTotalKb: 0
  property double prevIdle: -1
  property double prevTotal: 0
  property var prevCoreIdle: []
  property var prevCoreTotal: []
  property bool prevSampleSeen: false

  // The bar's showTooltip gates on this exact flag; without it hover never
  // promotes a pending tooltip.
  readonly property bool tooltipHovered: visible && hover.containsMouse

  readonly property double memUsedKb: ramUsedKb + swapUsedKb
  readonly property double memTotalKb: ramTotalKb + swapTotalKb

  readonly property string label: "󰻠 " + Math.round(cpuPct) + "%  󰍛 " + formatUsed(memUsedKb) + "/" + formatTotal(memTotalKb)
  readonly property string tooltipText: coreTooltip() + "\n" +
    "RAM : " + formatUsed(ramUsedKb) + "/" + formatTotal(ramTotalKb) + "\n" +
    "Swap : " + formatUsed(swapUsedKb) + "/" + formatTotal(swapTotalKb)

  function formatUsed(kb) {
    if (!isFinite(kb) || kb < 0) kb = 0
    if (kb < 1024) return Math.round(kb) + "K"
    if (kb < 1024 * 1024) return (kb / 1024).toFixed(1) + "M"
    return (kb / (1024 * 1024)).toFixed(1) + "G"
  }

  function formatTotal(kb) {
    if (!isFinite(kb) || kb <= 0) return "—"
    var g = kb / (1024 * 1024)
    return g.toFixed(1).replace(/\.0$/, "") + "G"
  }

  // Sequential horizontal pairing like the user sketch: c0|c1 on the first
  // row, c2|c3 on the next. padEnd keeps the columns readable even though
  // the bar font is proportional.
  function coreTooltip() {
    var lines = []
    var n = corePcts.length
    for (var r = 0; r < n; r += 2) {
      var left = ("c" + r + " : " + Math.round(corePcts[r]) + "%").padEnd(10)
      var right = r + 1 < n ? ("c" + (r + 1) + " : " + Math.round(corePcts[r + 1]) + "%").padEnd(10) : ""
      lines.push(left + right)
    }
    return lines.join("\n")
  }

  function update(raw) {
    var lines = String(raw || "").split("\n")
    // Work on copies and commit once: in-place pushes/index writes on a var
    // array property never fire change notifications, so tooltipText would
    // freeze at its first evaluation.
    var nextCorePcts = corePcts.slice()
    var nextCoreIdle = prevCoreIdle.slice()
    var nextCoreTotal = prevCoreTotal.slice()
    var coresChanged = false

    for (var i = 0; i < lines.length; i++) {
      var idx = lines[i].indexOf("\t")
      if (idx === -1) continue
      var key = lines[i].substring(0, idx)
      var value = lines[i].substring(idx + 1).trim()
      if (key === "cpu") {
        var parts = value.split("\t")
        var idle = parseFloat(parts[0])
        var total = parseFloat(parts[1])
        if (isFinite(idle) && isFinite(total) && prevIdle >= 0 && total > prevTotal) {
          var rawCpu = Math.max(0, Math.min(100, (1 - (idle - prevIdle) / (total - prevTotal)) * 100))
          // Exponential smoothing keeps the 1s samples from twitching while
          // still tracking real load within two or three ticks.
          cpuPct = prevSampleSeen ? cpuPct * 0.6 + rawCpu * 0.4 : rawCpu
          prevSampleSeen = true
        }
        prevIdle = idle
        prevTotal = total
      } else if (key === "core") {
        var fields = value.split("\t")
        var core = parseInt(fields[0], 10)
        var cIdle = parseFloat(fields[1])
        var cTotal = parseFloat(fields[2])
        if (!isFinite(core) || core < 0) continue
        while (nextCoreIdle.length <= core) { nextCoreIdle.push(-1); nextCoreTotal.push(0); nextCorePcts.push(0); coresChanged = true }
        var pIdle = nextCoreIdle[core]
        var pTotal = nextCoreTotal[core]
        if (isFinite(cIdle) && isFinite(cTotal) && pIdle >= 0 && cTotal > pTotal) {
          var rawCore = Math.max(0, Math.min(100, (1 - (cIdle - pIdle) / (cTotal - pTotal)) * 100))
          var smoothed = nextCorePcts[core] * 0.6 + rawCore * 0.4
          if (Math.abs(smoothed - nextCorePcts[core]) >= 0.5) {
            nextCorePcts[core] = smoothed
            coresChanged = true
          }
        }
        nextCoreIdle[core] = cIdle
        nextCoreTotal[core] = cTotal
      } else if (key === "ramuse") {
        var nums = value.split("\t")
        var used = parseFloat(nums[0])
        var grand = parseFloat(nums[1])
        if (isFinite(used) && used >= 0) ramUsedKb = used
        if (isFinite(grand) && grand >= 0) ramTotalKb = grand
      } else if (key === "swapuse") {
        var snums = value.split("\t")
        var sUsed = parseFloat(snums[0])
        var sGrand = parseFloat(snums[1])
        if (isFinite(sUsed) && sUsed >= 0) swapUsedKb = sUsed
        if (isFinite(sGrand) && sGrand >= 0) swapTotalKb = sGrand
      }
    }

    prevCoreIdle = nextCoreIdle
    prevCoreTotal = nextCoreTotal
    if (coresChanged) corePcts = nextCorePcts
  }

  visible: !vertical
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
    cursorShape: Qt.PointingHandCursor

    onClicked: if (root.bar) root.bar.run("dhms-terminal btop")
    onEntered: if (root.bar) root.bar.showTooltip(root, root.tooltipText)
    onExited: if (root.bar) root.bar.hideTooltip(root)
  }

  Process {
    id: statsProc
    command: ["dhms-system-stats", "--bar-widget"]
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
