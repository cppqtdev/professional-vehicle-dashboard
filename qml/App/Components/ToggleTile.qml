// ToggleTile.qml
// A quick-setting pill (Cellular / Bluetooth / Notification / Hotspot) with a
// caption beneath it. Filled with its accent colour when checked.
//
//     ToggleTile {
//         text: "Cellular"
//         iconSource: Icons.cellular
//         accentColor: Theme.colors.accent
//         checked: controller.cellularOn
//         onToggled: controller.cellularOn = checked
//     }

import QtQuick
import App.Theme
import App.Components

Item {
    id: control

    property url iconSource
    property string text: ""
    property bool checked: false
    property color accentColor: Theme.colors.accent

    signal toggled(bool checked)

    implicitWidth: Theme.metrics.tileWidth
    implicitHeight: Theme.metrics.tileHeight + 42

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 13

        Surface {
            id: pill
            width: Theme.metrics.tileWidth
            height: Theme.metrics.tileHeight
            radius: height / 2          // full pill
            color: control.checked ? control.accentColor : Theme.colors.tile
            // Soft-UI: raised when off, reads "pushed in" when on/pressed
            neomorph: true
            pressed: control.checked || tileMouse.pressed
            scale: tileMouse.pressed ? 0.97 : 1.0

            AppIcon {
                anchors.centerIn: parent
                source: control.iconSource
                size: control.text === "Notification" || control.text === "Hotspot" ? 31 : 32
                color: control.checked ? Theme.colors.onaccent : Theme.colors.icon
            }

            Behavior on scale {
                NumberAnimation { duration: Theme.motion.fast; easing.type: Easing.OutCubic }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: control.text
            color: Theme.colors.textPrimary
            font.family: Theme.typography.family
            font.pixelSize: Theme.typography.label
            font.weight: Theme.typography.weightRegular
        }
    }

    MouseArea {
        id: tileMouse
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            control.checked = !control.checked
            control.toggled(control.checked)
        }
    }
}
