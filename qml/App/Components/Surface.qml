// Surface.qml
// A rounded, themeable panel that can render in two elevation styles:
//
//   * neomorph (soft UI) — two soft shadows: a light highlight cast to the
//     top-left and a dark shadow cast to the bottom-right, so the surface looks
//     extruded from a same-coloured background. This is the default look.
//   * elevated — a single classic drop shadow (used by the floating main panel
//     which sits on a different-coloured canvas).
//
// MultiEffect (Qt 6.5+) renders one shadow per layer, so neumorphism is built
// from two same-shaped shadow casters stacked behind the body.
//
//     Surface {
//         radius: Theme.metrics.tileRadius
//         color: Theme.colors.tile
//         neomorph: true
//         AppIcon { anchors.centerIn: parent }   // children sit in the content area
//     }

import QtQuick
import QtQuick.Effects
import App.Theme

Item {
    id: root

    property color color: Theme.colors.surface
    property real radius: Theme.metrics.tileRadius

    // Soft-UI dual shadow
    property bool neomorph: false
    property real depth: Theme.metrics.neoDepth
    property real blur: Theme.metrics.neoBlur
    property bool pressed: false   // when true the surface reads "pushed in" (shadows recede)

    // Classic single drop shadow (mutually exclusive with neomorph)
    property bool elevated: false
    property color shadowColor: Theme.colors.shadow
    property real shadowBlur: 0.7
    property real shadowOffset: 8

    // children declared on a Surface go here, above the background
    default property alias content: contentItem.data

    property real _depth: pressed ? depth * 0.35 : depth

    // ---- Light highlight (top-left) ---------------------------------------
    // A soft top-left highlight reads as soft UI: bright white on a light
    // surface, and a very faint light-grey sheen on dark (just enough to lift,
    // never a white glow). Intensity is set per theme via shadowOpacity.
    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: root.color
        visible: root.neomorph
        layer.enabled: root.neomorph
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Theme.colors.shadowLight
            shadowOpacity: Theme.dark ? 0.12 : 0.85
            // very soft, diffuse sheen (not a crisp white edge)
            shadowHorizontalOffset: -root._depth * 0.6
            shadowVerticalOffset: -root._depth * 0.6
            shadowBlur: root.blur
            autoPaddingEnabled: true
        }
        Behavior on color { ColorAnimation { duration: Theme.motion.normal } }
    }

    // ---- Dark shadow (bottom-right) ---------------------------------------
    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: root.color
        visible: root.neomorph
        layer.enabled: root.neomorph
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Theme.colors.shadowDark
            shadowOpacity: Theme.dark ? 0.55 : 0.65
            // deeper, taller drop shadow for a stronger sense of elevation
            shadowHorizontalOffset: root._depth
            shadowVerticalOffset: root._depth * 1.5
            shadowBlur: root.blur
            autoPaddingEnabled: true
        }
        Behavior on color { ColorAnimation { duration: Theme.motion.normal } }
    }

    // ---- Body (covers the shadow casters' fills, leaving only their shadows)
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: root.radius
        color: root.color

        layer.enabled: root.elevated && !root.neomorph
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: root.shadowColor
            shadowBlur: root.shadowBlur
            shadowVerticalOffset: root.shadowOffset
            autoPaddingEnabled: true
        }

        Behavior on color {
            ColorAnimation { duration: Theme.motion.normal; easing.type: Easing.OutCubic }
        }
    }

    Behavior on _depth {
        NumberAnimation { duration: Theme.motion.fast; easing.type: Easing.OutCubic }
    }

    Item {
        id: contentItem
        anchors.fill: parent
    }
}
