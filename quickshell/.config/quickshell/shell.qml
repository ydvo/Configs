// Shell.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Window
import Quickshell.Wayland

// modules
import "control_center" as ControlCenter
import "lockscreen" as Lockscreen

ShellRoot {
    // Lockscreen
    Lockscreen.LockContext {
        id: lockContext

        onUnlocked: {
            sessionLock.locked = false;
        }
    }

    WlSessionLock {
        id: sessionLock

        locked: false

        WlSessionLockSurface {
            Lockscreen.LockSurface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }

    // Expose commands for Keybinds
    IpcHandler {
        target: "lockscreen"

        function lock(): void {
            sessionLock.locked = true;
        }
    }

    // Volume
    VolumeBar {}

    // Brightness
    BrightnessBar {}

    // Per-screen panel
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window

            property var modelData
            screen: modelData

            // set fullscreen
            implicitWidth: Screen.width
            implicitHeight: Screen.height

            color: "transparent"

            // make bg layer
            WlrLayershell.layer: WlrLayer.Background

            // Dismiss popups
            MouseArea {
                anchors.fill: parent
                visible: battery.popupOpen || volume.popupOpen || wifi.popupOpen
                onClicked: {
                    battery.popupOpen = false;
                    volume.popupOpen = false;
                    wifi.popupOpen = false;
                }
            }

            // Control Center
            Column {
                anchors.top: parent.top
                anchors.right: parent.right

                anchors.topMargin: parent.height * 0.15
                anchors.rightMargin: parent.width * 0.12

                // blend into bg a bit more
                opacity: 0.9

                spacing: 8
                Clock {
                    // clockFontFamily: "Digital Dreamer"
                    anchors.right: parent.right
                }

                Row {
                    spacing: 16
                    anchors.right: parent.right

                    property int iconsize: 16

                    ControlCenter.Battery {
                        id: battery
                    }
                    ControlCenter.Volume {
                        id: volume
                    }
                    ControlCenter.Wifi {
                        id: wifi
                    }
                    ControlCenter.Date {}
                }

                ControlCenter.BatteryPopup {
                    id: batteryPopup
                    visible: battery.popupOpen

                    anchors.right: parent.right

                    percentage: battery.percentage
                    status: battery.status
                    charging: battery.charging
                    onVisibleChanged: {
                        if (visible) {
                            window.closeAllPopups(battery);
                        } else {
                            battery.popupOpen = false;
                        }
                    }
                }

                ControlCenter.VolumePopup {
                    id: volumePopup
                    visible: volume.popupOpen

                    anchors.right: parent.right

                    onVisibleChanged: {
                        if (visible) {
                            window.closeAllPopups(volume);
                        } else {
                            volume.popupOpen = false;
                        }
                    }
                }

                ControlCenter.WifiPopup {
                    id: wifiPopup
                    visible: wifi.popupOpen

                    anchors.right: parent.right

                    onVisibleChanged: {
                        if (visible) {
                            window.closeAllPopups(wifi);
                        } else {
                            wifi.popupOpen = false;
                        }
                    }
                }
            }

            function closeAllPopups(except) {
                if (except !== battery)
                    battery.popupOpen = false;
                if (except !== volume)
                    volume.popupOpen = false;
                if (except !== wifi)
                    wifi.popupOpen = false;
            }
        }
    }
}
