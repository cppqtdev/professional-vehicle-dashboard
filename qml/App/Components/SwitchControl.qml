// SwitchControl.qml
// A compact on/off switch with a sliding knob, themed and animated.

import QtQuick
import App.Theme

Item {
    id: sw

    property bool checked: false
    signal toggled(bool checked)

    implicitWidth: 60
    implicitHeight: 34

    Rectangle {
        id: track
        anchors.fill: parent
        radius: height / 2
        color: sw.checked ? Theme.colors.accent : Theme.colors.sliderTrack
        Behavior on color { ColorAnimation { duration: Theme.motion.fast } }

        Rectangle {
            width: parent.height - 8
            height: parent.height - 8
            radius: width / 2
            y: 4
            x: sw.checked ? parent.width - width - 4 : 4
            color: "#FFFFFF"
            Behavior on x {
                NumberAnimation { duration: Theme.motion.fast; easing.type: Easing.OutCubic }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            sw.checked = !sw.checked
            sw.toggled(sw.checked)
        }
    }
}
