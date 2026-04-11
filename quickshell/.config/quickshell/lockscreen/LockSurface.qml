import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Wayland
import ".."

Rectangle {
    id: root
    required property LockContext context
    readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive

    color: "black"

    // Bg image
    Image {
        anchors.fill: parent
        source: Theme.lockscreen_img
        fillMode: Image.PreserveAspectFit
    }

    Clock {
        anchors.top: parent.top
        anchors.right: parent.right

        anchors.topMargin: parent.height * 0.15
        anchors.rightMargin: parent.width * 0.12
    }

    ColumnLayout {
        // Uncommenting this will make the password entry invisible except on the active monitor.
        visible: Window.active

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            // verticalCenterOffset: -parent.height * 0.05
        }

        spacing: 12

        TextField {
            id: passwordBox

            implicitWidth: 250
            padding: 15

            color: Theme.fg

            // Make room for the icon
            rightPadding: 12
            leftPadding: 40
            topPadding: 12
            bottomPadding: 12

            background: Rectangle {
                color: "black"
                radius: 6
                border.color: Theme.focus
                border.width: 2
            }

            Text {
                text: "󱦚"

                color: root.context.showFailure ? Theme.alert : Theme.fg

                font.bold: true
                font.pixelSize: 24

                anchors {
                    left: parent.left
                    leftMargin: 12
                    verticalCenter: parent.verticalCenter
                }
            }

            focus: true
            enabled: !root.context.unlockInProgress
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData

            // Update the text in the context when the text in the box changes.
            onTextChanged: root.context.currentText = this.text

            // Try to unlock when enter is pressed.
            onAccepted: root.context.tryUnlock()

            // Update the text in the box to match the text in the context.
            // This makes sure multiple monitors have the same text.
            Connections {
                target: root.context

                function onCurrentTextChanged() {
                    passwordBox.text = root.context.currentText;
                }
            }
        }

        Label {
            opacity: root.context.showFailure ? 1 : 0
            text: "Incorrect password"
            color: Theme.alert
        }
    }
}
