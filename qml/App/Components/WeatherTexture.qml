// WeatherTexture.qml
// Procedural windshield-style weather overlay for the home/weather screens.

import QtQuick
import App.Theme

Item {
    id: texture

    property string mode: "rain" // clear, cloud, mist, rain, storm
    property real drift: 0

    clip: true
    opacity: Theme.dark
             ? (mode === "clear" ? 0.38 : 1.0)
             : (mode === "clear" ? 0.10 : 0.28)

    NumberAnimation on drift {
        from: 0
        to: 900
        duration: texture.mode === "storm" ? 5200 : 9000
        loops: Animation.Infinite
        running: texture.visible
    }

    Rectangle {
        anchors.fill: parent
        opacity: Theme.dark
                 ? (texture.mode === "clear" ? 0.10 : 0.22)
                 : (texture.mode === "clear" ? 0.02 : 0.06)
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: texture.mode === "clear" ? "#243146" : "#101219" }
            GradientStop { position: 0.52; color: texture.mode === "storm" ? "#171922" : "#262833" }
            GradientStop { position: 1.0; color: "#11131A" }
        }
    }

    Repeater {
        model: texture.mode === "clear" ? 8 : 54
        delegate: Rectangle {
            readonly property real seed: (index * 37) % 100
            width: texture.mode === "storm" ? 2 : 1
            height: texture.mode === "mist" ? 76 + seed : 120 + seed
            radius: width / 2
            rotation: texture.mode === "mist" ? 5 : 18
            opacity: texture.mode === "clear" ? (Theme.dark ? 0.035 : 0.012)
                    : texture.mode === "cloud" ? 0.05
                    : texture.mode === "storm" ? (Theme.dark ? 0.18 : 0.055)
                    : (Theme.dark ? 0.11 : 0.04)
            color: "#DCE6F0"
            x: ((index * 97) % (Math.max(1, texture.width) + 180)) - 90
            y: ((index * 121 + texture.drift * (0.55 + seed / 210)) %
                (Math.max(1, texture.height) + height + 160)) - height - 80
        }
    }

    Repeater {
        model: texture.mode === "rain" || texture.mode === "storm" ? 90
             : texture.mode === "mist" || texture.mode === "cloud" ? 42 : 16
        delegate: Rectangle {
            readonly property real seed: (index * 53) % 100
            width: texture.mode === "storm" ? 3 + seed % 10 : 2 + seed % 7
            height: width * (1.15 + (seed % 4) * 0.08)
            radius: width / 2
            opacity: texture.mode === "clear" ? (Theme.dark ? 0.08 : 0.025)
                    : texture.mode === "storm" ? (Theme.dark ? 0.26 : 0.09)
                    : texture.mode === "rain" ? (Theme.dark ? 0.22 : 0.075)
                    : (Theme.dark ? 0.13 : 0.045)
            color: "#F5FAFF"
            border.width: 1
            border.color: Qt.rgba(0.18, 0.22, 0.26, 0.42)
            x: ((index * 71) % Math.max(1, texture.width - width))
            y: ((index * 47 + texture.drift * 0.22) %
                (Math.max(1, texture.height) + 60)) - 30

            Rectangle {
                width: Math.max(1, parent.width * 0.28)
                height: Math.max(1, parent.height * 0.28)
                radius: width / 2
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: parent.width * 0.18
                anchors.topMargin: parent.height * 0.12
                opacity: 0.72
                color: "#FFFFFF"
            }
        }
    }

    Repeater {
        model: texture.mode === "storm" || texture.mode === "rain" ? 12 : 5
        delegate: Rectangle {
            readonly property real seed: (index * 29) % 100
            width: 2 + seed % 3
            height: 170 + seed
            radius: width / 2
            opacity: texture.mode === "storm"
                     ? (Theme.dark ? 0.18 : 0.065)
                     : (Theme.dark ? 0.10 : 0.035)
            color: "#F7FBFF"
            x: ((index * 154 + 24) % Math.max(1, texture.width - width))
            y: ((index * 73 + texture.drift * 0.35) %
                (Math.max(1, texture.height) + height)) - height
        }
    }

    Rectangle {
        anchors.fill: parent
        visible: texture.mode === "mist" || texture.mode === "cloud"
        opacity: Theme.dark
                 ? (texture.mode === "mist" ? 0.20 : 0.10)
                 : (texture.mode === "mist" ? 0.055 : 0.03)
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#BFCAD2" }
            GradientStop { position: 0.42; color: "#22BFCAD2" }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }
}
