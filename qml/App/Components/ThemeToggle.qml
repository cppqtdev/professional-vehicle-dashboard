// ThemeToggle.qml
// A small pill that flips the global Theme between dark and light.
// Demonstrates that a single Theme.toggle() re-themes the whole tree.

import QtQuick
import App.Theme
import App.Components
import App.Icons

Surface {
    id: toggle

    implicitWidth: 56
    implicitHeight: 36
    width: implicitWidth
    height: implicitHeight
    radius: height / 2
    color: Theme.colors.tile
    neomorph: true
    pressed: toggleMouse.pressed

    AppIcon {
        anchors.centerIn: parent
        source: Theme.dark ? Icons.moon : Icons.sun
        size: 20
        color: Theme.colors.icon
    }

    MouseArea {
        id: toggleMouse
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Theme.toggle()
    }
}
