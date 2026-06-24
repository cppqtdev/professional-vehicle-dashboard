// TransportButton.qml
// A flat, circular media button (previous / play-pause / next) with hover and
// press feedback. Used inside the now-playing card.

import QtQuick
import App.Theme
import App.Components

Item {
    id: btn

    property url iconSource
    property int size: 28
    property color color: Theme.colors.mediaText

    signal clicked()

    implicitWidth: 62
    implicitHeight: 62

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: mouse.pressed ? Qt.rgba(1, 1, 1, 0.14)
                             : (mouse.containsMouse ? Qt.rgba(1, 1, 1, 0.07) : "transparent")

        Behavior on color { ColorAnimation { duration: Theme.motion.fast } }
    }

    AppIcon {
        anchors.centerIn: parent
        source: btn.iconSource
        size: btn.size
        color: btn.color
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: btn.clicked()
    }
}
