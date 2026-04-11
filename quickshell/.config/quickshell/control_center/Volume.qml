// Volume.qml
import Quickshell
import QtQuick
import QtQuick.Window
import ".."

Text {
    id: volume

    property bool popupOpen: false

    // style properties
    property color volumeColor: Theme.fg
    property int volumeFontSize: parent.iconsize
    property bool volumeBold: false

    text: "󰕾"
    color: volumeColor
    font.pointSize: volumeFontSize
    font.bold: volumeBold

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: parent.color = Theme.focus
        onExited: parent.color = Theme.fg
        onClicked: volume.popupOpen = !volume.popupOpen
    }
}
