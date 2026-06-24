// NavTabButton.qml
// A themed, equal-width tab button. Active tab is bold/primary with an accent
// underline; inactive tabs are muted. Hover and press give visual feedback.

import QtQuick
import QtQuick.Controls.Basic as Basic
import App.Theme

Basic.TabButton {
    id: control

    property int tabWidth: 168

    implicitWidth: tabWidth
    implicitHeight: 52
    padding: 0

    contentItem: Item {
        id: body
        scale: control.down ? 0.95 : 1.0
        Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

        // hover / press background
        Rectangle {
            anchors.fill: parent
            radius: 14
            color: control.down ? Qt.rgba(0.5, 0.5, 0.6, 0.16)
                                 : (control.hovered ? Qt.rgba(0.5, 0.5, 0.6, 0.08) : "transparent")
            Behavior on color { ColorAnimation { duration: 120 } }
        }

        Text {
            id: label
            anchors.centerIn: parent
            text: control.text
            color: control.checked ? Theme.colors.textPrimary : Theme.colors.textSecondary
            font.family: Theme.typography.family
            font.pixelSize: 24
            font.weight: control.checked ? Theme.typography.weightBold
                                          : Theme.typography.weightRegular
            Behavior on color { ColorAnimation { duration: Theme.motion.fast } }
        }

        // accent underline on the active tab
        Rectangle {
            anchors.horizontalCenter: label.horizontalCenter
            anchors.top: label.bottom
            anchors.topMargin: 8
            width: label.implicitWidth + 6
            height: 3
            radius: 1.5
            color: Theme.colors.accent
            opacity: control.checked ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: Theme.motion.fast } }
        }
    }

    background: Item {}
}
