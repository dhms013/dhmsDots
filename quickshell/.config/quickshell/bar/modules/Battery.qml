import QtQuick
import QtQuick.Controls
import Quickshell.Services.UPower

Item {
    id: root

    property var theme: ({
    })
    property bool _lowBatteryNotified: false
    readonly property var bat: getBattery()
    readonly property bool hasBattery: !!bat
    readonly property int pct: {
        if (!bat)
            return 0;

        var p = bat.percentage;
        return Math.round(p <= 1 ? p * 100 : p);
    }
    readonly property int state: bat ? bat.state : 0
    readonly property bool isCharging: state === UPowerDeviceState.Charging
    readonly property bool isFull: state === UPowerDeviceState.FullyCharged
    readonly property real rate: bat ? Math.abs(bat.changeRate) : 0
    readonly property var chargingIcons: ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]
    readonly property var dischargeIcons: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
    readonly property string icon: {
        if (!hasBattery)
            return "";

        if (isFull)
            return "󰂅";

        if (isFull && isCharging)
            return "";

        const idx = Math.min(9, Math.floor(pct / 10));
        return isCharging ? chargingIcons[idx] : dischargeIcons[idx];
    }

    function getBattery() {
        var devs = UPower.devices.values;
        for (var i = 0; i < devs.length; i++) {
            if (devs[i].type === UPowerDeviceType.Battery && devs[i].isLaptopBattery) {
                var bat = devs[i];
                var pct = Math.round(bat.percentage <= 1 ? bat.percentage * 100 : bat.percentage);
                var isCharging = bat.state === UPowerDeviceState.Charging || bat.state === UPowerDeviceState.FullyCharged;
                if (pct <= 15 && !isCharging && !_lowBatteryNotified) {
                    _lowBatteryNotified = true;
                    Qt.createQmlObject('import Quickshell.Io; Process { command: ["notify-send", "-u", "critical", "Low Battery", "Battery is at ' + pct + '%"]; running: true }', root);
                } else if (pct > 15 && _lowBatteryNotified) {
                    _lowBatteryNotified = false;
                }
                return bat;
            }
        }
        return null;
    }

    visible: root.hasBattery
    width: label.implicitWidth > 0 ? label.implicitWidth + 8 : 60
    height: 26

    Text {
        id: label

        anchors.centerIn: parent
        text: root.icon + " " + root.pct + "%"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 11
        color: root.pct <= 10 ? (root.theme.color1 || "#f38ba8") : root.pct <= 20 ? (root.theme.color3 || "#fab387") : root.isCharging ? (root.theme.accent || "#89b4fa") : (root.theme.fg || "#cdd6f4")
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: hoverArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: Qt.createQmlObject('import Quickshell.Io; Process { command: ["qs","ipc","call","customMenu","open","system"]; running: true }', root)
    }

    ToolTip {
        visible: hoverArea.containsMouse && root.hasBattery
        text: root.rate.toFixed(1) + "W  " + root.pct + "%"
        delay: 500
    }

}
