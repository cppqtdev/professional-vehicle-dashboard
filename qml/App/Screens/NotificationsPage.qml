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

    function noticeIcon(name) {
        switch (name) {
        case "battery": return Icons.battery
        case "person": return Icons.person
        case "lock": return Icons.lock
        case "info": return Icons.info
        default: return Icons.warning
        }
    }

    function noticeAccent(name) {
        switch (name) {
        case "danger": return Theme.colors.danger
        case "success": return Theme.colors.success
        case "muted": return Theme.colors.iconMuted
        default: return Theme.colors.accent
        }
    }

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

                Repeater {
                    model: page.controller.notifications
                    delegate: Notice {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.preferredHeight: 92
                        icon: page.noticeIcon(modelData.icon)
                        title: modelData.title
                        body: modelData.body
                        time: modelData.time
                        accent: page.noticeAccent(modelData.accent)
                    }
                }

                Item {
                    Layout.preferredHeight: 20
                }
            }
        }
    }
}
