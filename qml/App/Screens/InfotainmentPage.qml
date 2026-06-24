// InfotainmentPage.qml
// The media / quick-settings page content (status bar, quick toggles, volume &
// brightness sliders, now-playing card). Lives inside AppShell's content area;
// it does not draw the panel, background or rail itself.

import QtQuick
import QtQuick.Layouts
import App.Theme
import App.Icons
import App.Components
import App.Controllers

Item {
    id: page

    property SystemController controller

    Item {
        anchors.fill: parent
        anchors.leftMargin: Theme.metrics.paddingLg
        anchors.rightMargin: Theme.metrics.paddingLg
        anchors.topMargin: Theme.metrics.paddingMd
        anchors.bottomMargin: Theme.metrics.paddingLg

        StatusBar {
            id: status
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            network: page.controller.network
            time: page.controller.time
            date: page.controller.date
        }

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: status.bottom
            anchors.bottom: parent.bottom
            anchors.topMargin: Theme.metrics.paddingMd
            spacing: Theme.metrics.spacing

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Theme.metrics.spacing

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.metrics.spacing

                    ToggleTile {
                        text: "Cellular"
                        iconSource: Icons.cellular
                        accentColor: Theme.colors.accent
                        checked: page.controller.cellularOn
                        onToggled: (c) => page.controller.cellularOn = c
                    }
                    ToggleTile {
                        text: "Bluetooth"
                        iconSource: Icons.bluetooth
                        accentColor: Theme.colors.accent
                        checked: page.controller.bluetoothOn
                        onToggled: (c) => page.controller.bluetoothOn = c
                    }
                    ToggleTile {
                        text: "Notification"
                        iconSource: Icons.notification
                        accentColor: Theme.colors.danger
                        checked: page.controller.notificationsMuted
                        onToggled: (c) => page.controller.notificationsMuted = c
                    }
                    ToggleTile {
                        text: "Hotspot"
                        iconSource: Icons.hotspot
                        accentColor: Theme.colors.accent
                        checked: page.controller.hotspotOn
                        onToggled: (c) => page.controller.hotspotOn = c
                    }
                    Item { Layout.fillWidth: true }
                }

                Item { Layout.fillHeight: true; Layout.preferredHeight: 1 }

                ValueSlider {
                    Layout.fillWidth: true
                    value: page.controller.volume
                    fillColor: Theme.colors.success
                    handleIcon: Icons.volume
                    onMoved: page.controller.volume = value
                }

                ValueSlider {
                    Layout.fillWidth: true
                    value: page.controller.brightness
                    fillColor: Theme.colors.accent
                    handleIcon: Icons.brightness
                    onMoved: page.controller.brightness = value
                }

                Item { Layout.fillHeight: true; Layout.preferredHeight: 1 }
            }

            NowPlayingCard {
                Layout.preferredWidth: 360
                Layout.fillHeight: true
                title: page.controller.trackTitle
                artist: page.controller.trackArtist
                playing: page.controller.playing
                progress: page.controller.trackProgress
                onToggled: page.controller.playing = playing
            }
        }
    }
}
