import QtQuick
import QtQuick.Window
import App.Theme
import App.Screens

Window {
    id: window
    width: 1180
    height: 520
    minimumWidth: 900
    minimumHeight: 430
    visible: true
    color: Theme.colors.background
    title: qsTr("Smart UI — Infotainment")

    Behavior on color { ColorAnimation { duration: Theme.motion.normal } }

    AppShell {
        anchors.fill: parent
    }
}
