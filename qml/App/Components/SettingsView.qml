// SettingsView.qml
// A real-HMI style settings panel: brightness/volume sliders, a grid of
// switches, and value rows. Used as the "Setting" tab of the Control screen.
//
// Each row has an explicit height (Surface has no implicit size), and a trailing
// spacer absorbs extra vertical space so rows never stretch or overlap.

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import App.Theme
import App.Icons
import App.Components
import App.Controllers

Control {
    id: view
    property SystemController controller

    // ---- Inline row types (no Layout.* here — set at each usage) ----------
    component SliderCard: Surface {
        id: sc
        property url icon
        property string label
        property real value: 0.5
        property color fill: Theme.colors.accent
        property url handleIcon
        signal moved(real v)

        radius: 20
        neomorph: true
        color: Theme.colors.tile
        leftPadding: 22
        rightPadding: 22
        padding: 14

        contentItem: ColumnLayout {
            spacing: 6

            RowLayout {
                spacing: 12
                AppIcon { source: sc.icon; size: 22; color: Theme.colors.icon }

                Text {
                    Layout.fillWidth: true
                    text: sc.label
                    color: Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.subtitle
                    font.weight: Theme.typography.weightMedium
                }
            }

            ValueSlider {
                Layout.fillWidth: true
                value: sc.value
                fillColor: sc.fill
                handleIcon: sc.handleIcon
                onMoved: sc.moved(value)
            }
        }
    }

    component SwitchRow: Surface {
        id: r
        property url icon
        property string label
        property bool value: false
        signal toggled(bool checked)

        radius: 18
        neomorph: true
        color: Theme.colors.tile
        leftPadding: 22
        rightPadding: 22
        padding: 14

        contentItem: RowLayout {
            spacing: 14

            AppIcon { source: r.icon; size: 22; color: Theme.colors.icon }

            Text {
                Layout.fillWidth: true
                text: r.label
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.subtitle
                font.weight: Theme.typography.weightMedium
            }

            SwitchControl {
                checked: r.value
                onToggled: (c) => r.toggled(c)
            }
        }
    }

    component ValueRow: Surface {
        id: vr
        property url icon
        property string label
        property string value
        radius: 18
        neomorph: true
        color: Theme.colors.tile
        leftPadding: 22
        rightPadding: 22
        padding: 14

        contentItem: RowLayout {
            spacing: 14
            AppIcon { source: vr.icon; size: 22; color: Theme.colors.icon }

            Text {
                Layout.fillWidth: true
                text: vr.label
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.subtitle
                font.weight: Theme.typography.weightMedium
            }
            Text {
                text: vr.value
                color: Theme.colors.textSecondary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.subtitle
            }
        }
    }

    component WidgetPicker: Surface {
        id: picker
        property string value: "weather"
        radius: 18
        neomorph: true
        color: Theme.colors.tile
        leftPadding: 22
        rightPadding: 22
        padding: 14

        contentItem: RowLayout {
            spacing: 14

            AppIcon {
                source: Icons.home
                size: 22
                color: Theme.colors.icon
            }
            Text {
                text: "Home widget"
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.subtitle
                font.weight: Theme.typography.weightMedium
            }
            Item { Layout.fillWidth: true }

            Repeater {
                model: [
                    { key: "weather", label: "Weather" },
                    { key: "music", label: "Music" },
                    { key: "energy", label: "Energy" },
                    { key: "quick", label: "Quick" },
                    { key: "navigation", label: "Nav" },
                    { key: "climate", label: "Climate" },
                    { key: "tires", label: "Tires" },
                    { key: "trip", label: "Trip" }
                ]
                delegate: Surface {
                    required property var modelData
                    readonly property bool selected: picker.value === modelData.key
                    Layout.preferredWidth: 82
                    Layout.preferredHeight: 38
                    radius: height / 2
                    color: selected ? Theme.colors.accent : Theme.colors.surfaceVariant
                    neomorph: !selected
                    pressed: optionMouse.pressed

                    Text {
                        anchors.centerIn: parent
                        text: modelData.label
                        color: selected ? Theme.colors.onaccent : Theme.colors.textSecondary
                        font.family: Theme.typography.family
                        font.pixelSize: Theme.typography.caption
                        font.weight: Theme.typography.weightMedium
                    }
                    MouseArea {
                        id: optionMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: appBackend.homeWidget = modelData.key
                    }
                }
            }
        }
    }

    // ---- Layout -----------------------------------------------------------
    contentItem: Flickable {
        anchors.fill: parent
        contentWidth: view.width
        contentHeight: layout.height
        clip: true

        Control {
            id: settingsContent
            width: view.width
            leftPadding: 30
            rightPadding: 30
            topPadding: 5
            readonly property int tileGap: Theme.metrics.spacing
            readonly property int tileWidth: Math.floor((availableWidth - tileGap) / 2)

            contentItem: ColumnLayout {
                id: layout
                spacing: 16
                width: settingsContent.availableWidth

                // sliders
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 112
                    spacing: settingsContent.tileGap

                    SliderCard {
                        Layout.preferredWidth: settingsContent.tileWidth
                        Layout.minimumWidth: settingsContent.tileWidth
                        Layout.maximumWidth: settingsContent.tileWidth
                        Layout.fillHeight: true
                        icon: Icons.brightness; label: "Display brightness"
                        fill: Theme.colors.accent; handleIcon: Icons.brightness
                        value: view.controller.brightness
                        onMoved: (v) => view.controller.brightness = v
                    }

                    SliderCard {
                        Layout.preferredWidth: settingsContent.tileWidth
                        Layout.minimumWidth: settingsContent.tileWidth
                        Layout.maximumWidth: settingsContent.tileWidth
                        Layout.fillHeight: true
                        icon: Icons.volume; label: "Volume"
                        fill: Theme.colors.success; handleIcon: Icons.volume
                        value: view.controller.volume
                        onMoved: (v) => view.controller.volume = v
                    }
                }

                WidgetPicker {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 66
                    value: view.controller.homeWidget
                }

                // switches
                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 16
                    columnSpacing: settingsContent.tileGap

                    SwitchRow {
                        Layout.preferredWidth: settingsContent.tileWidth
                        Layout.minimumWidth: settingsContent.tileWidth
                        Layout.maximumWidth: settingsContent.tileWidth
                        Layout.preferredHeight: 58
                        icon: Theme.dark ? Icons.moon : Icons.sun
                        label: "Dark theme"
                        value: view.controller.darkTheme
                        onToggled: (c) => appBackend.darkTheme = c
                    }
                    SwitchRow {
                        Layout.preferredWidth: settingsContent.tileWidth
                        Layout.minimumWidth: settingsContent.tileWidth
                        Layout.maximumWidth: settingsContent.tileWidth
                        Layout.preferredHeight: 58
                        icon: Icons.wRain
                        label: "Weather texture"
                        value: view.controller.textureEnabled
                        onToggled: (c) => appBackend.textureEnabled = c
                    }
                    SwitchRow {
                        Layout.preferredWidth: settingsContent.tileWidth
                        Layout.minimumWidth: settingsContent.tileWidth
                        Layout.maximumWidth: settingsContent.tileWidth
                        Layout.preferredHeight: 58
                        icon: Icons.hotspot; label: "Wi-Fi"
                        value: view.controller.wifiOn
                        onToggled: (c) => appBackend.wifiOn = c
                    }
                    SwitchRow {
                        Layout.preferredWidth: settingsContent.tileWidth
                        Layout.minimumWidth: settingsContent.tileWidth
                        Layout.maximumWidth: settingsContent.tileWidth
                        Layout.preferredHeight: 58
                        icon: Icons.lock; label: "Auto lock"
                        value: view.controller.autoLock
                        onToggled: (c) => appBackend.autoLock = c
                    }
                    SwitchRow {
                        Layout.preferredWidth: settingsContent.tileWidth
                        Layout.minimumWidth: settingsContent.tileWidth
                        Layout.maximumWidth: settingsContent.tileWidth
                        Layout.preferredHeight: 58
                        icon: Icons.shield; label: "Driver assist"
                        value: view.controller.driverAssist
                        onToggled: (c) => appBackend.driverAssist = c
                    }
                    SwitchRow {
                        Layout.preferredWidth: settingsContent.tileWidth
                        Layout.minimumWidth: settingsContent.tileWidth
                        Layout.maximumWidth: settingsContent.tileWidth
                        Layout.preferredHeight: 58
                        icon: Icons.leaf; label: "Eco mode"
                        value: view.controller.ecoMode
                        onToggled: (c) => appBackend.ecoMode = c
                    }
                }

                // value rows
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 66
                    spacing: settingsContent.tileGap

                    ValueRow {
                        Layout.preferredWidth: settingsContent.tileWidth
                        Layout.minimumWidth: settingsContent.tileWidth
                        Layout.maximumWidth: settingsContent.tileWidth
                        Layout.fillHeight: true
                        icon: Icons.globe; label: "Language"; value: view.controller.language
                    }

                    ValueRow {
                        Layout.preferredWidth: settingsContent.tileWidth
                        Layout.minimumWidth: settingsContent.tileWidth
                        Layout.maximumWidth: settingsContent.tileWidth
                        Layout.fillHeight: true
                        icon: Icons.ruler; label: "Units"; value: view.controller.units
                    }
                }

                // absorb remaining space so rows stay top-aligned
                Item { Layout.fillWidth: true; Layout.preferredHeight: 20 }
            }
        }
    }
}
