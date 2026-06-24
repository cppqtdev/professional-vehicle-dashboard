// StatusBar.qml
// Top strip of the panel: signal + network on the left, clock in the centre,
// date and a theme toggle on the right.

import QtQuick
import App.Theme
import App.Components
import App.Icons

Item {
    id: bar

    property string network: "4G"
    property string time: "09:35"
    property string date: "Saturday | Jun 29"

    implicitHeight: 40

    // Left: signal strength + network label
    Row {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        AppIcon {
            anchors.verticalCenter: parent.verticalCenter
            source: Icons.signalBars
            size: 20
            color: Theme.colors.textPrimary
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: bar.network
            color: Theme.colors.textPrimary
            font.family: Theme.typography.family
            font.pixelSize: Theme.typography.status
            font.weight: Theme.typography.weightMedium
        }
    }

    // Centre: time
    Text {
        anchors.centerIn: parent
        text: bar.time
        color: Theme.colors.textPrimary
        font.family: Theme.typography.family
        font.pixelSize: Theme.typography.status
        font.weight: Theme.typography.weightMedium
    }

    // Right: date + theme toggle
    Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 16

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: bar.date
            color: Theme.colors.textPrimary
            font.family: Theme.typography.family
            font.pixelSize: Theme.typography.status
            font.weight: Theme.typography.weightMedium
        }
    }
}
