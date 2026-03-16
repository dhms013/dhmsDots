import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    anchors.fill: parent
    color: "#000000"

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.BlankCursor
        acceptedButtons: Qt.NoButton
        propagateComposedEvents: true
    }

    Image {
        anchors.fill: parent
        fillMode: Image.Stretch
        source: "1.png"
        asynchronous: true
        cache: false
        visible: status === Image.Ready
    }

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

            property bool loginFailed: false

            width: 500
            height: 100
            font.pixelSize: Math.round(height * 0.75)
            echoMode: TextInput.Password
            passwordCharacter: "•"
            horizontalAlignment: TextInput.AlignHCenter
            placeholderText: "Enter password"
            placeholderTextColor: "#A0FFFFFF"
            color: loginFailed ? "#FF4D4D" : "#59CF77"
            focus: true
            onAccepted: {
                loginFailed = true;
                sddm.login(userModel.lastUser, text, sessionModel.lastIndex);
            }
            Component.onCompleted: forceActiveFocus()

            Connections {
                function onLoginFailed() {
                    passwordBox.forceActiveFocus();
                    resetTimer.start();
                }

                target: sddm
            }

            Timer {
                id: resetTimer

                interval: 1000
                onTriggered: passwordBox.loginFailed = false
            }

            cursorDelegate: Item {
                visible: false
            }

            background: Rectangle {
                color: "#00000000"
                border.color: passwordBox.loginFailed ? "#FF4D4D" : "#59CF77"
                border.width: 5
                radius: 65
            }

        }

    }

}
