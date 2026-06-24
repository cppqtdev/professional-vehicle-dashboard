 // InfotainmentScreen.qml
// Assembles the full control panel from reusable components, bound to a single
// SystemController. Re-themes live via the Theme singleton.

import QtQuick
import QtQuick.Layouts
import App.Theme
import App.Icons
import App.Components
import App.Controllers

Item {
    id: screen

    implicitWidth: 1180
    implicitHeight: 520

    // ---- State ------------------------------------------------------------
    SystemController { id: system }

    // ---- App canvas -------------------------------------------------------
    Rectangle {
        anchors.fill: parent
        color: Theme.colors.background
        Behavior on color { ColorAnimation { duration: Theme.motion.normal } }
    }

    // ---- Main panel -------------------------------------------------------
    Surface {
        id: panel
        anchors.fill: parent
        anchors.margins: 22
        radius: Theme.metrics.panelRadius
        color: Theme.colors.surface
        elevated: true

        // Left navigation rail
        SideRail {
            id: rail
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            hours: "09"
            minutes: "35"
            currentIndex: system.navIndex
            onActivated: (index) => system.navIndex = index
        }

        // Content area to the right of the rail
        Item {
            id: content
            anchors.left: rail.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: Theme.metrics.paddingLg
            anchors.rightMargin: Theme.metrics.paddingLg
            anchors.topMargin: Theme.metrics.paddingMd
            anchors.bottomMargin: Theme.metrics.paddingLg

            StatusBar {
                id: status
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                network: system.network
                time: system.time
                date: system.date
            }

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: status.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: Theme.metrics.paddingMd
                spacing: Theme.metrics.spacing

                // Left: toggles + sliders
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Theme.metrics.spacing

                    // Quick-setting toggles
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Theme.metrics.spacing

                        ToggleTile {
                            text: "Cellular"
                            iconSource: Icons.cellular
                            accentColor: Theme.colors.accent
                            checked: system.cellularOn
                            onToggled: (c) => system.cellularOn = c
                        }
                        ToggleTile {
                            text: "Bluetooth"
                            iconSource: Icons.bluetooth
                            accentColor: Theme.colors.accent
                            checked: system.bluetoothOn
                            onToggled: (c) => system.bluetoothOn = c
                        }
                        ToggleTile {
                            text: "Notification"
                            iconSource: Icons.notification
                            accentColor: Theme.colors.danger
                            checked: system.notificationsMuted
                            onToggled: (c) => system.notificationsMuted = c
                        }
                        ToggleTile {
                            text: "Hotspot"
                            iconSource: Icons.hotspot
                            accentColor: Theme.colors.accent
                            checked: system.hotspotOn
                            onToggled: (c) => system.hotspotOn = c
                        }
                        Item { Layout.fillWidth: true } // push tiles left
                    }

                    Item { Layout.fillHeight: true; Layout.preferredHeight: 1 }

                    // Volume
                    ValueSlider {
                        Layout.fillWidth: true
                        value: system.volume
                        fillColor: Theme.colors.success
                        handleIcon: Icons.volume
                        onMoved: system.volume = value
                    }

                    // Brightness
                    ValueSlider {
                        Layout.fillWidth: true
                        value: system.brightness
                        fillColor: Theme.colors.accent
                        handleIcon: Icons.brightness
                        onMoved: system.brightness = value
                    }

                    Item { Layout.fillHeight: true; Layout.preferredHeight: 1 }
                }

                // Right: now playing
                NowPlayingCard {
                    Layout.preferredWidth: 360
                    Layout.fillHeight: true
                    title: system.trackTitle
                    artist: system.trackArtist
                    playing: system.playing
                    progress: system.trackProgress
                    onToggled: system.playing = playing
                }
            }
        }
    }
}
