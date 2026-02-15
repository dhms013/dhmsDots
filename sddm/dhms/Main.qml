import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    anchors.fill: parent
    color: "#000000"

    Column {
        anchors.centerIn: parent
        spacing: 120

        Image {
            id: logo
            source: "logo.png"
            fillMode: Image.PreserveAspectFit
            width: parent.parent.width * 0.25
            anchors.horizontalCenter: parent.horizontalCenter
        }

        TextField {
            id: passwordBox
            width: 450
            height: 70
            font.pixelSize: 36
            echoMode: TextInput.Password
            passwordCharacter: "•"
            color: "#59CF77"
            horizontalAlignment: TextInput.AlignHCenter
            placeholderText: "Enter password"
            placeholderTextColor: "#A0FFFFFF"
            background: Rectangle {
                color: "#00000000"
                border.color: "#59CF77"
                border.width: 5
                radius: 14
            }

            focus: true
            onAccepted: {
                sddm.login(userModel.lastUser, text, sessionModel.lastIndex)
            }
            Component.onCompleted: forceActiveFocus()
        }
    }
}
