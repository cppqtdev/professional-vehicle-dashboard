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
    property bool hasAlerts: true
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

    // Direct screen shortcuts
    ListView {
        id: nav
        anchors.top: clock.bottom
        anchors.bottom: menuCell.top
        anchors.topMargin: 34
        anchors.bottomMargin: 28
        anchors.horizontalCenter: parent.horizontalCenter
        width: 50
        clip: true
        spacing: 18
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick

        model: [
            { "icon": Icons.nav, "target": 0 },
            { "icon": Icons.music, "target": 1 },
            { "icon": Icons.car, "target": 2 },
            { "icon": Icons.cellular, "target": 4 },
            { "icon": Icons.road, "target": 5 },
            { "icon": Icons.fan, "target": 7 },
            { "icon": Icons.notification, "target": 9 },
            { "icon": Icons.moon, "target": 13 }
        ]

        delegate: Item {
            id: cell
            required property int index
            required property var modelData
            width: nav.width
            height: 42
            scale: navMouse.pressed ? 0.92 : 1.0

            Surface {
                anchors.centerIn: parent
                width: 42
                height: 42
                radius: width / 2
                color: "#242429"
                elevated: true
                shadowColor: Qt.rgba(0, 0, 0, 0.7)
                shadowBlur: 0.8
                shadowOffset: 5
                opacity: rail.currentIndex === cell.modelData.target ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: Theme.motion.fast } }
            }

            AppIcon {
                anchors.centerIn: parent
                source: cell.modelData.icon
                size: 23
                color: rail.currentIndex === cell.modelData.target
                       ? "#FFFFFF" : Theme.colors.iconMuted
            }
            MouseArea {
                id: navMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    rail.currentIndex = cell.modelData.target
                    rail.activated(cell.modelData.target)
                }
            }

            Behavior on scale {
                NumberAnimation { duration: Theme.motion.fast; easing.type: Easing.OutCubic }
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

        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            width: 7
            height: 7
            radius: 3.5
            color: Theme.colors.danger
            visible: rail.hasAlerts
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
