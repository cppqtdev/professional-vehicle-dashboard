// AppIcon.qml
// A theme-aware, recolourable icon built on ColorImage (QtQuick.Controls.impl).
//
// ColorImage tints the source by its alpha channel, so the solid-black SVGs in
// icons/ are painted with `color` directly — white in dark mode, dark in light
// mode — without needing a MultiEffect pass.
//
//     import App.Components
//     import App.Icons
//     AppIcon { source: Icons.cellular; color: Theme.colors.accent; size: 28 }

import QtQuick
import QtQuick.Controls.impl
import App.Theme

ColorImage {
    id: root

    // Logical icon size; drives both the layout size and the crisp source size.
    property int size: Theme.metrics.iconSize

    // `color` is inherited from ColorImage; default it to the theme icon colour.
    color: Theme.colors.icon
    sourceSize: Qt.size(size, size) // crisp on HiDPI
    fillMode: Image.PreserveAspectFit
    mipmap: true
    smooth: true

    Behavior on color {
        ColorAnimation { duration: Theme.motion.fast; easing.type: Easing.OutCubic }
    }
}
