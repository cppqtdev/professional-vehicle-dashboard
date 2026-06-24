// HomePage.qml
// Home dashboard (clock, shortcuts, weather card) with an in-page 5-day weather
// detail view. Tapping the weather card opens the detail; back returns.

import QtQuick
import QtQuick.Layouts
import App.Theme
import App.Icons
import App.Components
import App.Controllers

Item {
    id: page
    property SystemController controller

    function wIcon(name) {
        switch (name) {
        case "wSun":    return Icons.wSun
        case "wCloud":  return Icons.wCloud
        case "wPartly": return Icons.wPartly
        case "wRain":   return Icons.wRain
        case "wStorm":  return Icons.wStorm
        }
        return Icons.wCloud
    }

    // ---- Shortcut pill ----------------------------------------------------
    component ShortcutPill: Surface {
        id: pill
        property url icon
        property string label
        signal clicked()
        radius: height / 2
        neomorph: true
        pressed: shortcutMouse.pressed
        color: Theme.colors.tile
        scale: shortcutMouse.pressed ? 0.96 : 1.0
        implicitWidth: row.implicitWidth + 44
        implicitHeight: 56

        Behavior on scale {
            NumberAnimation { duration: Theme.motion.fast; easing.type: Easing.OutCubic }
        }

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 12
            AppIcon {
                anchors.verticalCenter: parent.verticalCenter
                source: pill.icon; size: 22; color: Theme.colors.icon
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: pill.label
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.subtitle
                font.weight: Theme.typography.weightMedium
            }
        }
        MouseArea {
            id: shortcutMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: pill.clicked()
        }
    }

    StackLayout {
        anchors.fill: parent
        currentIndex: page.controller.weatherDetailOpen ? 1 : 0

        // ================= Dashboard =================
        Item {
            id: dashboard

            // decorative faint rain
            Item {
                anchors.fill: parent
                clip: true
                Repeater {
                    model: 22
                    delegate: Rectangle {
                        required property int index
                        width: 2
                        height: 150
                        radius: 1
                        rotation: 20
                        opacity: 0.05
                        color: Theme.colors.textSecondary
                        x: (index * 96) % (dashboard.width + 200) - 80
                        y: ((index * 137) % (dashboard.height + 100)) - 60
                    }
                }
            }

            // left: clock + date + shortcuts
            Column {
                anchors.left: parent.left
                anchors.leftMargin: Theme.metrics.paddingLg + 12
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                Text {
                    text: page.controller.time
                    color: Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: 88
                    font.weight: Theme.typography.weightBold
                }
                Text {
                    text: page.controller.date
                    color: Theme.colors.textSecondary
                    font.family: Theme.typography.family
                    font.pixelSize: 24
                    font.weight: Theme.typography.weightMedium
                }
                Row {
                    spacing: 16
                    topPadding: 12
                    ShortcutPill {
                        icon: Icons.home
                        label: "Home"
                        onClicked: page.controller.weatherDetailOpen = false
                    }
                    ShortcutPill { icon: Icons.briefcase; label: "Company" }
                }
            }

            // right: weather card
            Surface {
                id: weatherCard
                anchors.right: parent.right
                anchors.rightMargin: Theme.metrics.paddingLg
                anchors.verticalCenter: parent.verticalCenter
                width: 380
                height: 224
                radius: Theme.metrics.cardRadius
                neomorph: true
                color: Theme.colors.tile

                Item {
                    anchors.fill: parent
                    anchors.margins: 24

                    RowLayout {
                        id: cardHeader
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        Text {
                            Layout.fillWidth: true
                            text: page.controller.city
                            color: Theme.colors.textPrimary
                            font.family: Theme.typography.family
                            font.pixelSize: Theme.typography.subtitle
                            font.weight: Theme.typography.weightBold
                        }
                        AppIcon { source: Icons.more; size: 20; color: Theme.colors.iconMuted }
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        spacing: 4
                        Text {
                            text: page.controller.weatherTemp + "°"
                            color: Theme.colors.textPrimary
                            font.family: Theme.typography.family
                            font.pixelSize: 52
                            font.weight: Theme.typography.weightBold
                        }
                        Text {
                            text: page.controller.weatherCondition
                            color: Theme.colors.textSecondary
                            font.family: Theme.typography.family
                            font.pixelSize: Theme.typography.caption
                        }
                        Text {
                            text: "Chance of Rain: " + page.controller.rainChance + "%"
                            color: Theme.colors.textSecondary
                            font.family: Theme.typography.family
                            font.pixelSize: Theme.typography.caption
                        }
                        Text {
                            text: "Humidity " + page.controller.humidity + "%"
                            color: Theme.colors.textSecondary
                            font.family: Theme.typography.family
                            font.pixelSize: Theme.typography.caption
                        }
                    }

                    Image {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 6
                        width: 116; height: 116
                        source: Icons.wStorm
                        fillMode: Image.PreserveAspectFit
                        smooth: true; mipmap: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: page.controller.weatherDetailOpen = true
                }
            }
        }

        // ================= 5-day detail =================
        Item {
            id: detail

            // top bar
            RowLayout {
                id: detailTop
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.leftMargin: 34
                anchors.rightMargin: 32
                anchors.topMargin: 24
                height: 42
                spacing: 30

                AppIcon {
                    source: Icons.back; size: 24; color: Theme.colors.icon
                    MouseArea {
                        anchors.fill: parent; anchors.margins: -10
                        cursorShape: Qt.PointingHandCursor
                        onClicked: page.controller.weatherDetailOpen = false
                    }
                }
                Text {
                    Layout.fillWidth: true
                    text: page.controller.city
                    color: Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: 29
                    font.weight: Theme.typography.weightMedium
                    verticalAlignment: Text.AlignVCenter
                }
                AppIcon { source: Icons.more; size: 22; color: Theme.colors.icon }
            }

            Item {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: detailTop.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 42

                // current conditions
                Column {
                    id: currentWeather
                    anchors.left: parent.left
                    anchors.leftMargin: 34
                    anchors.top: parent.top
                    spacing: 6
                    Text {
                        text: page.controller.weatherTemp + "°"
                        color: Theme.colors.textPrimary
                        font.family: Theme.typography.family
                        font.pixelSize: 42
                        font.weight: Theme.typography.weightMedium
                    }
                    Text {
                        text: page.controller.weatherCondition
                        color: Theme.colors.textSecondary
                        font.family: Theme.typography.family
                        font.pixelSize: 16
                    }
                    Text {
                        text: "Chance of Rain: " + page.controller.rainChance + "%"
                        color: Theme.colors.textSecondary
                        font.family: Theme.typography.family
                        font.pixelSize: 16
                    }
                }

                Image {
                    anchors.left: currentWeather.left
                    anchors.top: currentWeather.bottom
                    anchors.topMargin: 30
                    width: 118; height: 118
                    source: Icons.wStorm
                    fillMode: Image.PreserveAspectFit
                    smooth: true; mipmap: true
                }

                // 5-day forecast — fixed-width, top-aligned columns
                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 265
                    anchors.right: parent.right
                    anchors.rightMargin: 42
                    anchors.top: parent.top
                    spacing: 38
                    Repeater {
                        model: page.controller.forecast
                        delegate: Column {
                            required property var modelData
                            width: 104
                            spacing: 9

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.day
                                color: Theme.colors.textPrimary
                                font.family: Theme.typography.family
                                font.pixelSize: 17
                                font.weight: Theme.typography.weightMedium
                            }
                            Item {
                                width: parent.width
                                height: 86
                                Image {
                                    anchors.centerIn: parent
                                    width: 64; height: 64
                                    source: page.wIcon(modelData.icon)
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true; mipmap: true
                                }
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.lo + "°/" + modelData.hi + "°"
                                color: Theme.colors.textPrimary
                                font.family: Theme.typography.family
                                font.pixelSize: 22
                                font.weight: Theme.typography.weightMedium
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.cond
                                color: Theme.colors.textSecondary
                                font.family: Theme.typography.family
                                font.pixelSize: 15
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Rain " + modelData.rain + "%"
                                color: Theme.colors.textSecondary
                                font.family: Theme.typography.family
                                font.pixelSize: 15
                            }
                        }
                    }
                }
            }
        }
    }
}
