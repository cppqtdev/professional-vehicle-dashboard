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

    component StatusTile: Control {
        id: tile
        property url icon
        property string title
        property string value
        property color accent: Theme.colors.accent
        signal clicked()

        padding: 18

        background: Surface {
            radius: Theme.metrics.cardRadius
            color: Theme.colors.tile
            neomorph: true
            pressed: tileMouse.pressed
        }

        contentItem: RowLayout {
            spacing: 16

            AppIcon {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                source: tile.icon
                size: 34
                color: tile.accent
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 3

                Text { text: tile.title; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.subtitle; font.weight: Theme.typography.weightBold }
                Text { text: tile.value; color: Theme.colors.textSecondary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.caption }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        MouseArea {
            id: tileMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: tile.clicked()
        }
    }

    contentItem: RowLayout {
        spacing: Theme.metrics.spacing

        Surface {
            Layout.preferredWidth: 430
            Layout.fillHeight: true
            radius: Theme.metrics.cardRadius
            color: Theme.colors.tile
            neomorph: true

            Image {
                anchors.centerIn: parent
                width: parent.width * 0.86
                height: parent.height * 0.78
                source: Icons.carTopView
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 20
                text: "Vehicle status"
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: 28
                font.weight: Theme.typography.weightBold
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            rowSpacing: Theme.metrics.spacing
            columnSpacing: Theme.metrics.spacing
            StatusTile { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.lock; title: "Doors"; value: page.controller.centralLock ? "All locked" : "Unlocked"; accent: page.controller.centralLock ? Theme.colors.success : Theme.colors.danger; onClicked: vehicleControls.toggleCentralLock() }
            StatusTile { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.trunk; title: "Trunk"; value: page.controller.trunkOpen ? "Open" : "Closed"; accent: page.controller.trunkOpen ? Theme.colors.danger : Theme.colors.success; onClicked: vehicleControls.toggleTrunk() }
            StatusTile { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.bulb; title: "Lights"; value: page.controller.lightControl ? "On" : "Auto"; accent: page.controller.lightControl ? Theme.colors.success : Theme.colors.accent; onClicked: vehicleControls.toggleLightControl() }
            StatusTile { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.warning; title: "Warnings"; value: page.controller.windowsClosed ? "No critical alerts" : "Window open"; accent: page.controller.windowsClosed ? Theme.colors.success : Theme.colors.danger; onClicked: vehicleControls.windowsClosed = !vehicleControls.windowsClosed }
            StatusTile { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.road; title: "Tire pressure"; value: page.controller.tirePressureWarning >= 0 ? "Check tire " + (page.controller.tirePressureWarning + 1) : "36 / 36 / 35 / 36 PSI"; accent: page.controller.tirePressureWarning >= 0 ? Theme.colors.danger : Theme.colors.accent; onClicked: vehicleControls.tirePressureWarning = page.controller.tirePressureWarning >= 0 ? -1 : 2 }
            StatusTile { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.info; title: "Service"; value: page.controller.vehicleMoving ? "Inspect after trip" : "Due in 2,400 km"; accent: Theme.colors.iconMuted; onClicked: vehicleControls.vehicleMoving = !vehicleControls.vehicleMoving }
        }
    }
}
