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

    component AppTile: Control {
        id: tile
        property url icon
        property string title
        property string subtitle
        property color accent: Theme.colors.accent

        padding: 18

        background: Surface {
            radius: Theme.metrics.cardRadius
            color: Theme.colors.tile
            neomorph: true
        }

        contentItem: ColumnLayout {
            spacing: 10

            AppIcon {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                source: tile.icon
                size: 42
                color: tile.accent
            }

            Item { Layout.fillHeight: true }

            Text {
                Layout.fillWidth: true
                text: tile.title
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.subtitle
                font.weight: Theme.typography.weightBold
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                text: tile.subtitle
                color: Theme.colors.textSecondary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.caption
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }
        }
    }

    contentItem: ColumnLayout {
        spacing: Theme.metrics.spacing

        RowLayout {
            Layout.fillWidth: true
            Text { Layout.fillWidth: true; text: "Parked mode"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 30; font.weight: Theme.typography.weightBold }
            Text { text: "Available while vehicle is parked"; color: Theme.colors.textSecondary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.subtitle }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            columns: 3
            rowSpacing: Theme.metrics.spacing
            columnSpacing: Theme.metrics.spacing

            AppTile { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.play; title: "Theater"; subtitle: "Video and entertainment"; accent: Theme.colors.danger }
            AppTile { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.search; title: "Browser"; subtitle: "Search, docs, and web apps"; accent: Theme.colors.accent }
            AppTile { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.music; title: "Studio"; subtitle: "Music, podcasts, radio"; accent: Theme.colors.success }
            AppTile { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.fan; title: "Camp comfort"; subtitle: "Climate and airflow presets"; accent: Theme.colors.accent }
            AppTile { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.battery; title: "Charging"; subtitle: "Schedule and charge limits"; accent: Theme.colors.success }
            AppTile { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.shield; title: "Sentry"; subtitle: "Security monitoring"; accent: Theme.colors.iconMuted }
        }
    }
}
