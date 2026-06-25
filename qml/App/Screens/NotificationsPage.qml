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

    component Notice: Control {
        id: notice
        property url icon
        property string title
        property string body
        property string time
        property color accent: Theme.colors.accent

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
                source: notice.icon
                size: 34
                color: notice.accent
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: 3
                Text { text: notice.title; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.subtitle; font.weight: Theme.typography.weightBold }
                Text { text: notice.body; color: Theme.colors.textSecondary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.caption; wrapMode: Text.WordWrap }
            }

            Item { Layout.fillWidth: true }

            Text {
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: notice.time
                color: Theme.colors.textSecondary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.caption
            }
        }
    }

    contentItem: Flickable {
        clip: true
        anchors.fill: parent
        contentWidth: column.width
        contentHeight: column.height

        Control {
            width: page.width
            padding: 30
            topPadding: 20
            bottomPadding: 20

            contentItem: ColumnLayout {
                id: column
                spacing: Theme.metrics.spacing

                Text { text: "Notifications"; Layout.fillWidth: true;  color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 30; font.weight: Theme.typography.weightBold }

                Notice { Layout.fillWidth: true; Layout.preferredHeight: 92; icon: Icons.warning; title: "Weather alert"; body: "Thunderstorm nearby. Route guidance will avoid flooded roads."; time: "Now"; accent: Theme.colors.danger }
                Notice { Layout.fillWidth: true; Layout.preferredHeight: 92; icon: Icons.battery; title: "Charging suggestion"; body: "Battery projected at 22% on arrival. Add a charger stop?"; time: "2m"; accent: Theme.colors.accent }
                Notice { Layout.fillWidth: true; Layout.preferredHeight: 92; icon: Icons.info; title: "Service reminder"; body: "Tire rotation and cabin filter due in 2,400 km."; time: "1h"; accent: Theme.colors.iconMuted }
                Notice { Layout.fillWidth: true; Layout.preferredHeight: 92; icon: Icons.person; title: "Incoming call"; body: "Aarav Kapoor. Use steering controls or voice assistant to answer."; time: "4h"; accent: Theme.colors.success }
                Notice { Layout.fillWidth: true; Layout.preferredHeight: 92; icon: Icons.lock; title: "Vehicle secured"; body: "Doors locked, windows closed, sentry mode active."; time: "Yesterday"; accent: Theme.colors.success }

                Item {
                    Layout.preferredHeight: 20
                }
            }
        }
    }
}
