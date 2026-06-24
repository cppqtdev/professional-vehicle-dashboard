import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import App.Theme

TabButton {
    id: control

    property url iconSource
    property color accentColor: Theme.colors.accent
    property int iconSize: 24
    property real radius: 0
    property real topleftradius: radius
    property real bottomleftradius: radius
    property real toprightradius: radius
    property real bottomrightradius: radius

    background: Surface {
        implicitWidth: 120
        implicitHeight: 64
        topleftradius: control.topleftradius
        bottomleftradius: control.bottomleftradius
        toprightradius: control.toprightradius
        bottomrightradius: control.bottomrightradius
        neomorph: true
        pressed: control.checked || control.pressed
        color: control.checked ? control.accentColor : Theme.colors.tile
        scale: control.pressed ? 0.96 : 1.0

        Behavior on scale {
            NumberAnimation { duration: Theme.motion.fast; easing.type: Easing.OutCubic }
        }
    }
}
