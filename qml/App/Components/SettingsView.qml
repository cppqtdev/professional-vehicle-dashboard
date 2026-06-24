// SettingsView.qml
// A real-HMI style settings panel: brightness/volume sliders, a grid of
// switches, and value rows. Used as the "Setting" tab of the Control screen.
//
// Each row has an explicit height (Surface has no implicit size), and a trailing
// spacer absorbs extra vertical space so rows never stretch or overlap.

import QtQuick
import QtQuick.Layouts
import App.Theme
import App.Icons
import App.Components
import App.Controllers

Item {
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

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 22
            anchors.rightMargin: 22
            anchors.topMargin: 14
            anchors.bottomMargin: 14
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

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 22
            anchors.rightMargin: 22
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

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 22
            anchors.rightMargin: 22
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

    // ---- Layout -----------------------------------------------------------
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        // sliders
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 112
            spacing: Theme.metrics.spacing
            SliderCard {
                Layout.fillWidth: true; Layout.fillHeight: true
                icon: Icons.brightness; label: "Display brightness"
                fill: Theme.colors.accent; handleIcon: Icons.brightness
                value: view.controller.brightness
                onMoved: (v) => view.controller.brightness = v
            }
            SliderCard {
                Layout.fillWidth: true; Layout.fillHeight: true
                icon: Icons.volume; label: "Volume"
                fill: Theme.colors.success; handleIcon: Icons.volume
                value: view.controller.volume
                onMoved: (v) => view.controller.volume = v
            }
        }

        // switches
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 16
            columnSpacing: Theme.metrics.spacing

            SwitchRow {
                Layout.fillWidth: true; Layout.preferredHeight: 58
                icon: Icons.hotspot; label: "Wi-Fi"
                value: view.controller.wifiOn
                onToggled: (c) => view.controller.wifiOn = c
            }
            SwitchRow {
                Layout.fillWidth: true; Layout.preferredHeight: 58
                icon: Icons.lock; label: "Auto lock"
                value: view.controller.autoLock
                onToggled: (c) => view.controller.autoLock = c
            }
            SwitchRow {
                Layout.fillWidth: true; Layout.preferredHeight: 58
                icon: Icons.shield; label: "Driver assist"
                value: view.controller.driverAssist
                onToggled: (c) => view.controller.driverAssist = c
            }
            SwitchRow {
                Layout.fillWidth: true; Layout.preferredHeight: 58
                icon: Icons.leaf; label: "Eco mode"
                value: view.controller.ecoMode
                onToggled: (c) => view.controller.ecoMode = c
            }
        }

        // value rows
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 66
            spacing: Theme.metrics.spacing
            ValueRow {
                Layout.fillWidth: true; Layout.fillHeight: true
                icon: Icons.globe; label: "Language"; value: view.controller.language
            }
            ValueRow {
                Layout.fillWidth: true; Layout.fillHeight: true
                icon: Icons.ruler; label: "Units"; value: view.controller.units
            }
        }

        // absorb remaining space so rows stay top-aligned
        Item { Layout.fillWidth: true; Layout.fillHeight: true }
    }
}
