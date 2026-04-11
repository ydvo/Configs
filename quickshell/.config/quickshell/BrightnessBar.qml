// BrightnessBar.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Scope {
    id: root

    property real brightness: 0
    property bool shouldShowOsd: false

    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: root.shouldShowOsd = false
    }

    // Expose keybind call
    IpcHandler {
        target: "brightness"

        function set(percent: int): void {
            root.brightness = parseInt(percent) / 100;
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    // The OSD window will be created and destroyed based on shouldShowOsd.
    // Using a loader reduces memory overhead when the window isn't open.
    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            anchors.bottom: true
            margins.bottom: screen.height / 5
            exclusiveZone: 0

            implicitWidth: 250
            implicitHeight: 50
            color: "transparent"

            // An empty click mask prevents the window from blocking mouse events.
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                radius: height / 2
                color: "transparent"

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 10
                        rightMargin: 15
                    }

                    Text {
                        text: ""
                        font.pixelSize: 30
                        color: Theme.fg
                    }

                    Rectangle {
                        // Stretches to fill all left-over space
                        Layout.fillWidth: true

                        implicitHeight: 10
                        radius: 20
                        color: Theme.bg

                        Rectangle {
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                            }

                            implicitWidth: parent.width * root.brightness
                            radius: parent.radius
                            color: Theme.focus
                        }
                    }
                }
            }
        }
    }
}
