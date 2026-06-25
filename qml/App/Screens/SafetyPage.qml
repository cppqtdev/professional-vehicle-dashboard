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

    component SafetyRow: Control {
        id: row
        property url icon
        property string title
        property string state
        property bool active: true

        padding: 18
        background: Surface {
            radius: 18
            color: Theme.colors.tile
            neomorph: true
        }

        contentItem: RowLayout {
            spacing: 18

            AppIcon {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                source: row.icon
                size: 32
                color: row.active ? Theme.colors.success : Theme.colors.iconMuted
            }

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                text: row.title
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.subtitle
                font.weight: Theme.typography.weightMedium
                elide: Text.ElideRight
            }

            Text {
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                horizontalAlignment: Text.AlignRight
                text: row.state
                color: row.active ? Theme.colors.success : Theme.colors.textSecondary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.caption
                elide: Text.ElideRight
            }
        }
    }

    contentItem: ColumnLayout {
        spacing: Theme.metrics.spacing
        Text { text: "Safety states"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 30; font.weight: Theme.typography.weightBold }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            rowSpacing: Theme.metrics.spacing
            columnSpacing: Theme.metrics.spacing

            SafetyRow { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.shield; title: "Driving lockouts"; state: "Enabled"; active: true }
            SafetyRow { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.warning; title: "Large touch mode"; state: "Auto"; active: true }
            SafetyRow { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.road; title: "Lane assist"; state: "Ready"; active: true }
            SafetyRow { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.volume; title: "Voice first prompts"; state: "On"; active: true }
            SafetyRow { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.notification; title: "Reduce notifications"; state: "Driving"; active: false }
            SafetyRow { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.info; title: "Emergency info"; state: "Configured"; active: true }
        }
    }
}
