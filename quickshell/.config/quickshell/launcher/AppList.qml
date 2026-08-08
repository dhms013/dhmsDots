import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Item {
    id: list

    property string launcherScreenName: ""
    property var allApps: []
    property var filteredApps: []
    property int selectedIdx: 0
    property var theme: ({
    })
    property string currentQuery: ""

    signal launched()

    function filter(query) {
        currentQuery = query || "";
        selectedIdx = 0;
        if (!query || query.trim() === "") {
            filteredApps = allApps.slice(0, 50);
            return ;
        }
        if (query.startsWith("=")) {
            var expr = query.slice(1).trim();
            if (expr) {
                try {
                    var result = list.evalMath(expr);
                    if (result !== null && result !== undefined && !isNaN(result)) {
                        result = Number(result).toString();
                        filteredApps = [{
                            "name": result,
                            "exec": "echo " + result + " | wl-copy",
                            "icon": "",
                            "isCalc": true
                        }];
                    }
                } catch (e) {
                }
                return ;
            }
        }
        const q = query.toLowerCase();
        const sw = allApps.filter((a) => {
            return a.name.toLowerCase().startsWith(q);
        });
        const inc = allApps.filter((a) => {
            return !a.name.toLowerCase().startsWith(q) && a.name.toLowerCase().includes(q);
        });
        filteredApps = sw.concat(inc).slice(0, 50);
    }

    function launchSelected() {
        if (filteredApps.length === 0)
            return ;

        const idx = Math.max(0, Math.min(selectedIdx, filteredApps.length - 1));
        launchApp(filteredApps[idx]);
    }

    function moveDown() {
        if (filteredApps.length === 0)
            return ;

        selectedIdx = Math.min(selectedIdx + 1, filteredApps.length - 1);
        lv.positionViewAtIndex(selectedIdx, ListView.Visible);
    }

    function moveUp() {
        if (filteredApps.length === 0)
            return ;

        selectedIdx = Math.max(selectedIdx - 1, 0);
        lv.positionViewAtIndex(selectedIdx, ListView.Visible);
    }

    function launchApp(app) {
        if (!app || !app.exec)
            return ;

        if (app.isCalc === true) {
            var result = app.name;
            Qt.createQmlObject('import Quickshell.Io; Process { command: ["bash", "-c", "wl-copy \\"' + result + '\\""]; running: true }', list);
            list.launched();
            return ;
        }
        const cmd = app.exec.replace(/%[uUfFdDnNickvm]/g, "").trim();
        if (!cmd)
            return ;

        const script = "WS=$(hyprctl monitors -j | jq -r --arg s \"" + list.launcherScreenName + "\" '.[] | select(.name==$s) | .activeWorkspace.id' | head -1);\n" + "[ -n \"$WS\" ] && hyprctl dispatch workspace \"$WS\";\n" + "exec uwsm-app -- bash -c " + cmd;
        Quickshell.execDetached(["bash", "-c", script]);
        list.launched();
    }

    function reload() {
        parser.stdout.apps = [];
        parser.stdout.buf = "";
        parser.running = false;
        parser.running = true;
    }

    function evalMath(expr) {
        var safe = expr.replace(/[^0-9+\-*/.()%]/g, "");
        try {
            var fn = new Function("return " + safe);
            return fn();
        } catch (err) {
            return null;
        }
    }

    Process {
        id: parser

        command: ["bash", "-lc", "XDG_DATA_HOME=\"${XDG_DATA_HOME:-$HOME/.local/share}\"; " + "declare -A hidden_apps; " + "for f in \"$XDG_DATA_HOME\"/applications/*.desktop ~/Desktop/*.desktop; do " + "  [ -f \"$f\" ] || continue; " + "  hidden=$(grep -m1 '^Hidden=' \"$f\" 2>/dev/null | cut -d= -f2-); " + "  [ \"$hidden\" = \"true\" ] && hidden_apps[$(basename \"$f\")]=1; " + "done; " + "for f in /usr/share/applications/*.desktop /usr/local/share/applications/*.desktop \"$XDG_DATA_HOME\"/applications/*.desktop ~/Desktop/*.desktop; do " + "  [ -f \"$f\" ] || continue; " + "  fname=$(basename \"$f\"); " + "  [ \"${hidden_apps[$fname]}\" = \"1\" ] && continue; " + "  name=$(grep -m1 '^Name=' \"$f\" | cut -d= -f2-); " + "  exec=$(grep -m1 '^Exec=' \"$f\" | cut -d= -f2-); " + "  icon=$(grep -m1 '^Icon=' \"$f\" | cut -d= -f2-); " + "  nodisplay=$(grep -m1 '^NoDisplay=' \"$f\" | cut -d= -f2-); " + "  [ \"$nodisplay\" = \"true\" ] && continue; " + "  [ -z \"$name\" ] && continue; " + "  [ -z \"$exec\" ] && continue; " + "  iconpath=\"\"; " + "  if [ -n \"$icon\" ]; then " + "    if [ -f \"$icon\" ]; then " + "      iconpath=\"$icon\"; " + "    else " + "      for dir in /usr/share/icons/hicolor \"$XDG_DATA_HOME\"/icons /usr/share/pixmaps /usr/local/share/icons; do " + "        for size in 256 128 64 48 32 24 22 16; do " + "          if [ -f \"$dir/${size}x${size}/apps/$icon.png\" ]; then " + "            iconpath=\"$dir/${size}x${size}/apps/$icon.png\"; break; " + "          elif [ -f \"$dir/${size}x${size}/$icon.png\" ]; then " + "            iconpath=\"$dir/${size}x${size}/$icon.png\"; break; " + "          elif [ -f \"$dir/$size/apps/$icon.png\" ]; then " + "            iconpath=\"$dir/$size/apps/$icon.png\"; break; " + "          elif [ -f \"$dir/$size/$icon.png\" ]; then " + "            iconpath=\"$dir/$size/$icon.png\"; break; " + "          elif [ -f \"$dir/$icon.png\" ]; then " + "            iconpath=\"$dir/$icon.png\"; break; " + "          fi; " + "        done; " + "        [ -n \"$iconpath\" ] && break; " + "      done; " + "      if [ -z \"$iconpath\" ]; then " + "        for ext in svg png xpm; do " + "          if [ -f \"/usr/share/icons/hicolor/apps/$icon.$ext\" ]; then " + "            iconpath=\"/usr/share/icons/hicolor/apps/$icon.$ext\"; break; " + "          fi; " + "        done; " + "      fi; " + "    fi; " + "  fi; " + "  printf '%s|%s|%s\\n' \"$name\" \"$exec\" \"$iconpath\"; " + "done | sort -u"]
        running: true
        onExited: {
            list.allApps = parser.stdout.apps.slice();
            parser.stdout.apps = [];
            parser.stdout.buf = "";
            list.filter(list.currentQuery);
        }

        stdout: SplitParser {
            property var apps: []
            property string buf: ""

            onRead: (data) => {
                buf += data + "\n";
                const lines = buf.split("\n");
                buf = lines.pop();
                for (const line of lines) {
                    const trimmed = (line || "").trim();
                    if (!trimmed)
                        continue;

                    const parts = trimmed.split("|");
                    if (parts.length < 2)
                        continue;

                    const name = parts[0].trim();
                    const exec = parts[1].trim();
                    const icon = parts[2] ? parts[2].trim() : "";
                    if (name && exec)
                        apps.push({
                        "name": name,
                        "exec": exec,
                        "icon": icon
                    });

                }
            }
        }

    }

    ListView {
        id: lv

        anchors.fill: parent
        model: list.filteredApps
        clip: true
        spacing: 1

        displaced: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 120
                easing.type: Easing.OutCubic
            }

        }

        delegate: Item {
            id: appDelegate

            property bool isSelected: index === list.selectedIdx

            width: lv.width
            height: 28
            // fade + slide in on appear
            opacity: 0
            Component.onCompleted: {
                appAppearTimer.interval = Math.min(index * 12, 300);
                appAppearTimer.start();
            }

            Timer {
                id: appAppearTimer

                repeat: false
                onTriggered: appAppearAnim.start()
            }

            ParallelAnimation {
                id: appAppearAnim

                NumberAnimation {
                    target: appDelegate
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 160
                    easing.type: Easing.OutCubic
                }

                NumberAnimation {
                    target: appDelegateTx
                    property: "x"
                    from: -6
                    to: 0
                    duration: 160
                    easing.type: Easing.OutCubic
                }

            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: 0
                radius: 6
                color: isSelected ? Qt.alpha(theme.accent || "#89b4fa", 0.12) : rowMa.containsMouse ? Qt.alpha(theme.dim || "#45475a", 0.35) : "transparent"
                border.color: isSelected ? Qt.alpha(theme.accent || "#89b4fa", 0.25) : "transparent"
                border.width: 1

                // left accent bar
                Rectangle {
                    width: 2
                    height: isSelected ? 14 : 0
                    radius: 1
                    color: theme.fg || "#89b4fa"
                    anchors.left: parent.left
                    anchors.leftMargin: 3
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on height {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.OutCubic
                        }

                    }

                }

                // icon
                Image {
                    id: appIcon

                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    width: 20
                    height: 20
                    source: modelData.icon ? "file://" + modelData.icon : ""
                    sourceSize.width: 20
                    sourceSize.height: 20
                    smooth: true
                    visible: status === Image.Ready && modelData.icon
                    onStatusChanged: {
                        if (status === Image.Error)
                            visible = false;

                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    text: modelData.name
                    color: isSelected ? (theme.fg || "#cdd6f4") : Qt.alpha(theme.fg || "#cdd6f4", 0.5)
                    font.pixelSize: 11
                    font.family: "JetBrainsMono Nerd Font"
                    font.weight: isSelected ? Font.Medium : Font.Normal

                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }

                    }

                }

                // exec hint — only on selected, far right
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    visible: isSelected
                    opacity: isSelected ? 1 : 0
                    text: modelData.exec.split(" ")[0].split("/").pop()
                    color: Qt.alpha(theme.muted || "#585b70", 0.4)
                    font.pixelSize: 9
                    font.family: "JetBrainsMono Nerd Font"

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 120
                            easing.type: Easing.OutCubic
                        }

                    }

                }

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                        easing.type: Easing.OutCubic
                    }

                }

                Behavior on border.color {
                    ColorAnimation {
                        duration: 100
                    }

                }

            }

            MouseArea {
                id: rowMa

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: list.selectedIdx = index
                onClicked: {
                    list.selectedIdx = index;
                    list.launchApp(modelData);
                }
            }

            transform: Translate {
                id: appDelegateTx

                x: -6
            }

        }

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
            width: 2
        }

        Behavior on contentY {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }

        }

    }

}
