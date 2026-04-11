// Battery.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Window
import ".."

Text {
    id: battery

    // exposed properties
    // style
    property color batteryColor: Theme.fg
    property int batteryFontSize: parent.iconsize
    property bool batteryBold: false

    // status
    property int percentage: 100
    property string status: ""
    property bool charging: status === "Charging"

    property bool popupOpen: false

    // main component
    text: {
        let icon = charging ? "󰂄" : percentage > 75 ? "󰁹" : percentage > 50 ? "󰁾" : percentage > 30 ? "󰁼" : "󰁺";
        return `${icon}`;
    }
    color: {
        return charging ? Theme.success : percentage < 30 ? Theme.alert : Theme.fg;
    }

    font.pointSize: batteryFontSize
    font.bold: batteryBold

    // change color on hover
    // spawn detailed window on click
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: parent.color = Theme.focus
        onExited: parent.color = battery.charging ? Theme.success : battery.percentage < 30 ? Theme.alert : Theme.fg

        onClicked: battery.popupOpen = !battery.popupOpen
    }

    /* Updating */
    Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: batteryProc.running = true
    }

    // check system files for power info
    Process {
        id: batteryProc
        command: ["sh", "-c", "echo $(cat /sys/class/power_supply/BAT0/capacity);" + "echo $(cat /sys/class/power_supply/BAT0/status);"]

        stdout: SplitParser {
            property int lineNum: 0
            onRead: data => {
                switch (lineNum) {
                case 0:
                    percentage = parseInt(data) || 0;
                    break;
                case 1:
                    status = data.trim();
                    break;
                }
                lineNum++;
            }
        }
        onRunningChanged: {
            if (running)
                stdout.lineNum = 0;
        }
    }
}
