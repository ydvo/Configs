import Quickshell
import QtQuick
import QtQuick.Window
import ".."

Text {
    id: date

    property color dateColor: Theme.fg
    property int dateFontSize: parent.iconsize
    property string dateFontFamily: "Sans"
    property bool dateBold: false

    text: Time.date
    color: dateColor
    font.pointSize: dateFontSize
    font.family: dateFontFamily
    font.bold: dateBold

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: parent.color = Theme.focus
        onExited: parent.color = Theme.fg
    }
}
