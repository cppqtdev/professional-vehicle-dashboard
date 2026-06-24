// Icons.qml
// Central registry of icon resource paths.
//
// Registered from C++ via qmlRegisterSingletonType() under the URI "App.Icons".
// Centralising the paths means a rename/relocation of the icons/ folder is a
// one-line change here instead of a project-wide find/replace.
//
// Usage:
//     import App.Icons
//     AppIcon { source: Icons.cellular }

pragma Singleton

import QtQuick

QtObject {
    readonly property string base: "qrc:/icons/"

    // status bar
    readonly property url signalBars: base + "signal.svg"

    // quick-setting toggles
    readonly property url cellular:   base + "cellular.svg"
    readonly property url bluetooth:  base + "bluetooth.svg"
    readonly property url notification: base + "bell-off.svg"
    readonly property url hotspot:    base + "hotspot.svg"

    // sliders
    readonly property url volume:     base + "volume.svg"
    readonly property url brightness: base + "brightness.svg"

    // media transport
    readonly property url previous:   base + "prev.svg"
    readonly property url play:       base + "play.svg"
    readonly property url pause:      base + "pause.svg"
    readonly property url next:       base + "next.svg"

    // navigation rail
    readonly property url nav:        base + "nav.svg"
    readonly property url music:      base + "music.svg"
    readonly property url car:        base + "car.svg"
    readonly property url menu:       base + "menu.svg"

    // theme toggle
    readonly property url sun:        base + "brightness.svg"
    readonly property url moon:       base + "moon.svg"

    // control page
    readonly property url lock:       base + "lock.svg"
    readonly property url fuel:       base + "fuel.svg"
    readonly property url trunk:      base + "trunk.svg"
    readonly property url steering:   base + "steering.svg"
    readonly property url seat:       base + "seat.svg"
    readonly property url fan:        base + "fan.svg"
    readonly property url defrost:    base + "defrost.svg"
    readonly property url infinity:   base + "infinity.svg"
    readonly property url bulb:       base + "bulb.svg"
    readonly property url warning:    base + "warning.svg"
    readonly property url chevronUp:   base + "chevron-up.svg"
    readonly property url chevronDown: base + "chevron-down.svg"

    // home / weather page (mono, tinted)
    readonly property url home:       base + "home.svg"
    readonly property url briefcase:  base + "briefcase.svg"
    readonly property url back:       base + "arrow-left.svg"
    readonly property url more:       base + "dots.svg"

    // energy / settings (mono, tinted)
    readonly property url battery:    base + "battery.svg"
    readonly property url bolt:       base + "bolt.svg"
    readonly property url leaf:       base + "leaf.svg"
    readonly property url road:       base + "road.svg"
    readonly property url globe:      base + "globe.svg"
    readonly property url ruler:      base + "ruler.svg"
    readonly property url info:       base + "info.svg"
    readonly property url shield:     base + "shield.svg"

    // weather icons (full colour — render with a plain Image, not AppIcon)
    readonly property url wSun:       base + "w-sun.svg"
    readonly property url wCloud:     base + "w-cloud.svg"
    readonly property url wPartly:    base + "w-partly.svg"
    readonly property url wRain:      base + "w-rain.svg"
    readonly property url wStorm:     base + "w-storm.svg"

    // music page (mono, tinted)
    readonly property url search:      base + "search.svg"
    readonly property url heartOutline: base + "heart-outline.svg"
    readonly property url repeat:      base + "repeat.svg"
    readonly property url queue:       base + "queue.svg"
    readonly property url person:      base + "person.svg"

    // music card art (full colour — render with a plain Image)
    readonly property url cHeart:    base + "c-heart.svg"
    readonly property url cWave:     base + "c-wave.svg"
    readonly property url cStar:     base + "c-star.svg"
    readonly property url cDiscover: base + "c-discover.svg"

    // illustrations
    readonly property url carTopView:  "qrc:/images/car_topview.svg"
    readonly property url carTopViewH: "qrc:/images/car_topview_h.svg"
    readonly property url albumCover:  "qrc:/images/album_cover.svg"
}
