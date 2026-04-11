import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire
import ".."

ColumnLayout {
    required property PwNode node

    // bind the node so we can read its properties
    PwObjectTracker {
        objects: [node]
    }

    spacing: 1

    RowLayout {
        Text {
            text: "󰗅"
            color: Theme.fg
        }

        Label {
            text: {
                // application.name -> description -> name
                const app = node.properties["application.name"] ?? (node.description != "" ? node.description : node.name);
                const media = node.properties["media.name"];
                return media != undefined ? `${app} - ${media}` : app;
            }
            font.pixelSize: 14
            color: Theme.fg
            Layout.fillWidth: true
            Layout.maximumWidth: 300
            elide: Text.ElideRight
        }

        ToolButton {
            implicitWidth: 15
            text: node.audio.muted ? "" : ""
            onClicked: node.audio.muted = !node.audio.muted

            // button style
            padding: 0
            font.pixelSize: 14

            background: Rectangle {
                color: "transparent"
            }
            contentItem: Text {
                text: parent.text
                color: node.audio.muted ? Theme.alert : Theme.fg
            }
        }
    }

    RowLayout {
        Label {
            Layout.preferredWidth: 40
            text: `${Math.floor(node.audio.volume * 100)}%`
            font.pixelSize: 14
            color: Theme.fg
        }

        Slider {
            id: slider
            Layout.fillWidth: true
            value: node.audio.volume
            onValueChanged: node.audio.volume = value

            background: Rectangle {
                color: Theme.bg
                radius: 2
                implicitHeight: 6

                // fill
                Rectangle {
                    anchors.left: parent.left
                    implicitHeight: parent.height
                    radius: 2
                    width: slider.value * parent.width
                    color: Theme.focus
                }
            }
            handle: Rectangle {}
        }
    }
}
