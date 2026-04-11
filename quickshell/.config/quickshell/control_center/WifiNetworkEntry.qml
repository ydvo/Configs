// WifiNetworkEntry.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".."

RowLayout {
    id: entry

    required property string ssid
    required property int signal
    required property string security
    required property bool active

    spacing: 8

    // signal strength icon
    Text {
        text: {
            if (entry.signal > 75)
                return "󰤨";
            if (entry.signal > 50)
                return "󰤥";
            if (entry.signal > 25)
                return "󰤢";
            return "󰤟";
        }
        color: entry.active ? Theme.success : Theme.fg
        font.pixelSize: 14
    }

    // SSID
    Text {
        text: entry.ssid || "(Hidden)"
        color: entry.active ? Theme.success : Theme.fg
        font.pixelSize: 14
        font.bold: entry.active
        Layout.fillWidth: true
        Layout.maximumWidth: 200
        elide: Text.ElideRight
    }

    // security icon
    Text {
        text: entry.security !== "--" && entry.security !== "" ? "󰌾" : ""
        color: Theme.muted
        font.pixelSize: 12
        visible: entry.security !== "--" && entry.security !== ""
    }

    // signal percentage
    Text {
        text: `${entry.signal}%`
        color: Theme.muted
        font.pixelSize: 12
        Layout.preferredWidth: 32
        horizontalAlignment: Text.AlignRight
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            entry.ssid !== "" ? parent.opacity = 0.8 : undefined;
        }
        onExited: {
            parent.opacity = 1.0;
        }

        onClicked: {
            if (entry.active) {
                disconnectProc.running = true;
            } else if (entry.ssid !== "") {
                connectProc.running = true;
            }
        }
    }

    Process {
        id: connectProc
        command: ["nmcli", "dev", "wifi", "connect", entry.ssid]
    }

    Process {
        id: disconnectProc
        command: ["nmcli", "dev", "disconnect"]
    }
}
