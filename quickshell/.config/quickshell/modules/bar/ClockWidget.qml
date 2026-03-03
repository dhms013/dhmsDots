import QtQuick
import Quickshell

Item {
    id: root

    required property QtObject barTheme
    property bool calOpen: false

    implicitWidth: lbl.implicitWidth + 4
    implicitHeight: barTheme.barHeight

    SystemClock {
        id: clk

        precision: SystemClock.Minutes
    }

    Text {
        id: lbl

        anchors.centerIn: parent
        text: {
            var n = new Date(), d = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
            return d[n.getDay()] + " " + String(n.getDate()).padStart(2, "0") + ", " + String(n.getHours()).padStart(2, "0") + ":" + String(n.getMinutes()).padStart(2, "0");
        }
        color: root.barTheme.foreground

        font {
            family: root.barTheme.fontFamily
            pixelSize: root.barTheme.fontSize
        }

    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.calOpen = !root.calOpen
    }

    FloatingWindow {
        visible: root.calOpen
        color: "transparent"
        implicitWidth: 240
        implicitHeight: cal.implicitHeight

        CalendarPopup {
            id: cal

            anchors.fill: parent
            barTheme: root.barTheme
            onCloseRequested: root.calOpen = false
        }

    }

}
