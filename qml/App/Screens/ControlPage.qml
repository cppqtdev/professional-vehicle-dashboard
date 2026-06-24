// ControlPage.qml
// The vehicle control page: a top tab bar (Control / Energy / Setting), a
// central top-view car, soft-UI control buttons down each side, and a climate
// strip along the bottom. Lives inside AppShell's content area.

import QtQuick
import QtQuick.Layouts
import App.Theme
import App.Icons
import App.Components
import App.Controllers

Item {
    id: page

    property SystemController controller

    // ---- Reusable rows ----------------------------------------------------
    // icon on the left, label to the right
    component LeftRow: RowLayout {
        id: lrow
        property url icon
        property string label
        property bool active: false
        property color accent: Theme.colors.accent
        signal toggled(bool checked)
        spacing: 18

        IconButton {
            iconSource: lrow.icon
            checked: lrow.active
            accentColor: lrow.accent
            onToggled: (c) => lrow.toggled(c)
        }
        Text {
            text: lrow.label
            color: Theme.colors.textPrimary
            font.family: Theme.typography.family
            font.pixelSize: Theme.typography.subtitle
            font.weight: Theme.typography.weightMedium
        }
    }

    // label on the left, icon to the right (right-aligned column)
    component RightRow: RowLayout {
        id: rrow
        property url icon
        property string label
        property bool active: false
        property color accent: Theme.colors.accent
        signal toggled(bool checked)
        spacing: 18
        layoutDirection: Qt.RightToLeft

        IconButton {
            iconSource: rrow.icon
            checked: rrow.active
            accentColor: rrow.accent
            onToggled: (c) => rrow.toggled(c)
        }
        Text {
            text: rrow.label
            color: Theme.colors.textPrimary
            font.family: Theme.typography.family
            font.pixelSize: Theme.typography.subtitle
            font.weight: Theme.typography.weightMedium
        }
    }

    Item {
        anchors.fill: parent
        anchors.leftMargin: Theme.metrics.paddingLg
        anchors.rightMargin: Theme.metrics.paddingLg
        anchors.topMargin: Theme.metrics.paddingMd
        anchors.bottomMargin: Theme.metrics.paddingLg

        // ---- Top: tabs + theme toggle ------------------------------------
        Item {
            id: topRow
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 50

            NavTabBar {
                id: tabs
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                currentIndex: page.controller.controlTab
                onCurrentIndexChanged: page.controller.controlTab = currentIndex

                NavTabButton { text: "Control" }
                NavTabButton { text: "Energy" }
                NavTabButton { text: "Setting" }
            }

            ThemeToggle {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // ---- Tab content --------------------------------------------------
        StackLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: topRow.bottom
            anchors.bottom: parent.bottom
            anchors.topMargin: Theme.metrics.paddingMd
            currentIndex: tabs.currentIndex

            // --- Control ---
            Item {
                id: controlTab

                ClimateBar {
                    id: climate
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    leftTemp: page.controller.driverTemp
                    rightTemp: page.controller.passengerTemp
                    onLeftTempStep: (d) => page.controller.driverTemp =
                                    Math.max(16, Math.min(30, page.controller.driverTemp + d))
                    onRightTempStep: (d) => page.controller.passengerTemp =
                                     Math.max(16, Math.min(30, page.controller.passengerTemp + d))
                }

                Item {
                    id: middle
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: climate.top
                    anchors.bottomMargin: Theme.metrics.paddingMd

                    // central car (horizontal top view)
                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: Math.min(parent.width * 0.46, 580)
                        height: width * 0.47
                        source: Icons.carTopViewH
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                    }

                    // left controls
                    ColumnLayout {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 26

                        LeftRow {
                            icon: Icons.lock
                            label: "Central lock"
                            accent: Theme.colors.accent
                            active: page.controller.centralLock
                            onToggled: (c) => page.controller.centralLock = c
                        }
                        LeftRow {
                            icon: Icons.fuel
                            label: "Fuel tank lock"
                            active: page.controller.fuelTankLock
                            onToggled: (c) => page.controller.fuelTankLock = c
                        }
                        LeftRow {
                            icon: Icons.trunk
                            label: "Trunk"
                            active: page.controller.trunkOpen
                            onToggled: (c) => page.controller.trunkOpen = c
                        }
                    }

                    // right controls
                    ColumnLayout {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 26

                        RightRow {
                            icon: Icons.infinity
                            label: "Hybrid mode"
                            accent: Theme.colors.success
                            active: page.controller.hybridMode
                            onToggled: (c) => page.controller.hybridMode = c
                            Layout.alignment: Qt.AlignRight
                        }
                        RightRow {
                            icon: Icons.bulb
                            label: "Light control"
                            active: page.controller.lightControl
                            onToggled: (c) => page.controller.lightControl = c
                            Layout.alignment: Qt.AlignRight
                        }
                        RightRow {
                            icon: Icons.warning
                            label: "Special road"
                            active: page.controller.specialRoad
                            onToggled: (c) => page.controller.specialRoad = c
                            Layout.alignment: Qt.AlignRight
                        }
                    }
                }
            }

            // --- Energy ---
            EnergyView { controller: page.controller }

            // --- Setting ---
            SettingsView { controller: page.controller }
        }
    }
}
