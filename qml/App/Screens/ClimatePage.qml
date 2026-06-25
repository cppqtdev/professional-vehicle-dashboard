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

        spacing: 10

        IconButton {
            Layout.alignment: Qt.AlignHCenter
            diameter: 76
            iconSource: action.icon
            checked: action.checked
            accentColor: action.accent
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
                        onLeftTempStep: (d) => page.controller.driverTemp = Math.max(16, Math.min(30, page.controller.driverTemp + d))
                        onRightTempStep: (d) => page.controller.passengerTemp = Math.max(16, Math.min(30, page.controller.passengerTemp + d))
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 28

                        Item { Layout.fillWidth: true }

                        ClimateAction { icon: Icons.seat; label: "Seat"; checked: true; accent: Theme.colors.success }

                        Item { Layout.fillWidth: true }

                        ClimateAction { icon: Icons.fan; label: "Fan"; checked: true; accent: Theme.colors.accent }

                        Item { Layout.fillWidth: true }

                        ClimateAction { icon: Icons.defrost; label: "Defrost"; checked: false; accent: Theme.colors.danger }

                        Item { Layout.fillWidth: true }

                        ClimateAction { icon: Icons.infinity; label: "Sync"; checked: false; accent: Theme.colors.accent }

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
                    ValueSlider { Layout.fillWidth: true; value: 0.62; fillColor: Theme.colors.accent; handleIcon: Icons.fan }
                    Text { text: "Auto • Face + feet • Clean air enabled"; color: Theme.colors.textSecondary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.subtitle; wrapMode: Text.WordWrap }
                    Item { Layout.fillHeight: true }
                    Text { text: "SYNC"; color: Theme.colors.accent; font.family: Theme.typography.family; font.pixelSize: 38; font.weight: Theme.typography.weightBold }
                }
            }
        }
    }
}
