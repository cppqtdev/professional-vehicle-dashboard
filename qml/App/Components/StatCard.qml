// StatCard.qml
// A soft-UI metric card: an accent icon + value on top, caption beneath.

import QtQuick
import App.Theme
import App.Components

Surface {
    id: card

    property url icon
    property string value: ""
    property string label: ""
    property color accent: Theme.colors.accent

    radius: Theme.metrics.cardRadius
    neomorph: true
    color: Theme.colors.tile
    implicitWidth: 240
    implicitHeight: 136

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 28
        anchors.rightMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12

        Row {
            spacing: 16
            AppIcon {
                anchors.verticalCenter: parent.verticalCenter
                source: card.icon
                size: 24
                color: card.accent
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: card.value
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: 31
                font.weight: Theme.typography.weightBold
            }
        }
        Text {
            width: parent.width
            elide: Text.ElideRight
            text: card.label
            color: Theme.colors.textSecondary
            font.family: Theme.typography.family
            font.pixelSize: 17
        }
    }
}
