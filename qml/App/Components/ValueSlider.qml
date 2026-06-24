// ValueSlider.qml
// A fully restyled slider: a tall rounded track, an accent fill, and a circular
// handle carrying an icon (speaker for volume, sun for brightness).
//
//     ValueSlider {
//         value: controller.volume
//         fillColor: Theme.colors.success
//         handleIcon: Icons.volume
//         onMoved: controller.volume = value
//     }

import QtQuick
import QtQuick.Controls.Basic as Basic
import App.Theme
import App.Components

Basic.Slider {
    id: control

    property color fillColor: Theme.colors.accent
    property url handleIcon

    from: 0
    to: 1
    value: 0.5
    implicitWidth: 420
    implicitHeight: Theme.metrics.sliderHandle
    padding: 0

    background: Item {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        width: control.availableWidth
        height: Theme.metrics.sliderHeight

        Surface {
            anchors.fill: parent
            radius: height / 2
            color: Theme.colors.sliderTrack
            neomorph: true
            depth: 3
            blur: 0.72
        }

        Rectangle {
            id: inactiveRail
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: parent.height / 2 - height / 2
            anchors.rightMargin: parent.height / 2 - height / 2
            anchors.verticalCenter: parent.verticalCenter
            height: 3
            radius: height / 2
            color: Theme.dark ? Qt.rgba(1, 1, 1, 0.16) : Qt.rgba(0.56, 0.56, 0.68, 0.24)
        }

        // Thin progress fill running through the centre of the groove,
        // ending under the handle.
        Rectangle {
            height: 7
            radius: height / 2
            anchors.left: parent.left
            anchors.leftMargin: parent.height / 2 - height / 2
            anchors.verticalCenter: parent.verticalCenter
            width: Math.max(0, control.visualPosition
                   * (parent.width - parent.height) + height)
            color: control.fillColor
        }
    }

    handle: Surface {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        width: Theme.metrics.sliderHandle
        height: Theme.metrics.sliderHandle
        radius: width / 2
        color: Theme.colors.handle
        neomorph: true
        pressed: control.pressed
        scale: control.pressed ? 1.06 : 1.0

        AppIcon {
            anchors.centerIn: parent
            source: control.handleIcon
            size: 22
            color: Theme.colors.icon
        }

        Behavior on scale {
            NumberAnimation { duration: Theme.motion.fast; easing.type: Easing.OutCubic }
        }
    }
}
