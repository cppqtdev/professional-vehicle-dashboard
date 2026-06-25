// StatCard.qml
// A soft-UI metric card: an accent icon + value on top, caption beneath.

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import App.Theme
import App.Components

Control {
    id: card

    property url icon
    property string value: ""
    property string label: ""
    property color accent: Theme.colors.accent
    property int iconSize: 28

    padding: 18
    background: Surface {
        implicitWidth: 240
        implicitHeight: 136
        radius: Theme.metrics.cardRadius
        neomorph: true
        color: Theme.colors.tile
    }

    contentItem: ColumnLayout {
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            spacing: 18

            AppIcon {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                source: card.icon
                size: card.iconSize
                color: card.accent
            }

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                text: card.value
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: 24
                font.weight: Theme.typography.weightBold
            }
        }

        Text {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            elide: Text.ElideRight
            text: card.label
            color: Theme.colors.textSecondary
            font.family: Theme.typography.family
            font.pixelSize: 16
        }
    }
}
