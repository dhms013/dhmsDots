import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: menuWin
    visible: false
    color: "transparent"

    anchors { top: true; bottom: true; left: true; right: true }

    WlrLayershell.layer:         WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.namespace:     "quickshell:menu"

    readonly property int itemHeight:     44
    readonly property int promptHeight:   36
    readonly property int menuWidth:      280

    property string prompt:   ""
    property var    options:  []
    property string pipePath: ""
    property int    selected: 0

    // ── Theme ─────────────────────────────────────────────────────────
    property color colBase:         "#00110b"
    property color colBorder:       "#00a86b"
    property color colText:         "#00a86b"
    property color colForeground:   "#e6f6f0"
    property color colSelectedText: "#C3FCB8"

    property string cssAccum: ""

    Process {
        id: themeReader
        command: ["sh", "-c",
            "cat $HOME/.config/themes/current/theme/launcher.css 2>/dev/null || true"
        ]
        stdout: SplitParser {
            onRead: function(line) { menuWin.cssAccum += line + "\n" }
        }
        onRunningChanged: {
            if (!running && menuWin.cssAccum.length > 0) {
                menuWin.applyTheme(menuWin.cssAccum)
                menuWin.cssAccum = ""
            }
        }
    }

    function applyTheme(css) {
        function get(key) {
            var m = new RegExp(
                "@define-color\\s+" + key + "\\s+(#[0-9a-fA-F]+)"
            ).exec(css)
            return m ? m[1] : null
        }
        var v
        v = get("base");          if (v) colBase         = v
        v = get("background");    if (v) colBase         = v
        v = get("border");        if (v) colBorder       = v
        v = get("text");          if (v) colText         = v
        v = get("foreground");    if (v) colForeground   = v
        v = get("selected-text"); if (v) colSelectedText = v
    }

    Component.onCompleted: themeReader.running = true

    // ── Public API ───────────────────────────────────────────────────
    function show(promptStr, opts, pipe) {
        prompt   = promptStr
        options  = opts
        pipePath = pipe
        selected = 0
        visible  = true
        card.forceActiveFocus()
    }

    function confirm(idx) {
        if (idx < 0 || idx >= options.length) { cancel(); return }
        writeToPipe(options[idx])
        visible = false
    }

    function cancel() {
        writeToPipe("CNCLD")
        visible = false
    }

    function writeToPipe(value) {
        if (!pipePath) return
        pipeProc.command = ["sh", "-c",
            "printf '%s' " + JSON.stringify(value) + " > " + pipePath]
        pipeProc.running = true
    }

    Process { id: pipeProc }

    // ── Dimmed backdrop ───────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.45
        MouseArea {
            anchors.fill: parent
            onClicked: menuWin.cancel()
        }
    }

    // ── Menu card ─────────────────────────────────────────────────────
    Rectangle {
        id: card
        width:  menuWin.menuWidth
        height: menuWin.promptHeight + Math.min(5, optionList.count) * menuWin.itemHeight + 2
        anchors.centerIn: parent
        color:        menuWin.colBase
        border.color: menuWin.colBorder
        border.width: 1
        radius: 8
        focus: true

        MouseArea { anchors.fill: parent }

        Keys.onEscapePressed: menuWin.cancel()
        Keys.onReturnPressed: menuWin.confirm(menuWin.selected)
        Keys.onEnterPressed:  menuWin.confirm(menuWin.selected)
        Keys.onPressed: function(event) {
            if (event.modifiers & Qt.ControlModifier) {
                if (event.key === Qt.Key_J) menuWin.selected = Math.min(menuWin.selected + 1, menuWin.options.length - 1)
                if (event.key === Qt.Key_K) menuWin.selected = Math.max(menuWin.selected - 1, 0)
            }
            if (event.key === Qt.Key_Down) menuWin.selected = Math.min(menuWin.selected + 1, menuWin.options.length - 1)
            if (event.key === Qt.Key_Up)   menuWin.selected = Math.max(menuWin.selected - 1, 0)
        }

        Column {
            anchors.fill: parent

            // Prompt header
            Item {
                width:  parent.width
                height: menuWin.promptHeight

                Text {
                    anchors {
                        left: parent.left; leftMargin: 14
                        verticalCenter: parent.verticalCenter
                    }
                    text: menuWin.prompt + "…"
                    color: menuWin.colText
                    font { family: "JetBrainsMono Nerd Font"; pixelSize: 13; italic: true }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width; height: 1
                    color: menuWin.colBorder + "60"
                }
            }

            // Options
            ListView {
                id: optionList
                width:  parent.width
                height: Math.min(5, count) * menuWin.itemHeight
                model:  menuWin.options
                clip:   true

                delegate: Item {
                    required property string modelData
                    required property int    index
                    width:  optionList.width
                    height: menuWin.itemHeight

                    Rectangle {
                        anchors.fill: parent
                        color: menuWin.selected === index
                               ? menuWin.colBorder + "25" : "transparent"
                        Behavior on color { ColorAnimation { duration: 80 } }
                    }

                    Text {
                        anchors {
                            left: parent.left; leftMargin: 14
                            verticalCenter: parent.verticalCenter
                        }
                        text: modelData
                        color: menuWin.selected === index
                               ? menuWin.colSelectedText : menuWin.colForeground
                        font { family: "JetBrainsMono Nerd Font"; pixelSize: 13 }
                        Behavior on color { ColorAnimation { duration: 80 } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape:  Qt.PointingHandCursor
                        onEntered:    menuWin.selected = index
                        onClicked:    menuWin.confirm(index)
                    }
                }
            }
        }
    }
}
