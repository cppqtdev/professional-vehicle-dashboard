// Theme.qml
// Application design-token singleton.
//
// Registered from C++ via qmlRegisterSingletonType() under the URI "App.Theme"
// (see main.cpp). A QML file used as a singleton must declare `pragma Singleton`
// itself; the C++ call supplies the module URI/name (no qmldir entry needed).
//
// Usage from any QML file:
//     import App.Theme
//     color: Theme.colors.surface
//     font.pixelSize: Theme.typography.title
//
// Switching the whole UI between light and dark is a single property write:
//     Theme.dark = false      // or Theme.toggle()
// Every color binding flows from `colors`, so the entire tree re-themes live.

pragma Singleton

import QtQuick

QtObject {
    id: theme

    // ---- Mode -------------------------------------------------------------
    property bool dark: true
    function toggle() { dark = !dark }

    // Active semantic palette. Re-evaluates when `dark` changes, which
    // propagates to every binding that reads Theme.colors.*
    readonly property QtObject colors: dark ? _dark : _light

    // ---- Dark palette -----------------------------------------------------
    readonly property QtObject _dark: QtObject {
        readonly property color background:     "#DBDBEA" // app canvas behind the panel
        readonly property color surface:        "#24252C" // main control panel
        readonly property color surfaceVariant: "#30313A"
        readonly property color tile:           "#24252C" // == surface (neumorphic base)
        readonly property color railBackground: "#0B0B0D" // left navigation rail
        readonly property color textPrimary:    "#FFFFFF"
        readonly property color textSecondary:  "#B8B8C3"
        readonly property color icon:           "#FFFFFF"
        readonly property color iconMuted:      "#8A8A95"
        readonly property color sliderTrack:    "#3A3B45" // inactive slider / recessed groove
        readonly property color handle:         "#2B2B31"
        readonly property color divider:        "#3A3A41"
        readonly property color shadow:         Qt.rgba(0, 0, 0, 0.55)
        // Neumorphism: dark shadow (bottom-right) + light highlight (top-left)
        // opaque colors; intensity is controlled via MultiEffect.shadowOpacity
        readonly property color shadowDark:     "#000000"
        readonly property color shadowLight:    "#9A9AA6" // faint light-grey top-left sheen

        // Accents — shared identity across modes
        readonly property color accent:         "#5B5CF0" // cellular / brightness
        readonly property color danger:         "#E5503A" // notifications (muted)
        readonly property color success:        "#46E08A" // volume fill
        readonly property color onaccent:       "#FFFFFF"

        // Now-playing card stays dark in both modes (album surface)
        readonly property color mediaBackground: "#0E1422"
        readonly property color mediaGlow:       "#1E3E74"
        readonly property color mediaText:       "#FFFFFF"
        readonly property color mediaSecondary:  "#9FA8BC"
        readonly property color mediaTrack:      "#2A3550"
    }

    // ---- Light palette ----------------------------------------------------
    readonly property QtObject _light: QtObject {
        readonly property color background:     "#DBDBEA"
        readonly property color surface:        "#ECECF5"
        readonly property color surfaceVariant: "#F4F4FB"
        readonly property color tile:           "#ECECF5" // == surface (neumorphic base)
        readonly property color railBackground: "#0B0B0D"
        readonly property color textPrimary:    "#1B1B24"
        readonly property color textSecondary:  "#6C6C7A"
        readonly property color icon:           "#1B1B24"
        readonly property color iconMuted:      "#9A9AA6"
        readonly property color sliderTrack:    "#DEDEEB" // recessed groove
        readonly property color handle:         "#ECECF5"
        readonly property color divider:        "#DEDEEA"
        readonly property color shadow:         Qt.rgba(0.42, 0.42, 0.58, 0.45)
        // Neumorphism: dark shadow (bottom-right) + light highlight (top-left)
        // opaque colors; intensity is controlled via MultiEffect.shadowOpacity
        readonly property color shadowDark:     "#9FA0BC"
        readonly property color shadowLight:    "#FFFFFF"

        readonly property color accent:         "#5B5CF0"
        readonly property color danger:         "#E5503A"
        readonly property color success:        "#46E08A"
        readonly property color onaccent:       "#FFFFFF"

        readonly property color mediaBackground: "#0E1422"
        readonly property color mediaGlow:       "#1E3E74"
        readonly property color mediaText:       "#FFFFFF"
        readonly property color mediaSecondary:  "#9FA8BC"
        readonly property color mediaTrack:      "#2A3550"
    }

    // ---- Typography -------------------------------------------------------
    readonly property QtObject typography: QtObject {
        readonly property string family: Qt.application.font.family
        readonly property int displayTime: 30  // rail clock
        readonly property int title:       30  // page titles / now-playing track
        readonly property int subtitle:    18
        readonly property int status:      19  // status bar
        readonly property int label:       16  // toggle captions
        readonly property int caption:     14
        readonly property int weightBold:    700
        readonly property int weightMedium:  500
        readonly property int weightRegular: 400
    }

    // ---- Metrics / spacing ------------------------------------------------
    readonly property QtObject metrics: QtObject {
        readonly property int panelRadius: 28
        readonly property int tileRadius:  32
        readonly property int cardRadius:  22
        readonly property int tileWidth:   116
        readonly property int tileHeight:  74
        readonly property int iconSize:    26
        readonly property int railWidth:   72
        readonly property int sliderHeight: 46
        readonly property int sliderHandle: 56
        readonly property int spacing:     22
        readonly property int paddingLg:   28
        readonly property int paddingMd:   18
        // Neumorphism: shadow offset distance and softness
        readonly property real neoDepth:   5
        readonly property real neoBlur:    0.85
    }

    // ---- Motion -----------------------------------------------------------
    readonly property QtObject motion: QtObject {
        readonly property int fast:   140
        readonly property int normal: 200
        readonly property int slow:   320
    }
}
