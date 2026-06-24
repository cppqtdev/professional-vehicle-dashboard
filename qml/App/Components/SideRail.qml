// SideRail.qml
// The left navigation rail: a stacked clock at the top and a column of
// destination icons. Stays dark in both themes. Rounds only its left corners so
// it tucks neatly into the rounded main panel (Qt 6.7+ per-corner radius).

import QtQuick
import App.Theme
import App.Components
import App.Icons

Rectangle {
    id: rail

    property string hours: "09"
    property string minutes: "35"
    // index of the active destination (0..2 over the three nav icons, 3 menu)
    property int currentIndex: 0
    signal activated(int index)

    width: Theme.metrics.railWidth
    color: Theme.colors.railBackground
    topLeftRadius: Theme.metrics.panelRadius
    bottomLeftRadius: Theme.metrics.panelRadius

    // Clock
    Column {
        id: clock
        anchors.top: parent.top
        anchors.topMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: -4

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: rail.hours
            color: "#FFFFFF"
            font.family: Theme.typography.family
            font.pixelSize: 22
            font.weight: Theme.typography.weightMedium
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: rail.minutes
            color: "#FFFFFF"
            font.family: Theme.typography.family
            font.pixelSize: 22
            font.weight: Theme.typography.weightMedium
        }
    }

    // Destinations
    Column {
        id: nav
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 10
        spacing: 46

        Repeater {
            model: [
                { "icon": Icons.nav },
                { "icon": Icons.music },
                { "icon": Icons.car }
            ]
            delegate: Item {
                id: cell
                required property int index
                required property var modelData
                width: 40
                height: 40

                AppIcon {
                    anchors.centerIn: parent
                    source: cell.modelData.icon
                    size: 24
                    color: rail.currentIndex === cell.index
                           ? "#FFFFFF" : Theme.colors.iconMuted
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        rail.currentIndex = cell.index
                        rail.activated(cell.index)
                    }
                }
            }
        }
    }

    // Menu pinned to the bottom
    Item {
        id: menuCell
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 26
        anchors.horizontalCenter: parent.horizontalCenter
        width: 40
        height: 40
        scale: menuMouse.pressed ? 0.92 : 1.0

        AppIcon {
            anchors.centerIn: parent
            source: Icons.menu
            size: 24
            color: rail.currentIndex === 3 ? "#FFFFFF" : Theme.colors.iconMuted
        }

        MouseArea {
            id: menuMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                rail.currentIndex = 3
                rail.activated(3)
            }
        }

        Behavior on scale {
            NumberAnimation { duration: Theme.motion.fast; easing.type: Easing.OutCubic }
        }
    }
}
