// HomePage.qml
// Home dashboard (clock, shortcuts, weather card) with an in-page 5-day weather
// detail view. Tapping the weather card opens the detail; back returns.

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import App.Theme
import App.Icons
import App.Components
import App.Controllers

Item {
    id: page
    property SystemController controller
    readonly property int homeWidgetMaxWidth: 460
    readonly property int homeWidgetMinWidth: 320
    readonly property int homeWidgetWidth: Math.max(homeWidgetMinWidth,
                                                    Math.min(homeWidgetMaxWidth, width - 604))
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

    function widgetComponent(name) {
        switch (name) {
        case "music": return musicWidgetComponent
        case "energy": return energyWidgetComponent
        case "quick": return quickWidgetComponent
        case "navigation": return navigationWidgetComponent
        case "climate": return climateWidgetComponent
        case "tires": return tiresWidgetComponent
        case "trip": return tripWidgetComponent
        case "calendar": return calendarWidgetComponent
        case "calls": return callsWidgetComponent
        default: return weatherWidgetComponent
        }
    }

    function widgetLabel(name) {
        switch (name) {
        case "music": return "Music"
        case "energy": return "Energy"
        case "quick": return "Quick"
        case "navigation": return "Navigation"
        case "climate": return "Climate"
        case "tires": return "Vehicle"
        case "trip": return "Trip"
        case "calendar": return "Calendar"
        case "calls": return "Calls"
        default: return "Weather"
        }
    }

    function homeTextureMode() {
        return page.controller.homeTexture === "weather"
               ? page.controller.weatherTexture
               : page.controller.homeTexture
    }

    readonly property var availableWidgets: [
        "weather", "music", "navigation", "energy", "quick",
        "climate", "tires", "trip", "calendar", "calls"
    ]

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

    component EditorPill: Surface {
        id: pill
        property string label
        signal clicked()
        radius: height / 2
        neomorph: true
        pressed: mouse.pressed
        color: Theme.colors.tile
        implicitHeight: 36
        implicitWidth: textItem.implicitWidth + 28

        Text {
            id: textItem
            anchors.centerIn: parent
            text: pill.label
            color: Theme.colors.textPrimary
            font.family: Theme.typography.family
            font.pixelSize: 14
            font.weight: Theme.typography.weightMedium
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: pill.clicked()
        }
    }

    component WidgetSlot: Control {
        id: slot
        property int slotIndex: 0
        property string widgetKey: "weather"
        property string widgetSize: "small"
        property bool editorOpen: false

        width: parent ? parent.width : page.homeWidgetWidth
        height: widgetSize === "large" ? page.homeWidgetHeight : 112
        clip: false

        Loader {
            anchors.fill: parent
            sourceComponent: page.widgetComponent(slot.widgetKey)
        }

        Rectangle {
            anchors.fill: parent
            radius: Theme.metrics.cardRadius
            color: Theme.colors.surface
            opacity: slot.editorOpen ? 0.88 : 0
            visible: opacity > 0
            Behavior on opacity { NumberAnimation { duration: Theme.motion.fast } }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 10
            visible: slot.editorOpen

            Text {
                Layout.fillWidth: true
                text: "Slot " + (slot.slotIndex + 1) + " • " + page.widgetLabel(slot.widgetKey)
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.subtitle
                font.weight: Theme.typography.weightBold
                elide: Text.ElideRight
            }

            Row {
                spacing: 8
                EditorPill {
                    label: slot.widgetSize === "large" ? "Large" : "Small"
                    onClicked: appBackend.setHomeWidgetSizeAt(slot.slotIndex, slot.widgetSize === "large" ? "small" : "large")
                }
                EditorPill {
                    label: "Up"
                    onClicked: appBackend.reorderHomeWidget(slot.slotIndex, Math.max(0, slot.slotIndex - 1))
                }
                EditorPill {
                    label: "Down"
                    onClicked: appBackend.reorderHomeWidget(slot.slotIndex, Math.min(page.controller.homeWidgets.length - 1, slot.slotIndex + 1))
                }
            }

            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                contentWidth: widgetPicker.width
                contentHeight: height
                flickableDirection: Flickable.HorizontalFlick
                boundsBehavior: Flickable.StopAtBounds

                Row {
                    id: widgetPicker
                    height: parent.height
                    spacing: 8
                    Repeater {
                        model: page.availableWidgets
                        delegate: EditorPill {
                            required property string modelData
                            label: page.widgetLabel(modelData)
                            onClicked: appBackend.setHomeWidgetAt(slot.slotIndex, modelData)
                        }
                    }
                }
            }
        }
    }

    component WeatherHomeWidget: Surface {
        id: widget
        property SystemController controller
        property url iconSource
        signal opened()

        width: parent ? parent.width : page.homeWidgetWidth
        height: parent ? parent.height : page.homeWidgetHeight
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

        width: parent ? parent.width : page.homeWidgetWidth
        height: parent ? parent.height : page.homeWidgetHeight
        radius: Theme.metrics.cardRadius
        color: Theme.colors.mediaBackground
        neomorph: true
        clip: false

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: widget.controller.navIndex = 1
        }

        Item {
            anchors.fill: parent

            Rectangle {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: parent.width * 0.48
                topRightRadius: widget.radius
                bottomRightRadius: widget.radius
                color: Theme.colors.mediaGlow
                opacity: 0.46
            }

            Rectangle {
                id: albumArt
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 26
                width: 142
                height: 142
                radius: 20
                color: "#081120"

                Repeater {
                    model: [100, 86, 72]
                    delegate: Rectangle {
                        required property int modelData
                        anchors.centerIn: parent
                        width: modelData
                        height: modelData
                        radius: width / 2
                        color: "transparent"
                        border.width: 2
                        border.color: "#162D56"
                        opacity: 0.8
                    }
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: 66
                    height: 66
                    radius: 33
                    color: "#087DB3"
                    opacity: 0.95
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: 16
                    height: 16
                    radius: 8
                    color: "#081120"
                }
                Rectangle {
                    anchors.centerIn: parent
                    width: 5
                    height: 5
                    radius: 2.5
                    color: "#69D6F5"
                }
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
                Item {
                    width: 40; height: 40
                    AppIcon { anchors.centerIn: parent; source: Icons.previous; size: 32; color: Theme.colors.mediaText }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: mediaControls.previousTrack()
                    }
                }
                Item {
                    width: 44; height: 44
                    AppIcon { anchors.centerIn: parent; source: widget.controller.playing ? Icons.pause : Icons.play; size: 38; color: Theme.colors.mediaText }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: mediaControls.playPause()
                    }
                }
                Item {
                    width: 40; height: 40
                    AppIcon { anchors.centerIn: parent; source: Icons.next; size: 32; color: Theme.colors.mediaText }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: mediaControls.nextTrack()
                    }
                }
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
    }

    component EnergyHomeWidget: Surface {
        id: widget
        property SystemController controller

        width: parent ? parent.width : page.homeWidgetWidth
        height: parent ? parent.height : page.homeWidgetHeight
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

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: widget.controller.navIndex = 6
        }
    }

    component QuickHomeWidget: Surface {
        id: widget
        property SystemController controller

        function tileActive(key) {
            switch (key) {
            case "cellular": return widget.controller.cellularOn
            case "bluetooth": return widget.controller.bluetoothOn
            case "hotspot": return widget.controller.hotspotOn
            case "texture": return widget.controller.textureEnabled
            }
            return false
        }

        function toggleTile(key) {
            switch (key) {
            case "cellular":
                quickControls.toggleCellular()
                break
            case "bluetooth":
                quickControls.toggleBluetooth()
                break
            case "hotspot":
                quickControls.toggleHotspot()
                break
            case "texture":
                appBackend.textureEnabled = !widget.controller.textureEnabled
                break
            }
        }

        width: parent ? parent.width : page.homeWidgetWidth
        height: parent ? parent.height : page.homeWidgetHeight
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
                    { key: "cellular", icon: Icons.cellular, label: "Cellular", color: Theme.colors.accent },
                    { key: "bluetooth", icon: Icons.bluetooth, label: "Bluetooth", color: Theme.colors.accent },
                    { key: "hotspot", icon: Icons.hotspot, label: "Hotspot", color: Theme.colors.accent },
                    { key: "texture", icon: Icons.wRain, label: "Texture", color: Theme.colors.success }
                ]
                delegate: Surface {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 16
                    color: widget.tileActive(modelData.key) ? modelData.color : Theme.colors.surfaceVariant
                    neomorph: true
                    pressed: tileMouse.pressed || widget.tileActive(modelData.key)
                    scale: tileMouse.pressed ? 0.97 : 1.0
                    Row {
                        anchors.centerIn: parent
                        spacing: 10
                        AppIcon {
                            anchors.verticalCenter: parent.verticalCenter
                            source: modelData.icon
                            size: 24
                            color: widget.tileActive(modelData.key) ? Theme.colors.onaccent : Theme.colors.icon
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.label
                            color: widget.tileActive(modelData.key) ? Theme.colors.onaccent : Theme.colors.textSecondary
                            font.family: Theme.typography.family
                            font.pixelSize: Theme.typography.caption
                            font.weight: Theme.typography.weightMedium
                        }
                    }
                    MouseArea {
                        id: tileMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: widget.toggleTile(modelData.key)
                    }
                    Behavior on scale {
                        NumberAnimation { duration: Theme.motion.fast; easing.type: Easing.OutCubic }
                    }
                }
            }
        }
    }

    component NavigationHomeWidget: Surface {
        id: widget
        property SystemController controller
        width: parent ? parent.width : page.homeWidgetWidth
        height: parent ? parent.height : page.homeWidgetHeight
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

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: widget.controller.navIndex = 5
        }
    }

    component ClimateHomeWidget: Surface {
        id: widget
        property SystemController controller
        width: parent ? parent.width : page.homeWidgetWidth
        height: parent ? parent.height : page.homeWidgetHeight
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

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: widget.controller.navIndex = 7
        }
    }

    component TiresHomeWidget: Surface {
        id: widget
        property SystemController controller
        width: parent ? parent.width : page.homeWidgetWidth
        height: parent ? parent.height : page.homeWidgetHeight
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

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: widget.controller.navIndex = 6
        }
    }

    component TripHomeWidget: Surface {
        id: widget
        property SystemController controller
        width: parent ? parent.width : page.homeWidgetWidth
        height: parent ? parent.height : page.homeWidgetHeight
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

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: widget.controller.navIndex = 5
        }
    }

    component CalendarHomeWidget: Surface {
        id: widget
        property SystemController controller
        width: parent ? parent.width : page.homeWidgetWidth
        height: parent ? parent.height : page.homeWidgetHeight
        radius: Theme.metrics.cardRadius
        neomorph: true
        color: Theme.colors.tile

        Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 12
            Row {
                spacing: 12
                AppIcon { source: Icons.briefcase; size: 30; color: Theme.colors.accent }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Commute"
                    color: Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.subtitle
                    font.weight: Theme.typography.weightBold
                }
            }
            Text {
                text: "Design review"
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: 30
                font.weight: Theme.typography.weightBold
                elide: Text.ElideRight
            }
            Text {
                text: "10:30 • Hybrid room"
                color: Theme.colors.textSecondary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.caption
            }
            Text {
                text: "Leave in 12 min • ETA 18 min"
                color: Theme.colors.success
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.caption
                font.weight: Theme.typography.weightMedium
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: widget.controller.navIndex = 9
        }
    }

    component CallsHomeWidget: Surface {
        id: widget
        property SystemController controller
        width: parent ? parent.width : page.homeWidgetWidth
        height: parent ? parent.height : page.homeWidgetHeight
        radius: Theme.metrics.cardRadius
        neomorph: true
        color: Theme.colors.tile

        Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 12
            Row {
                spacing: 12
                AppIcon { source: Icons.person; size: 30; color: Theme.colors.success }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Calls & messages"
                    color: Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.subtitle
                    font.weight: Theme.typography.weightBold
                }
            }
            Text {
                text: "Aarav Kapoor"
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: 30
                font.weight: Theme.typography.weightBold
                elide: Text.ElideRight
            }
            Text {
                text: "Incoming call • Steering controls enabled"
                color: Theme.colors.textSecondary
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.caption
                wrapMode: Text.WordWrap
            }
            Text {
                text: "2 unread messages"
                color: Theme.colors.accent
                font.family: Theme.typography.family
                font.pixelSize: Theme.typography.caption
                font.weight: Theme.typography.weightMedium
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: widget.controller.navIndex = 9
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
                mode: page.homeTextureMode()
                visible: page.controller.textureEnabled && page.controller.homeTexture !== "none"
            }

            StatusBar {
                id: homeStatus
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.leftMargin: 30
                anchors.rightMargin: 30
                anchors.topMargin: 18
                network: page.controller.network
                time: page.controller.time
                date: page.controller.date
            }

            Surface {
                anchors.right: parent.right
                anchors.top: homeStatus.bottom
                anchors.topMargin: 14
                anchors.rightMargin: 30

                width: 132
                height: 38

                radius: height / 2
                color: Theme.colors.tile
                neomorph: true
                pressed: editMouse.pressed

                contentItem: Text {
                    text: page.controller.homeWidgetEditorOpen ? "Done" : "Edit widgets"
                    color: Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: 14
                    font.weight: Theme.typography.weightMedium
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    id: editMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: page.controller.homeWidgetEditorOpen = !page.controller.homeWidgetEditorOpen
                }
            }

            // left: clock + date + shortcuts
            Column {
                id: primaryDashboard
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

            // right: customizable swipeable widget panel
            SwipeView {
                id: homeWidgetSwipe
                readonly property int shadowPadding: 24
                readonly property int cardWidth: Math.max(page.homeWidgetMinWidth,
                                                          Math.min(page.homeWidgetMaxWidth,
                                                                   parent.width - primaryDashboard.x
                                                                   - primaryDashboard.implicitWidth
                                                                   - Theme.metrics.paddingLg * 3))

                anchors.right: parent.right
                anchors.rightMargin: Math.max(0, Theme.metrics.paddingLg - shadowPadding)
                anchors.verticalCenter: parent.verticalCenter

                width: cardWidth + shadowPadding * 2
                height: page.homeWidgetHeight + shadowPadding * 2
                clip: true
                interactive: !page.controller.homeWidgetEditorOpen

                onCountChanged: {
                    if (currentIndex >= count)
                        currentIndex = Math.max(0, count - 1)
                }

                Repeater {
                    model: page.controller.homeWidgets.length

                    delegate: Item {
                        required property int index
                        width: homeWidgetSwipe.width
                        height: homeWidgetSwipe.height

                        WidgetSlot {
                            anchors.fill: parent
                            anchors.margins: homeWidgetSwipe.shadowPadding
                            slotIndex: index
                            widgetKey: page.controller.homeWidgets[index]
                            widgetSize: "large"
                            editorOpen: page.controller.homeWidgetEditorOpen
                        }
                    }
                }
            }

            PageIndicator {
                id: homeWidgetIndicator
                anchors.horizontalCenter: homeWidgetSwipe.horizontalCenter
                anchors.top: homeWidgetSwipe.bottom
                anchors.topMargin: 20
                count: homeWidgetSwipe.count
                currentIndex: homeWidgetSwipe.currentIndex
                spacing: 8

                delegate: Rectangle {
                    required property int index
                    width: index === homeWidgetIndicator.currentIndex ? 22 : 8
                    height: 8
                    radius: 4
                    color: index === homeWidgetIndicator.currentIndex ? Theme.colors.accent : Theme.colors.iconMuted
                    opacity: index === homeWidgetIndicator.currentIndex ? 0.85 : 0.35

                    Behavior on width {
                        NumberAnimation { duration: Theme.motion.fast; easing.type: Easing.OutCubic }
                    }
                    Behavior on opacity {
                        NumberAnimation { duration: Theme.motion.fast }
                    }
                }
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
                NavigationHomeWidget { controller: page.controller }
            }
            Component {
                id: climateWidgetComponent
                ClimateHomeWidget { controller: page.controller }
            }
            Component {
                id: tiresWidgetComponent
                TiresHomeWidget { controller: page.controller }
            }
            Component {
                id: tripWidgetComponent
                TripHomeWidget { controller: page.controller }
            }
            Component {
                id: calendarWidgetComponent
                CalendarHomeWidget { controller: page.controller }
            }
            Component {
                id: callsWidgetComponent
                CallsHomeWidget { controller: page.controller }
            }
        }

        // ================= 5-day detail =================
        Item {
            id: detail

            WeatherTexture {
                anchors.fill: parent
                mode: page.homeTextureMode()
                visible: page.controller.textureEnabled && page.controller.homeTexture !== "none"
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
