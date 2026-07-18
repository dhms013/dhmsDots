import QtQuick

Item {
    property string label: ""
    property real value: 0
    property string suffix: ""
    property string extraText: ""
    property color accent: "#89b4fa"
    property color trackColor: "#45475a"
    property color textColor: "#cdd6f4"
    property bool hovered: ma.containsMouse

    implicitWidth: row.implicitWidth
    implicitHeight: 28
    anchors.verticalCenter: parent ? parent.verticalCenter : undefined
    onAccentChanged: fillCanvas.requestPaint()

    MouseArea {
        id: ma

        anchors.fill: parent
        anchors.margins: -6
        hoverEnabled: true
    }

    Row {
        id: row

        anchors.verticalCenter: parent.verticalCenter
        spacing: 5

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: label
            color: hovered ? accent : textColor
            font.pixelSize: 10
            font.family: "JetBrainsMono Nerd Font"
            opacity: hovered ? 1 : 0.5

            Behavior on color {
                ColorAnimation {
                    duration: 200
                }

            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }

            }

        }

        Item {
            anchors.verticalCenter: parent.verticalCenter
            width: hovered ? 36 : 0
            height: 6
            clip: true

            Canvas {
                id: trackCanvas

                property real phase: 0

                width: 36
                height: 6
                anchors.verticalCenter: parent.verticalCenter
                onPhaseChanged: requestPaint()
                onPaint: {
                    const ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);
                    ctx.beginPath();
                    for (let x = 0; x <= width; x++) {
                        const y = height / 2 + Math.sin((x / width) * Math.PI * 1.8 + phase) * 1.6;
                        x === 0 ? ctx.moveTo(x, y) : ctx.lineTo(x, y);
                    }
                    ctx.strokeStyle = trackColor;
                    ctx.lineWidth = 3;
                    ctx.lineCap = "round";
                    ctx.stroke();
                }

                NumberAnimation on phase {
                    from: 0
                    to: Math.PI * 2
                    duration: 3000
                    loops: Animation.Infinite
                    running: hovered
                }

            }

            Canvas {
                id: fillCanvas

                property real phase: trackCanvas.phase
                property real fillWidth: 36 * Math.min(value / 100, 1)

                width: 36
                height: 6
                anchors.verticalCenter: parent.verticalCenter
                onPhaseChanged: requestPaint()
                onFillWidthChanged: requestPaint()
                onPaint: {
                    const ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);
                    if (fillWidth <= 0)
                        return ;

                    ctx.save();
                    ctx.beginPath();
                    ctx.rect(0, 0, fillWidth, height);
                    ctx.clip();
                    ctx.beginPath();
                    for (let x = 0; x <= width; x++) {
                        const y = height / 2 + Math.sin((x / width) * Math.PI * 1.8 + phase) * 1.6;
                        x === 0 ? ctx.moveTo(x, y) : ctx.lineTo(x, y);
                    }
                    ctx.strokeStyle = accent;
                    ctx.lineWidth = 3;
                    ctx.lineCap = "round";
                    ctx.stroke();
                    ctx.restore();
                }

                Behavior on fillWidth {
                    SmoothedAnimation {
                        velocity: 25
                        easing.type: Easing.OutCubic
                    }

                }

            }

            Behavior on width {
                SmoothedAnimation {
                    velocity: 140
                    easing.type: Easing.OutCubic
                }

            }

        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: value.toFixed(1) + suffix + extraText
            color: accent
            font.pixelSize: 10
            font.family: "JetBrainsMono Nerd Font"

            Behavior on color {
                ColorAnimation {
                    duration: 300
                }

            }

        }

    }

}

