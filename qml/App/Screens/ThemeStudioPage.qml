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
    padding: 30
    topPadding: 20
    bottomPadding: 20

    component Swatch: Control {
        id: swatch
        property color swatchColor
        property string title

        padding: 18
        background: Surface {
            radius: Theme.metrics.cardRadius
            color: Theme.colors.tile
            neomorph: true
        }
        contentItem: RowLayout {
            spacing: 18

            Rectangle {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                width: 42
                height: 42
                radius: 21
                color: swatch.swatchColor
            }

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: swatch.title
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.subtitle
                font.weight: Theme.typography.weightMedium
                elide: Text.ElideRight
            }
        }
    }

    component ThemeOption: Control {
        id: option
        property url icon
        property string title
        property bool checked: true
        signal toggled(bool checked)

        padding: 18
        background: Surface {
            radius: Theme.metrics.cardRadius
            color: Theme.colors.tile
            neomorph: true
        }

        contentItem: RowLayout {
            spacing: 18

            AppIcon {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                source: option.icon
                size: 34
                color: Theme.colors.accent
            }

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: option.title
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.subtitle
                font.weight: Theme.typography.weightMedium
                elide: Text.ElideRight
            }

            SwitchControl {
                Layout.alignment: Qt.AlignVCenter
                checked: option.checked
                onToggled: (c) => option.toggled(c)
            }
        }
    }

    contentItem: ColumnLayout {
        spacing: Theme.metrics.spacing
        Text { Layout.fillWidth: true; text: "Theme studio"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 30; font.weight: Theme.typography.weightBold }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            rowSpacing: Theme.metrics.spacing
            columnSpacing: Theme.metrics.spacing

            Swatch { Layout.fillWidth: true; Layout.preferredHeight: 90; swatchColor: Theme.colors.accent; title: "Ambient Indigo" }
            Swatch { Layout.fillWidth: true; Layout.preferredHeight: 90; swatchColor: Theme.colors.success; title: "Eco Green" }
            Swatch { Layout.fillWidth: true; Layout.preferredHeight: 90; swatchColor: Theme.colors.danger; title: "Alert Red" }
            Swatch { Layout.fillWidth: true; Layout.preferredHeight: 90; swatchColor: Theme.colors.onaccent; title: "Soft Surface" }

            ThemeOption {
                Layout.fillWidth: true
                Layout.fillHeight: true
                icon: Icons.wRain
                title: "Weather texture overlay"
                checked: page.controller.textureEnabled
                onToggled: (c) => appBackend.textureEnabled = c
            }

            ThemeOption {
                Layout.fillWidth: true
                Layout.fillHeight: true
                icon: Icons.moon
                title: "Auto day/night mode"
                checked: true
            }
        }
    }
}
