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
    // index of the active destination (0..2 over the three nav icons)
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
        anchors.topMargin: 26
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: -4

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: rail.hours
            color: "#FFFFFF"
            font.family: Theme.typography.family
            font.pixelSize: Theme.typography.displayTime
            font.weight: Theme.typography.weightMedium
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: rail.minutes
            color: "#FFFFFF"
            font.family: Theme.typography.family
            font.pixelSize: Theme.typography.displayTime
            font.weight: Theme.typography.weightMedium
        }
    }

    // Destinations
    Column {
        id: nav
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 18
        spacing: 34

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
                width: 44
                height: 44

                AppIcon {
                    anchors.centerIn: parent
                    source: cell.modelData.icon
                    size: 26
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
    AppIcon {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 26
        anchors.horizontalCenter: parent.horizontalCenter
        source: Icons.menu
        size: 26
        color: "#FFFFFF"
    }
}
