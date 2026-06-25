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
    property int selectedProfile: 0

    component StatCard: Control {
        id: card

        property url icon
        property string value: ""
        property string label: ""
        property color accent: Theme.colors.accent
        property int iconSize: 28

        padding: 18
        background: Surface {
            implicitWidth: 240
            implicitHeight: 136
            radius: Theme.metrics.cardRadius
            neomorph: true
            color: Theme.colors.tile
        }

        contentItem: ColumnLayout {
            spacing: 8

            Item { Layout.fillHeight: true }

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                spacing: 18

                AppIcon {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    source: card.icon
                    size: card.iconSize
                    color: card.accent
                }

                Text {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    text: card.value
                    color: Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: 24
                    font.capitalization: Font.Capitalize
                    font.weight: Theme.typography.weightBold
                }
            }

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                elide: Text.ElideRight
                text: card.label
                color: Theme.colors.textSecondary
                font.family: Theme.typography.family
                font.pixelSize: 16
            }

            Item { Layout.fillHeight: true }
        }
    }

    component ProfileCard: Control {
        id: card
        property string name
        property string detail
        property bool selected: false
        signal picked()

        padding: 18

        background: Surface {
            radius: Theme.metrics.cardRadius
            color: selected ? Theme.colors.accent : Theme.colors.tile
            neomorph: true
            pressed: mouse.pressed
        }

        contentItem: RowLayout {
            spacing: 16

            AppIcon {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                source: Icons.person
                size: 36
                color: selected ? Theme.colors.onaccent : Theme.colors.icon
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                Text { text: card.name; color: selected ? Theme.colors.onaccent : Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 24; font.weight: Theme.typography.weightBold }
                Text { text: card.detail; color: selected ? Qt.rgba(1,1,1,0.75) : Theme.colors.textSecondary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.caption }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        MouseArea { id: mouse; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: card.picked() }
    }

    contentItem: ColumnLayout {
        spacing: Theme.metrics.spacing

        Text { text: "Driver profiles"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 30; font.weight: Theme.typography.weightBold }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.metrics.spacing

            ColumnLayout {
                Layout.preferredWidth: 430
                Layout.fillHeight: true
                spacing: Theme.metrics.spacing

                ProfileCard { Layout.fillWidth: true; Layout.fillHeight: true; name: "Adesh"; detail: "Sport seat • Dark theme • Weather widget"; selected: page.selectedProfile === 0; onPicked: page.selectedProfile = 0 }
                ProfileCard { Layout.fillWidth: true; Layout.fillHeight: true; name: "Guest"; detail: "Comfort seat • Light theme • Music widget"; selected: page.selectedProfile === 1; onPicked: page.selectedProfile = 1 }
                ProfileCard { Layout.fillWidth: true; Layout.fillHeight: true; name: "Family"; detail: "Eco climate • Safety prompts • Nav widget"; selected: page.selectedProfile === 2; onPicked: page.selectedProfile = 2 }
            }

            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 2
                rowSpacing: Theme.metrics.spacing
                columnSpacing: Theme.metrics.spacing

                StatCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.seat; value: "Seat"; label: "Saved position 2"; accent: Theme.colors.accent }
                StatCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.fan; value: "22°"; label: "Preferred cabin"; accent: Theme.colors.success }
                StatCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.brightness; value: Theme.dark ? "Dark" : "Light"; label: "Theme mode"; accent: Theme.colors.accent }
                StatCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.home; value: page.controller.homeWidget; label: "Home widget"; accent: Theme.colors.success }
            }
        }
    }
}
