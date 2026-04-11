// Theme.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: theme

    /* Colors */
    // main
    readonly property color bg: "#131313"
    readonly property color fg: "#e2e2e2"

    // highlights
    readonly property color focus: "#fdbb4a" // warm yellow
    readonly property color alert: "#ffb4ab" // soft red
    readonly property color success: "#b6cea3" // muted green

    // misc
    readonly property color muted: "#dcc3a1" // beige

    /* Lockscreen Image */
    readonly property string lockscreen_img: "/home/ydvo/Pictures/Wallpapers/sleepytsap1-ascii-art.png"
}
