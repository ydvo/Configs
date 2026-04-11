import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."

Rectangle {
    id: popup

    required property int percentage
    required property string status
    required property bool charging

    color: "transparent"
    implicitWidth: 250
    implicitHeight: 100

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 6

        Text {
            text: "Battery"
            color: Theme.fg
            font.pixelSize: 18
            font.bold: true
        }

        // Charge bar
        Rectangle {
            width: parent.width
            height: 6
            radius: 5
            color: Theme.bg

            Rectangle {
                width: parent.width * (percentage / 100)
                height: parent.height
                radius: 5
                color: percentage < 30 ? Theme.alert : percentage < 80 ? Theme.muted : Theme.success

                Behavior on width {
                    SmoothedAnimation {
                        duration: 300
                    }
                }
            }
        }

        Text {
            text: `${percentage}% — ${status}`
            color: Theme.fg
            font.pixelSize: 14
        }
    }
}
