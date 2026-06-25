import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import App.Theme
import App.Icons
import App.Components
import App.Controllers

Control {
    id: page
    property SystemController controller
    topPadding: 20
    bottomPadding: 20
    padding: 30

    component ClimateAction: ColumnLayout {
        id: action
        property url icon
        property string label
        property bool checked: false
        property color accent: Theme.colors.accent
        signal toggled(bool checked)

        spacing: 10

        IconButton {
            Layout.alignment: Qt.AlignHCenter
            diameter: 76
            iconSource: action.icon
            checked: action.checked
            accentColor: action.accent
            onToggled: (c) => action.toggled(c)
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: action.label
            color: action.checked ? Theme.colors.textPrimary : Theme.colors.textSecondary
            font.family: Theme.typography.family
            font.pixelSize: Theme.typography.caption
            font.weight: action.checked ? Theme.typography.weightMedium : Theme.typography.weightRegular
        }
    }

    contentItem: ColumnLayout {
        spacing: Theme.metrics.spacing

        Text { Layout.fillWidth: true; Layout.alignment: Qt.AlignLeft | Qt.AlignTop; text: "Climate control"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 30; font.weight: Theme.typography.weightBold }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.metrics.spacing

            Control {
                Layout.fillWidth: true
                Layout.fillHeight: true
                padding: 20

                background: Surface {
                    radius: Theme.metrics.cardRadius
                    color: Theme.colors.tile
                    neomorph: true
                }

                contentItem: ColumnLayout {
                    spacing: 20

                    Text { text: "Cabin zones"; Layout.alignment: Qt.AlignLeft | Qt.AlignTop; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 24; font.weight: Theme.typography.weightBold }

                    ClimateBar {
                        Layout.fillWidth: true

                        leftPadding: 0
                        rightPadding: 0
                        leftTemp: page.controller.driverTemp
                        rightTemp: page.controller.passengerTemp
                        onLeftTempStep: (d) => climateControls.stepDriverTemp(d)
                        onRightTempStep: (d) => climateControls.stepPassengerTemp(d)
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 28

                        Item { Layout.fillWidth: true }

                        ClimateAction {
                            icon: Icons.seat
                            label: "Seat"
                            checked: climateControls.seatHeatOn
                            accent: Theme.colors.success
                            onToggled: (c) => climateControls.seatHeatOn = c
                        }

                        Item { Layout.fillWidth: true }

                        ClimateAction {
                            icon: Icons.fan
                            label: "Fan"
                            checked: climateControls.acOn
                            accent: Theme.colors.accent
                            onToggled: (c) => climateControls.acOn = c
                        }

                        Item { Layout.fillWidth: true }

                        ClimateAction {
                            icon: Icons.defrost
                            label: "Defrost"
                            checked: climateControls.defrostOn
                            accent: Theme.colors.danger
                            onToggled: (c) => climateControls.defrostOn = c
                        }

                        Item { Layout.fillWidth: true }

                        ClimateAction {
                            icon: Icons.infinity
                            label: "Sync"
                            checked: climateControls.autoMode
                            accent: Theme.colors.accent
                            onToggled: (c) => climateControls.autoMode = c
                        }

                        Item { Layout.fillWidth: true }
                    }
                }
            }

            Control {
                Layout.preferredWidth: 360
                Layout.fillHeight: true
                padding: 28

                background: Surface {
                    radius: Theme.metrics.cardRadius
                    color: Theme.colors.tile
                    neomorph: true
                }

                contentItem: ColumnLayout {
                    spacing: 18
                    Text { text: "Airflow"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 24; font.weight: Theme.typography.weightBold }
                    ValueSlider {
                        Layout.fillWidth: true
                        value: climateControls.fanSpeed
                        fillColor: Theme.colors.accent
                        handleIcon: Icons.fan
                        onMoved: climateControls.fanSpeed = value
                    }
                    Text {
                        text: (climateControls.autoMode ? "Auto" : "Manual")
                              + " • " + (climateControls.acOn ? "A/C on" : "A/C off")
                              + " • " + (climateControls.defrostOn ? "Defrost active" : "Face + feet")
                        color: Theme.colors.textSecondary
                        font.family: Theme.typography.family
                        font.pixelSize: Theme.typography.subtitle
                        wrapMode: Text.WordWrap
                    }
                    Item { Layout.fillHeight: true }
                    Text { text: climateControls.autoMode ? "AUTO" : "MANUAL"; color: Theme.colors.accent; font.family: Theme.typography.family; font.pixelSize: 38; font.weight: Theme.typography.weightBold }
                }
            }
        }
    }
}
