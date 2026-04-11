// WifiPopup.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".."

Rectangle {
    id: popup

    color: "transparent"
    implicitWidth: 300
    implicitHeight: contentCol.implicitHeight + 32

    // network list parsed from nmcli
    property var networks: []
    // number of networks to display on popup
    property int numNetworks: 8

    ColumnLayout {
        id: contentCol
        anchors.right: parent.right
        spacing: 6

        Text {
            text: "Wi-Fi"
            color: Theme.fg
            font.pixelSize: 18
            font.bold: true
        }

        Rectangle {
            Layout.fillWidth: true
            color: Theme.muted
            implicitHeight: 1
        }

        // loading indicator when no networks yet
        Text {
            visible: popup.networks.length === 0
            text: "Scanning..."
            color: Theme.muted
            font.pixelSize: 14
        }

        Repeater {
            model: popup.networks

            WifiNetworkEntry {
                required property var modelData
                ssid: modelData.ssid
                signal: modelData.signal
                security: modelData.security
                active: modelData.active
            }
        }
    }

    // Fetch network list when popup becomes visible
    onVisibleChanged: {
        if (visible) {
            popup.networks = [];
            scanProc.running = true;
        }
    }

    // Scan and list available networks
    Process {
        id: scanProc
        command: ["sh", "-c", "nmcli dev wifi rescan 2>/dev/null; nmcli -t -f SSID,SIGNAL,SECURITY,ACTIVE dev wifi list 2>/dev/null"]

        property var pending: []

        stdout: SplitParser {
            onRead: data => {
                let parts = data.split(":");
                if (parts.length >= 4 && parts[0] !== "") {
                    scanProc.pending.push({
                        ssid: parts[0],
                        signal: parseInt(parts[1]) || 0,
                        security: parts[2],
                        active: parts[3] === "yes"
                    });
                }
            }
        }

        onRunningChanged: {
            if (running) {
                scanProc.pending = [];
            }
        }

        onExited: (code, status) => {
            const map = {};

            for (let net of scanProc.pending) {
                if (!map[net.ssid]) {
                    map[net.ssid] = net;
                } else {
                    // Prefer active network
                    if (net.active) {
                        map[net.ssid] = net;
                    } else
                    // Otherwise keep the stronger signal
                    if (!map[net.ssid].active && net.signal > map[net.ssid].signal) {
                        map[net.ssid] = net;
                    }
                }
            }

            // Convert back to array
            let deduped = Object.values(map);

            // sort: active first, then by signal strength descending
            deduped.sort((a, b) => {
                if (a.active !== b.active)
                    return a.active ? -1 : 1;
                return b.signal - a.signal;
            });
            popup.networks = deduped.slice(0, popup.numNetworks);
        }
    }
}
