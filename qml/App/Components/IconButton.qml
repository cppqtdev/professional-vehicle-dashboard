// IconButton.qml
// A circular soft-UI button with a centred icon. Optionally checkable, filling
// with an accent colour and reading "pressed in" when on.
//
//     IconButton {
//         iconSource: Icons.lock
//         accentColor: Theme.colors.accent
//         checked: controller.centralLock
//         onToggled: controller.centralLock = checked
//     }

import QtQuick
import App.Theme
import App.Components

Item {
    id: control

    property url iconSource
    property bool checkable: true
    property bool checked: false
    property color accentColor: Theme.colors.accent
    property int diameter: 70
    property int iconSize: Math.round(diameter * 0.40)

    signal toggled(bool checked)
    signal clicked()

    implicitWidth: Math.max(76, diameter)
    implicitHeight: Math.max(76, diameter)

    Surface {
        width: control.diameter
        height: control.diameter
        anchors.centerIn: parent
        radius: width / 2
        neomorph: true
        pressed: control.checked || mouse.pressed
        color: control.checked ? control.accentColor : Theme.colors.tile
        scale: mouse.pressed ? 0.96 : 1.0

        AppIcon {
            anchors.centerIn: parent
            source: control.iconSource
            size: control.iconSize
            color: control.checked ? Theme.colors.onaccent : Theme.colors.icon
        }

        Behavior on scale {
            NumberAnimation { duration: Theme.motion.fast; easing.type: Easing.OutCubic }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (control.checkable) {
                control.checked = !control.checked
                control.toggled(control.checked)
            }
            control.clicked()
        }
    }
}
