// AppShell.qml
// Application frame: paints the canvas + floating panel, hosts the persistent
// SideRail, and swaps pages based on the rail selection.
//
// Rail mapping: car & nav -> Control page, music -> Media page.

import QtQuick
import QtQuick.Layouts
import App.Theme
import App.Components
import App.Controllers

Item {
    id: shell

    implicitWidth: 1180
    implicitHeight: 520

    // Shared application state
    SystemController { id: system }

    // Canvas
    Rectangle {
        anchors.fill: parent
        color: Theme.colors.background
        Behavior on color { ColorAnimation { duration: Theme.motion.normal } }
    }

    // Floating panel
    Surface {
        id: panel
        anchors.fill: parent
        anchors.margins: 22
        radius: Theme.metrics.panelRadius
        color: Theme.colors.surface
        elevated: true

        SideRail {
            id: rail
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            hours: "09"
            minutes: "35"
            currentIndex: system.navIndex
            onActivated: (index) => system.navIndex = index
        }

        StackLayout {
            anchors.left: rail.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            // rail: nav (0) -> Home, music (1) -> Media, car (2) -> Control
            currentIndex: system.navIndex

            HomePage { controller: system }
            MusicPage { controller: system }
            ControlPage { controller: system }
        }
    }
}
