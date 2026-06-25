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

    component CommandCard: Control {
        id: cmd
        property url icon
        property string text

        padding: 18

        background: Surface {
            radius: 18
            color: Theme.colors.tile
            neomorph: true
            pressed: commandMouse.pressed
        }

        contentItem: RowLayout {
            spacing: 18

            AppIcon {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                source: cmd.icon
                size: 30
                color: Theme.colors.accent
            }

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: cmd.text
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.subtitle
                font.weight: Theme.typography.weightMedium
                elide: Text.ElideRight
            }
        }

        MouseArea {
            id: commandMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: appBackend.executeVoiceCommand(cmd.text)
        }
    }

    contentItem: RowLayout {
        spacing: Theme.metrics.spacing

        Control {
            Layout.leftMargin: 20
            Layout.topMargin: 20
            Layout.bottomMargin: 20
            Layout.preferredWidth: 390
            Layout.fillHeight: true

            background: Surface {
                radius: Theme.metrics.cardRadius
                color: Theme.colors.tile
                neomorph: true
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 22

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 160; height: 160; radius: 80
                    color: Theme.colors.accent
                    opacity: 0.22
                    AppIcon { anchors.centerIn: parent; source: Icons.volume; size: 64; color: Theme.colors.accent }
                }

                Text { Layout.alignment: Qt.AlignHCenter; text: "Listening"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 34; font.weight: Theme.typography.weightBold }
                Text { Layout.alignment: Qt.AlignHCenter; text: "\"Where would you like to go?\""; color: Theme.colors.textSecondary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.subtitle }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.metrics.spacing

            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                contentWidth: width
                contentHeight: commandColumn.height

                Control {
                    width: parent.width
                    padding: 20

                    contentItem: ColumnLayout {
                        id: commandColumn
                        spacing: Theme.metrics.spacing

                        Text { text: "Suggested commands"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 30; font.weight: Theme.typography.weightBold }

                        CommandCard { Layout.fillWidth: true; Layout.preferredHeight: 76; icon: Icons.nav; text: "Navigate home avoiding tolls" }
                        CommandCard { Layout.fillWidth: true; Layout.preferredHeight: 76; icon: Icons.fan; text: "Set driver temperature to 22 degrees" }
                        CommandCard { Layout.fillWidth: true; Layout.preferredHeight: 76; icon: Icons.music; text: "Play my daily recommended playlist" }
                        CommandCard { Layout.fillWidth: true; Layout.preferredHeight: 76; icon: Icons.bolt; text: "Find a fast charger on my route" }
                        CommandCard { Layout.fillWidth: true; Layout.preferredHeight: 76; icon: Icons.lock; text: "Lock doors and close windows" }
                        CommandCard { Layout.fillWidth: true; Layout.preferredHeight: 76; icon: Icons.warning; text: "Show weather along my route" }

                        Item {
                            Layout.preferredHeight: 20
                        }
                    }
                }
            }
        }
    }
}
