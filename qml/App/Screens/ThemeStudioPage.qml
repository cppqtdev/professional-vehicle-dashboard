import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import App.Theme
import App.Icons
import App.Components
import App.Controllers

Control {
    id: page
    property SystemController controller

    function previewTextureMode() {
        return page.controller.homeTexture === "weather"
                ? page.controller.weatherTexture
                : page.controller.homeTexture
    }

    component SectionCard: Surface {
        id: card
        default property alias content: body.data

        radius: Theme.metrics.cardRadius
        color: Theme.colors.tile
        neomorph: true

        ColumnLayout {
            id: body
            anchors.fill: parent
            anchors.margins: 20
            spacing: 14
        }
    }

    component ModeButton: Surface {
        id: mode
        property string title
        property url icon
        property bool selected: false
        signal picked()

        radius: 18
        color: selected ? Theme.colors.accent : Theme.colors.surfaceVariant
        neomorph: true
        pressed: mouse.pressed || selected
        implicitHeight: 62

        Row {
            anchors.centerIn: parent
            spacing: 12
            AppIcon {
                anchors.verticalCenter: parent.verticalCenter
                source: mode.icon
                size: 24
                color: mode.selected ? Theme.colors.onaccent : Theme.colors.icon
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: mode.title
                color: mode.selected ? Theme.colors.onaccent : Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.subtitle
                font.weight: Theme.typography.weightMedium
            }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: mode.picked()
        }
    }

    component AccentCard: Surface {
        id: accent
        property string title
        property color swatchColor
        property bool selected: false
        signal picked()

        radius: 18
        color: Theme.colors.surfaceVariant
        neomorph: true
        pressed: mouse.pressed || selected
        implicitHeight: 72

        RowLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 14

            Rectangle {
                Layout.alignment: Qt.AlignVCenter
                width: 36
                height: 36
                radius: 18
                color: accent.swatchColor
                border.width: accent.selected ? 3 : 0
                border.color: Theme.colors.textPrimary
            }

            Text {
                Layout.fillWidth: true
                text: accent.title
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.subtitle
                font.weight: Theme.typography.weightMedium
                elide: Text.ElideRight
            }

        }

        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 12
            width: 9
            height: 9
            radius: 4.5
            visible: accent.selected
            color: Theme.colors.success
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: accent.picked()
        }
    }

    component TextureCard: Surface {
        id: textureCard
        property string title
        property string textureMode
        property bool selected: false
        signal picked()

        radius: 18
        color: selected ? Theme.colors.surfaceVariant : Theme.colors.tile
        neomorph: true
        pressed: mouse.pressed || selected
        implicitHeight: 122

        Rectangle {
            id: textureMask
            anchors.fill: parent
            anchors.margins: 1
            radius: textureCard.radius
            color: "white"
            antialiasing: true
            visible: false
            layer.enabled: true
            layer.smooth: true
        }

        Item {
            anchors.fill: parent
            anchors.margins: 1
            layer.enabled: true
            layer.smooth: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: textureMask
            }

            WeatherTexture {
                anchors.fill: parent
                mode: textureCard.textureMode === "weather" ? page.controller.weatherTexture : textureCard.textureMode
                visible: textureCard.textureMode !== "none"
                opacity: Theme.dark ? 0.34 : 0.16
            }

            Rectangle {
                anchors.fill: parent
                color: Theme.dark ? Qt.rgba(0.05, 0.06, 0.08, 0.26)
                                  : Qt.rgba(1, 1, 1, 0.34)
            }
        }

        Text {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 16
            text: textureCard.title
            color: Theme.colors.textPrimary
            font.family: Theme.typography.family
            font.pixelSize: Theme.typography.subtitle
            font.weight: Theme.typography.weightBold
        }

        Text {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 16
            text: textureCard.selected ? "Active" : "Tap to apply"
            color: textureCard.selected ? Theme.colors.success : Theme.colors.textSecondary
            font.family: Theme.typography.family
            font.pixelSize: Theme.typography.caption
            font.weight: textureCard.selected ? Theme.typography.weightMedium : Theme.typography.weightRegular
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: textureCard.picked()
        }
    }

    contentItem: Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width
        contentHeight: studioLayout.implicitHeight + 28
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Control {
            width: page.width
            padding: 30
            topPadding: 20
            bottomPadding: 20

            contentItem: ColumnLayout {
                id: studioLayout
                spacing: Theme.metrics.spacing

                Text {
                    Layout.fillWidth: true
                    text: "Theme Studio"
                    color: Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: 34
                    font.weight: Theme.typography.weightBold
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 360
                    spacing: Theme.metrics.spacing

                    SectionCard {
                        Layout.preferredWidth: Math.min(520, Math.max(420, (studioLayout.width - Theme.metrics.spacing) * 0.42))
                        Layout.fillHeight: true

                        Surface {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: Theme.metrics.cardRadius
                            color: Theme.colors.surface
                            neomorph: true

                            Rectangle {
                                id: homePreviewMask
                                anchors.fill: parent
                                anchors.margins: 1
                                radius: Theme.metrics.cardRadius
                                color: "white"
                                antialiasing: true
                                visible: false
                                layer.enabled: true
                                layer.smooth: true
                            }

                            Item {
                                anchors.fill: parent
                                anchors.margins: 1
                                layer.enabled: true
                                layer.smooth: true
                                layer.effect: MultiEffect {
                                    maskEnabled: true
                                    maskSource: homePreviewMask
                                }

                                WeatherTexture {
                                    anchors.fill: parent
                                    mode: page.previewTextureMode()
                                    visible: page.controller.textureEnabled && page.controller.homeTexture !== "none"
                                }
                            }

                            Column {
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.margins: 22
                                spacing: 6
                                Text { text: "Home preview"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.subtitle; font.weight: Theme.typography.weightBold }
                                Text { text: page.controller.themePreset + " • " + (Theme.dark ? "Dark" : "Light"); color: Theme.colors.textSecondary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.caption }
                            }

                            Surface {
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.margins: 20
                                width: 176
                                height: 92
                                radius: 18
                                color: Theme.colors.tile
                                neomorph: true

                                Row {
                                    anchors.centerIn: parent
                                    spacing: 12
                                    AppIcon { anchors.verticalCenter: parent.verticalCenter; source: Icons.nav; size: 28; color: Theme.colors.accent }
                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 2
                                        Text { text: page.controller.time; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 28; font.weight: Theme.typography.weightBold }
                                        Text { text: page.controller.date; color: Theme.colors.textSecondary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.caption }
                                    }
                                }
                            }
                        }
                    }

                    SectionCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.colors.surfaceVariant

                        Text { Layout.fillWidth: true; text: "System controls"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 24; font.weight: Theme.typography.weightBold }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            ModeButton { Layout.fillWidth: true; title: "Light"; icon: Icons.sun; selected: !Theme.dark; onPicked: appBackend.darkTheme = false }
                            ModeButton { Layout.fillWidth: true; title: "Dark"; icon: Icons.moon; selected: Theme.dark; onPicked: appBackend.darkTheme = true }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Text { Layout.fillWidth: true; text: "Home texture overlay"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.caption }
                            SwitchControl { checked: page.controller.textureEnabled; onToggled: (c) => appBackend.textureEnabled = c }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Text { Layout.fillWidth: true; text: "Weather-aware texture"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.caption }
                            SwitchControl { checked: page.controller.homeTexture === "weather"; onToggled: (c) => appBackend.homeTexture = c ? "weather" : "clear" }
                        }
                    }
                }

                SectionCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 260

                    Text {
                        Layout.fillWidth: true
                        text: "Accent presets"
                        color: Theme.colors.textPrimary
                        font.family: Theme.typography.family
                        font.pixelSize: 24
                        font.weight: Theme.typography.weightBold
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        columns: 2
                        rowSpacing: 12
                        columnSpacing: 12

                        AccentCard { Layout.fillWidth: true; Layout.preferredHeight: 72; title: "Ambient Indigo"; swatchColor: "#5B5CF0"; selected: page.controller.themePreset === "Ambient Indigo"; onPicked: appBackend.themePreset = "Ambient Indigo" }
                        AccentCard { Layout.fillWidth: true; Layout.preferredHeight: 72; title: "Eco Green"; swatchColor: "#06D982"; selected: page.controller.themePreset === "Eco Green"; onPicked: appBackend.themePreset = "Eco Green" }
                        AccentCard { Layout.fillWidth: true; Layout.preferredHeight: 72; title: "Alert Red"; swatchColor: "#FF4338"; selected: page.controller.themePreset === "Alert Red"; onPicked: appBackend.themePreset = "Alert Red" }
                        AccentCard { Layout.fillWidth: true; Layout.preferredHeight: 72; title: "Soft Surface"; swatchColor: Theme.colors.surface; selected: page.controller.themePreset === "Soft Surface"; onPicked: appBackend.themePreset = "Soft Surface" }
                    }
                }

                SectionCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 460

                    Text {
                        Layout.fillWidth: true
                        text: "Home screen textures"
                        color: Theme.colors.textPrimary
                        font.family: Theme.typography.family
                        font.pixelSize: 24
                        font.weight: Theme.typography.weightBold
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        columns: 3
                        rowSpacing: 14
                        columnSpacing: 14

                        TextureCard { Layout.fillWidth: true; Layout.preferredHeight: 130; title: "Weather"; textureMode: "weather"; selected: page.controller.homeTexture === "weather"; onPicked: appBackend.homeTexture = "weather" }
                        TextureCard { Layout.fillWidth: true; Layout.preferredHeight: 130; title: "Clear"; textureMode: "clear"; selected: page.controller.homeTexture === "clear"; onPicked: appBackend.homeTexture = "clear" }
                        TextureCard { Layout.fillWidth: true; Layout.preferredHeight: 130; title: "Cloud"; textureMode: "cloud"; selected: page.controller.homeTexture === "cloud"; onPicked: appBackend.homeTexture = "cloud" }
                        TextureCard { Layout.fillWidth: true; Layout.preferredHeight: 130; title: "Mist"; textureMode: "mist"; selected: page.controller.homeTexture === "mist"; onPicked: appBackend.homeTexture = "mist" }
                        TextureCard { Layout.fillWidth: true; Layout.preferredHeight: 130; title: "Rain"; textureMode: "rain"; selected: page.controller.homeTexture === "rain"; onPicked: appBackend.homeTexture = "rain" }
                        TextureCard { Layout.fillWidth: true; Layout.preferredHeight: 130; title: "Storm"; textureMode: "storm"; selected: page.controller.homeTexture === "storm"; onPicked: appBackend.homeTexture = "storm" }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 6
                }
            }
        }
    }
}
