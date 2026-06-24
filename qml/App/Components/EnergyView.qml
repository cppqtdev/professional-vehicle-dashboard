// EnergyView.qml
// EV energy dashboard: a large battery/range card plus a grid of metric cards.
// Used as the "Energy" tab of the Control screen.

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import App.Theme
import App.Icons
import App.Components
import App.Controllers

Control {
    id: view
    property SystemController controller

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 30
        anchors.rightMargin: 30
        anchors.topMargin: 10
        anchors.bottomMargin: 20
        spacing: Theme.metrics.spacing

        // ---- Battery / range card ----------------------------------------
        Surface {
            Layout.preferredWidth: 360
            Layout.fillHeight: true
            radius: Theme.metrics.cardRadius
            neomorph: true
            color: Theme.colors.tile

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 28
                spacing: 14

                RowLayout {
                    spacing: 12
                    AppIcon { source: Icons.battery; size: 32; color: Theme.colors.success }
                    Text {
                        text: view.controller.charging ? "Charging" : "Battery"
                        color: Theme.colors.textSecondary
                        font.family: Theme.typography.family
                        font.pixelSize: Theme.typography.subtitle
                    }
                    Item { Layout.fillWidth: true }
                }

                Text {
                    text: Math.round(view.controller.batteryLevel * 100) + "%"
                    color: Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: 58
                    font.weight: Theme.typography.weightBold
                }

                // battery level bar
                Rectangle {
                    Layout.fillWidth: true
                    height: 16
                    radius: 8
                    color: Theme.colors.sliderTrack
                    Rectangle {
                        width: parent.width * view.controller.batteryLevel
                        height: parent.height
                        radius: parent.radius
                        color: Theme.colors.success
                        Behavior on width { NumberAnimation { duration: Theme.motion.normal } }
                    }
                }

                Text {
                    text: view.controller.rangeKm + " km range"
                    color: Theme.colors.textSecondary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.subtitle
                }

                Item { Layout.fillHeight: true }
            }
        }

        // ---- Metric grid -------------------------------------------------
        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            rowSpacing: Theme.metrics.spacing
            columnSpacing: Theme.metrics.spacing

            StatCard {
                Layout.fillWidth: true; Layout.fillHeight: true
                icon: Icons.bolt;  accent: Theme.colors.accent
                value: view.controller.consumption.toFixed(1)
                label: "kWh / 100 km"
            }
            StatCard {
                Layout.fillWidth: true; Layout.fillHeight: true
                icon: Icons.leaf;  accent: Theme.colors.success
                value: view.controller.regen.toFixed(1) + " kWh"
                label: "Regenerated"
            }
            StatCard {
                Layout.fillWidth: true; Layout.fillHeight: true
                icon: Icons.road;  accent: Theme.colors.accent
                value: view.controller.rangeKm + " km"
                label: "Estimated range"
            }
            StatCard {
                Layout.fillWidth: true; Layout.fillHeight: true
                icon: Icons.battery; accent: Theme.colors.danger
                value: view.controller.batteryTemp + "°C"
                label: "Battery temp"
            }
        }
    }
}
