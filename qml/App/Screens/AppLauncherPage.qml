// AppLauncherPage.qml
// Full feature launcher opened by the sidebar menu.

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
    padding: 30

    component LaunchCard: Control {
        id: card
        property url icon
        property string title
        property string subtitle
        property int targetIndex: 0
        property color accent: Theme.colors.accent
        padding: 18

        background: Surface {
            radius: Theme.metrics.cardRadius
            color: Theme.colors.tile
            neomorph: true
            pressed: launchMouse.pressed
        }

        contentItem: RowLayout {
            spacing: 18

            AppIcon {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                source: card.icon
                size: 34
                color: card.accent
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 3

                Text {
                    text: card.title
                    color: Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.subtitle
                    font.weight: Theme.typography.weightBold
                }

                Text {
                    text: card.subtitle
                    color: Theme.colors.textSecondary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.caption
                    wrapMode: Text.WordWrap
                }
            }
        }

        MouseArea {
            id: launchMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: page.controller.navIndex = card.targetIndex
        }
    }

    contentItem: ColumnLayout {
        spacing: Theme.metrics.spacing

        RowLayout {
            Layout.fillWidth: true
            Text {
                Layout.fillWidth: true
                text: "Apps & vehicle controls"
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: 30
                font.weight: Theme.typography.weightBold
            }
            Text {
                text: page.controller.date
                color: Theme.colors.textSecondary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.subtitle
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 3
            rowSpacing: Theme.metrics.spacing
            columnSpacing: Theme.metrics.spacing

            LaunchCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.hotspot; title: "Quick Settings"; subtitle: "Connectivity, brightness, volume"; targetIndex: 4; accent: Theme.colors.accent }
            LaunchCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.nav; title: "Navigation"; subtitle: "Routes, ETA, chargers, parking"; targetIndex: 5; accent: Theme.colors.accent }
            LaunchCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.car; title: "Vehicle Status"; subtitle: "Doors, windows, tires, service"; targetIndex: 6; accent: Theme.colors.success }
            LaunchCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.fan; title: "Climate"; subtitle: "Airflow, seats, zones, defrost"; targetIndex: 7; accent: Theme.colors.accent }
            LaunchCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.person; title: "Profiles"; subtitle: "Driver presets and preferences"; targetIndex: 8; accent: Theme.colors.success }
            LaunchCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.notification; title: "Notifications"; subtitle: "Vehicle, calls, weather, service"; targetIndex: 9; accent: Theme.colors.danger }
            LaunchCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.volume; title: "Voice Assistant"; subtitle: "Hands-free commands"; targetIndex: 10; accent: Theme.colors.accent }
            LaunchCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.play; title: "Parked Mode"; subtitle: "Media and apps while parked"; targetIndex: 11; accent: Theme.colors.success }
            LaunchCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.shield; title: "Safety"; subtitle: "Driving lockouts and assist states"; targetIndex: 12; accent: Theme.colors.danger }
            LaunchCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.brightness; title: "Theme Studio"; subtitle: "Day/night, accents, textures"; targetIndex: 13; accent: Theme.colors.accent }
        }
    }
}
