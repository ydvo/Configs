// Wifi.qml
import Quickshell
import Quickshell.Io
import QtQuick
import ".."

Text {
    id: wifi

    property bool popupOpen: false

    // style
    property color wifiColor: Theme.fg
    property int wifiFontSize: parent.iconsize
    property bool wifiBold: false

    // status (updated by nmcli)
    property bool connected: false
    property string ssid: ""
    property int signal: 0

    text: {
        if (!connected)
            return "󰤯";
        if (signal > 75)
            return "󰤨";
        if (signal > 50)
            return "󰤥";
        if (signal > 25)
            return "󰤢";
        return "󰤟";
    }
    color: connected ? wifiColor : Theme.alert
    font.pointSize: wifiFontSize
    font.bold: wifiBold

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: parent.color = Theme.focus
        onExited: parent.color = wifi.connected ? wifi.wifiColor : Theme.alert
        onClicked: wifi.popupOpen = !wifi.popupOpen
    }

    // Event-driven: nmcli monitor triggers status refresh on state changes
    Process {
        id: monitorProc
        command: ["nmcli", "monitor"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                statusProc.running = true;
            }
        }

        // restart if it dies
        onRunningChanged: {
            if (!running)
                monitorProc.running = true;
        }
    }

    // On-demand status fetch: get currently connected network (triggered by monitor events + startup)
    Process {
        id: statusProc
        command: ["sh", "-c", "nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi list 2>/dev/null | grep '^yes'"]

        stdout: SplitParser {
            onRead: data => {
                let parts = data.split(":");
                if (parts.length >= 3) {
                    wifi.connected = true;
                    wifi.ssid = parts[1];
                    wifi.signal = parseInt(parts[2]) || 0;
                }
            }
        }

        onExited: (code, status) => {
            // grep found no match = not connected
            if (code !== 0) {
                wifi.connected = false;
                wifi.ssid = "";
                wifi.signal = 0;
            }
        }
    }

    // Fetch status on startup
    Component.onCompleted: statusProc.running = true

    // Slow poll for signal strength drift (every 30s)
    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: statusProc.running = true
    }
}
