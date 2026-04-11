// Clock.qml
import Quickshell
import QtQuick
import QtQuick.Window
import ".."

Text {
    id: clock

    property color clockColor: Theme.fg
    property int clockFontSize: 48
    property string clockFontFamily: "Sans"
    property bool clockBold: true

    text: Time.time
    color: clockColor
    font.pointSize: clockFontSize
    font.family: clockFontFamily
    font.bold: clockBold
}
