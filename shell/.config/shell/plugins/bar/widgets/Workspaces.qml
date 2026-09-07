import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
    id: root

    readonly property var kanji: ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十"]
    readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

    function workspaceById(id) {
        var values = Hyprland.workspaces.values;
        for (var i = 0; i < values.length; i++) {
            if (values[i].id === id)
                return values[i];

        }
        return null;
    }

    function workspaceIds() {
        var ids = [1, 2, 3, 4, 5];
        var values = Hyprland.workspaces.values;
        for (var i = 0; i < values.length; i++) {
            var id = values[i].id;
            if (id > 0 && id <= 10 && ids.indexOf(id) === -1)
                ids.push(id);

        }
        ids.sort(function(left, right) {
            return left - right;
        });
        return ids;
    }

    function focusWorkspace(id) {
        if (!root.bar)
            return ;

        root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"));
    }

    moduleName: "dhms.workspaces"
    implicitWidth: grid.implicitWidth + trailingGap
    implicitHeight: grid.implicitHeight

    GridLayout {
        id: grid

        anchors.fill: parent
        anchors.rightMargin: root.trailingGap
        columns: root.vertical ? 1 : root.workspaceIds().length
        columnSpacing: root.vertical ? 0 : Style.space(1)
        rowSpacing: root.vertical ? Style.space(2) : 0

        Repeater {
            model: root.workspaceIds()

            WidgetButton {
                required property int modelData
                readonly property var workspace: root.workspaceById(modelData)
                readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
                readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData

                bar: root.bar
                text: root.kanji[modelData - 1]
                fontSize: Style.font.bodySmall
                opacity: occupied || focused ? 1 : 0.5
                horizontalMargin: 6
                verticalPadding: 6
                fixedWidth: root.vertical ? root.barSize : Style.space(20)
                fixedHeight: root.barSize
                onPressed: function() {
                    root.focusWorkspace(modelData);
                }

                Rectangle {
                    id: activeUnderline

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 2
                    width: focused ? parent.labelWidth + 6 : 0
                    height: 0.85
                    radius: 99
                    color: Color.accent

                    Behavior on width {
                        SmoothedAnimation {
                            velocity: 300
                            easing.type: Easing.OutCubic
                        }

                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }

                    }

                }

            }

        }

    }

}
