// NavTabButton.qml
// A themed, equal-width tab button. Active tab is bold/primary with an accent
// underline; inactive tabs are muted. Hover and press give visual feedback.

import QtQuick
import QtQuick.Controls.Basic as Basic
import App.Theme

Basic.TabButton {
    id: control
    property int tabWidth: parent && parent.buttonWidth ? parent.buttonWidth : 184

    contentItem: Item {
        id: body
        scale: control.down ? 0.95 : 1.0
        Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

        Text {
            id: label
            anchors.centerIn: parent
            text: control.text
            color: control.checked || control.hovered
                   ? Theme.colors.textPrimary
                   : Theme.colors.textSecondary
            font.family: Theme.typography.family
            font.pixelSize: 18
            font.weight: control.checked ? Theme.typography.weightBold
                                          : Theme.typography.weightRegular
            Behavior on color { ColorAnimation { duration: Theme.motion.fast } }
        }

        // accent underline on the active tab
        Rectangle {
            anchors.horizontalCenter: label.horizontalCenter
            anchors.top: label.bottom
            anchors.topMargin: 8
            width: Math.max(86, label.implicitWidth + 8)
            height: 3
            radius: 1.5
            color: Theme.colors.accent
            opacity: control.checked ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: Theme.motion.fast } }
        }
    }

    background: Item {
        implicitWidth: tabWidth
        implicitHeight: 32
    }
}
