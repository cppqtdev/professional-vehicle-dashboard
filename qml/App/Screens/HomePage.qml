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
    readonly property int homeWidgetWidth: 460
    readonly property int homeWidgetHeight: 280

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

    component WeatherHomeWidget: Surface {
        id: widget
        property SystemController controller
        property url iconSource
        signal opened()

        width: page.homeWidgetWidth
        height: page.homeWidgetHeight
        radius: Theme.metrics.cardRadius
        neomorph: true
        color: Theme.colors.tile

        Item {
            anchors.fill: parent
            anchors.margins: 24

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                Text {
                    Layout.fillWidth: true
                    text: widget.controller.city
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
                    text: widget.controller.weatherTemp + "°"
                    color: Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: 52
                    font.weight: Theme.typography.weightBold
                }
                Text {
                    text: widget.controller.weatherCondition
                    color: Theme.colors.textSecondary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.caption
                }
                Text {
                    text: "Chance of Rain: " + widget.controller.rainChance + "%"
                    color: Theme.colors.textSecondary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.caption
                }
                Text {
                    text: "Humidity " + widget.controller.humidity + "%"
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
                source: widget.iconSource
                fillMode: Image.PreserveAspectFit
                smooth: true; mipmap: true
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: widget.opened()
        }
    }

    component MusicHomeWidget: Surface {
        id: widget
        property SystemController controller

        width: page.homeWidgetWidth
        height: page.homeWidgetHeight
        radius: Theme.metrics.cardRadius
        color: Theme.colors.mediaBackground
        elevated: true
        clip: true

        Rectangle {
            width: 360
            height: 360
            radius: width / 2
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: -70
            color: Theme.colors.mediaGlow
            opacity: 0.55
        }
        Image {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 26
            width: 142
            height: 142
            source: Icons.albumCover
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            opacity: 0.92
        }
        Column {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 30
            anchors.topMargin: 30
            spacing: 8
            Text {
                text: widget.controller.trackTitle
                color: Theme.colors.mediaText
                font.family: Theme.typography.family
                font.pixelSize: 34
                font.weight: Theme.typography.weightMedium
            }
            Text {
                text: widget.controller.trackArtist
                color: Theme.colors.mediaSecondary
                font.family: Theme.typography.family
                font.pixelSize: 22
            }
        }

        Rectangle {
            id: musicTrack
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 30
            anchors.rightMargin: 30
            anchors.bottom: controls.top
            anchors.bottomMargin: 28
            height: 4
            radius: 2
            color: Theme.colors.mediaTrack
            Rectangle {
                width: parent.width * widget.controller.trackProgress
                height: parent.height
                radius: parent.radius
                color: Theme.colors.mediaText
            }
            Rectangle {
                width: 10
                height: 10
                radius: 5
                x: parent.width * widget.controller.trackProgress - width / 2
                anchors.verticalCenter: parent.verticalCenter
                color: Theme.colors.mediaText
            }
        }

        Row {
            id: controls
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 30
            anchors.bottomMargin: 30
            spacing: 28
            AppIcon { source: Icons.previous; size: 32; color: Theme.colors.mediaText }
            AppIcon { source: widget.controller.playing ? Icons.pause : Icons.play; size: 38; color: Theme.colors.mediaText }
            AppIcon { source: Icons.next; size: 32; color: Theme.colors.mediaText }
        }

        Text {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 30
            anchors.bottomMargin: 34
            text: widget.controller.trackElapsed + " / " + widget.controller.trackDuration
            color: Theme.colors.mediaSecondary
            font.family: Theme.typography.family
            font.pixelSize: Theme.typography.caption
        }
    }

    component EnergyHomeWidget: Surface {
        id: widget
        property SystemController controller

        width: page.homeWidgetWidth
        height: page.homeWidgetHeight
        radius: Theme.metrics.cardRadius
        neomorph: true
        color: Theme.colors.tile

        Column {
            anchors.fill: parent
            anchors.margins: 26
            spacing: 16
            Row {
                spacing: 12
                AppIcon { source: Icons.battery; size: 32; color: Theme.colors.success }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Battery"
                    color: Theme.colors.textSecondary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.subtitle
                }
            }
            Text {
                text: Math.round(widget.controller.batteryLevel * 100) + "%"
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: 52
                font.weight: Theme.typography.weightBold
            }
            Rectangle {
                width: parent.width
                height: 16
                radius: 8
                color: Theme.colors.sliderTrack
                Rectangle {
                    width: parent.width * widget.controller.batteryLevel
                    height: parent.height
                    radius: parent.radius
                    color: Theme.colors.success
                }
            }
            Text {
                text: widget.controller.rangeKm + " km range"
                color: Theme.colors.textSecondary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.subtitle
            }
        }
    }

    component QuickHomeWidget: Surface {
        id: widget
        property SystemController controller

        width: page.homeWidgetWidth
        height: page.homeWidgetHeight
        radius: Theme.metrics.cardRadius
        neomorph: true
        color: Theme.colors.tile

        GridLayout {
            anchors.fill: parent
            anchors.margins: 24
            columns: 2
            rowSpacing: 18
            columnSpacing: 18

            Repeater {
                model: [
                    { icon: Icons.cellular, label: "Cellular", active: widget.controller.cellularOn, color: Theme.colors.accent },
                    { icon: Icons.bluetooth, label: "Bluetooth", active: widget.controller.bluetoothOn, color: Theme.colors.accent },
                    { icon: Icons.hotspot, label: "Hotspot", active: widget.controller.hotspotOn, color: Theme.colors.accent },
                    { icon: Icons.wRain, label: "Texture", active: widget.controller.textureEnabled, color: Theme.colors.success }
                ]
                delegate: Surface {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 16
                    color: modelData.active ? modelData.color : Theme.colors.surfaceVariant
                    neomorph: true
                    Row {
                        anchors.centerIn: parent
                        spacing: 10
                        AppIcon {
                            anchors.verticalCenter: parent.verticalCenter
                            source: modelData.icon
                            size: 24
                            color: modelData.active ? Theme.colors.onaccent : Theme.colors.icon
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.label
                            color: modelData.active ? Theme.colors.onaccent : Theme.colors.textSecondary
                            font.family: Theme.typography.family
                            font.pixelSize: Theme.typography.caption
                            font.weight: Theme.typography.weightMedium
                        }
                    }
                }
            }
        }
    }

    component NavigationHomeWidget: Surface {
        id: widget
        width: page.homeWidgetWidth
        height: page.homeWidgetHeight
        radius: Theme.metrics.cardRadius
        neomorph: true
        color: Theme.colors.tile

        Item {
            anchors.fill: parent
            anchors.margins: 24
            Column {
                anchors.left: parent.left
                anchors.top: parent.top
                spacing: 8
                Row {
                    spacing: 12
                    AppIcon { source: Icons.nav; size: 32; color: Theme.colors.accent }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Navigation"
                        color: Theme.colors.textPrimary
                        font.family: Theme.typography.family
                        font.pixelSize: Theme.typography.subtitle
                        font.weight: Theme.typography.weightBold
                    }
                }
                Text {
                    text: "Home via Shennan Ave"
                    color: Theme.colors.textSecondary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.caption
                }
            }
            Row {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                spacing: 28
                Column {
                    spacing: 2
                    Text { text: "18 min"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 32; font.weight: Theme.typography.weightBold }
                    Text { text: "ETA 00:35"; color: Theme.colors.textSecondary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.caption }
                }
                Column {
                    spacing: 2
                    Text { text: "7.8 km"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 32; font.weight: Theme.typography.weightBold }
                    Text { text: "Light traffic"; color: Theme.colors.textSecondary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.caption }
                }
            }
            AppIcon {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                source: Icons.road
                size: 82
                color: Theme.colors.accent
                opacity: 0.28
            }
        }
    }

    component ClimateHomeWidget: Surface {
        id: widget
        property SystemController controller
        width: page.homeWidgetWidth
        height: page.homeWidgetHeight
        radius: Theme.metrics.cardRadius
        neomorph: true
        color: Theme.colors.tile

        Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16
            Row {
                spacing: 12
                AppIcon { source: Icons.fan; size: 32; color: Theme.colors.accent }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Climate"
                    color: Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.subtitle
                    font.weight: Theme.typography.weightBold
                }
            }
            Row {
                spacing: 36
                Column {
                    Text { text: widget.controller.driverTemp.toFixed(1) + "°"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 40; font.weight: Theme.typography.weightBold }
                    Text { text: "Driver"; color: Theme.colors.textSecondary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.caption }
                }
                Column {
                    Text { text: widget.controller.passengerTemp.toFixed(1) + "°"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 40; font.weight: Theme.typography.weightBold }
                    Text { text: "Passenger"; color: Theme.colors.textSecondary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.caption }
                }
            }
            Row {
                spacing: 14
                AppIcon { source: Icons.seat; size: 24; color: Theme.colors.iconMuted }
                AppIcon { source: Icons.defrost; size: 24; color: Theme.colors.iconMuted }
                AppIcon { source: Icons.fan; size: 24; color: Theme.colors.success }
            }
        }
    }

    component TiresHomeWidget: Surface {
        id: widget
        width: page.homeWidgetWidth
        height: page.homeWidgetHeight
        radius: Theme.metrics.cardRadius
        neomorph: true
        color: Theme.colors.tile

        Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 18
            Row {
                spacing: 12
                AppIcon { source: Icons.warning; size: 32; color: Theme.colors.success }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Vehicle Status"
                    color: Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.subtitle
                    font.weight: Theme.typography.weightBold
                }
            }
            GridLayout {
                width: parent.width
                columns: 2
                rowSpacing: 12
                columnSpacing: 22
                Repeater {
                    model: ["36 PSI", "36 PSI", "35 PSI", "36 PSI"]
                    delegate: Text {
                        required property string modelData
                        text: modelData
                        color: Theme.colors.textPrimary
                        font.family: Theme.typography.family
                        font.pixelSize: 24
                        font.weight: Theme.typography.weightMedium
                    }
                }
            }
            Text {
                text: "All doors locked • Service in 2,400 km"
                color: Theme.colors.textSecondary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.caption
            }
        }
    }

    component TripHomeWidget: Surface {
        id: widget
        width: page.homeWidgetWidth
        height: page.homeWidgetHeight
        radius: Theme.metrics.cardRadius
        neomorph: true
        color: Theme.colors.tile

        Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16
            Row {
                spacing: 12
                AppIcon { source: Icons.road; size: 32; color: Theme.colors.accent }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Trip"
                    color: Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.subtitle
                    font.weight: Theme.typography.weightBold
                }
            }
            Row {
                spacing: 26
                Column {
                    Text { text: "128 km"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 34; font.weight: Theme.typography.weightBold }
                    Text { text: "Today"; color: Theme.colors.textSecondary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.caption }
                }
                Column {
                    Text { text: "16.2"; color: Theme.colors.textPrimary; font.family: Theme.typography.family; font.pixelSize: 34; font.weight: Theme.typography.weightBold }
                    Text { text: "kWh / 100 km"; color: Theme.colors.textSecondary; font.family: Theme.typography.family; font.pixelSize: Theme.typography.caption }
                }
            }
            Text {
                text: "Avg speed 42 km/h • 3 stops"
                color: Theme.colors.textSecondary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.caption
            }
        }
    }

    StackLayout {
        anchors.fill: parent
        currentIndex: page.controller.weatherDetailOpen ? 1 : 0

        // ================= Dashboard =================
        Item {
            id: dashboard

            WeatherTexture {
                anchors.fill: parent
                mode: page.controller.weatherTexture
                visible: page.controller.textureEnabled
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

            // right: customizable widget card
            Loader {
                id: homeWidgetLoader
                anchors.right: parent.right
                anchors.rightMargin: Theme.metrics.paddingLg
                anchors.verticalCenter: parent.verticalCenter
                width: page.homeWidgetWidth
                height: page.homeWidgetHeight
                sourceComponent: page.controller.homeWidget === "music" ? musicWidgetComponent
                               : page.controller.homeWidget === "energy" ? energyWidgetComponent
                               : page.controller.homeWidget === "quick" ? quickWidgetComponent
                               : page.controller.homeWidget === "navigation" ? navigationWidgetComponent
                               : page.controller.homeWidget === "climate" ? climateWidgetComponent
                               : page.controller.homeWidget === "tires" ? tiresWidgetComponent
                               : page.controller.homeWidget === "trip" ? tripWidgetComponent
                               : weatherWidgetComponent
            }

            Component {
                id: weatherWidgetComponent
                WeatherHomeWidget {
                    controller: page.controller
                    iconSource: page.wIcon(page.controller.weatherIcon)
                    onOpened: page.controller.weatherDetailOpen = true
                }
            }
            Component {
                id: musicWidgetComponent
                MusicHomeWidget { controller: page.controller }
            }
            Component {
                id: energyWidgetComponent
                EnergyHomeWidget { controller: page.controller }
            }
            Component {
                id: quickWidgetComponent
                QuickHomeWidget { controller: page.controller }
            }
            Component {
                id: navigationWidgetComponent
                NavigationHomeWidget {}
            }
            Component {
                id: climateWidgetComponent
                ClimateHomeWidget { controller: page.controller }
            }
            Component {
                id: tiresWidgetComponent
                TiresHomeWidget {}
            }
            Component {
                id: tripWidgetComponent
                TripHomeWidget {}
            }
        }

        // ================= 5-day detail =================
        Item {
            id: detail

            WeatherTexture {
                anchors.fill: parent
                mode: page.controller.weatherTexture
                visible: page.controller.textureEnabled
                opacity: Theme.dark ? 0.32 : 0.12
            }

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
                    source: page.wIcon(page.controller.weatherIcon)
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
