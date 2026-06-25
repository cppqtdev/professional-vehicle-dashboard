// SystemController.qml
// View-model holding the screen's UI state, kept separate from the views so the
// layout stays declarative and the state is easy to bind, test or later replace
// with a C++-backed model. The InfotainmentScreen instantiates one of these and
// binds every control to it.

import QtQuick

QtObject {
    id: controller

    // Quick settings
    property bool cellularOn: quickControls.cellularOn
    property bool bluetoothOn: quickControls.bluetoothOn
    property bool notificationsMuted: quickControls.notificationsMuted
    property bool hotspotOn: quickControls.hotspotOn

    // Sliders (0..1)
    property real volume: quickControls.volume
    property real brightness: quickControls.brightness

    // Media
    property bool playing: mediaControls.playing
    property real trackProgress: mediaControls.trackProgress
    property string trackTitle: mediaControls.trackTitle
    property string trackArtist: mediaControls.trackArtist
    property string trackElapsed: mediaControls.trackElapsed
    property string trackDuration: mediaControls.trackDuration
    property int musicTab: mediaControls.musicTab          // 0 Music, 1 Podcasts, 2 Audio Book, 3 FM
    property bool musicDetailOpen: mediaControls.musicDetailOpen
    property bool liked: mediaControls.liked
    property bool repeatOn: mediaControls.repeatOn

    // Status bar / rail
    property string network: "4G"
    property string time: appBackend.time
    property string date: appBackend.date
    property int navIndex: 0   // 0 home, 1 music, 2 control, 3 launcher, 4 quick settings, 5+ features

    // ---- Control page -----------------------------------------------------
    property bool centralLock: vehicleControls.centralLock
    property bool fuelTankLock: vehicleControls.fuelTankLock
    property bool trunkOpen: vehicleControls.trunkOpen
    property bool hybridMode: vehicleControls.hybridMode
    property bool lightControl: vehicleControls.lightControl
    property bool specialRoad: vehicleControls.specialRoad
    property real driverTemp: climateControls.driverTemp
    property real passengerTemp: climateControls.passengerTemp
    property int controlTab: vehicleControls.controlTab   // 0 Control, 1 Energy, 2 Setting

    // ---- Energy -----------------------------------------------------------
    property real batteryLevel: vehicleControls.batteryLevel   // 0..1
    property int rangeKm: vehicleControls.rangeKm
    property real consumption: vehicleControls.consumption     // kWh / 100km
    property real regen: vehicleControls.regen            // kWh recovered
    property int batteryTemp: vehicleControls.batteryTemp        // °C
    property bool charging: vehicleControls.charging

    // ---- Settings ---------------------------------------------------------
    property bool wifiOn: appBackend.wifiOn
    property bool autoLock: appBackend.autoLock
    property bool driverAssist: appBackend.driverAssist
    property bool ecoMode: appBackend.ecoMode
    property bool darkTheme: appBackend.darkTheme
    property bool textureEnabled: appBackend.textureEnabled
    property string homeWidget: appBackend.homeWidget
    property var homeWidgets: appBackend.homeWidgets
    property var homeWidgetSizes: appBackend.homeWidgetSizes
    property string homeTexture: appBackend.homeTexture
    property string driverProfile: appBackend.driverProfile
    property string themePreset: appBackend.themePreset
    property string language: "English"
    property string units: "Metric"

    // ---- Home / weather ---------------------------------------------------
    property string city: appBackend.city
    property int weatherTemp: appBackend.weatherTemp
    property string weatherCondition: appBackend.weatherCondition
    property int rainChance: appBackend.rainChance
    property int humidity: appBackend.humidity
    property string weatherIcon: appBackend.weatherIcon
    property string weatherTexture: appBackend.weatherTexture
    property bool weatherDetailOpen: false
    property bool homeWidgetEditorOpen: false

    // ---- Provider-ready live data ----------------------------------------
    property bool parkedAllowed: vehicleControls.parkedAllowed
    property bool vehicleMoving: vehicleControls.vehicleMoving
    property bool windowsClosed: vehicleControls.windowsClosed
    property int tirePressureWarning: vehicleControls.tirePressureWarning
    property var routeInfo: appBackend.routeInfo
    property var mediaLibrary: appBackend.mediaLibrary
    property var notifications: appBackend.notifications

    // 5-day forecast (icon is one of Icons.w*)
    property var forecast: appBackend.forecast

    onCellularOnChanged: if (quickControls.cellularOn !== cellularOn) quickControls.cellularOn = cellularOn
    onBluetoothOnChanged: if (quickControls.bluetoothOn !== bluetoothOn) quickControls.bluetoothOn = bluetoothOn
    onNotificationsMutedChanged: if (quickControls.notificationsMuted !== notificationsMuted) quickControls.notificationsMuted = notificationsMuted
    onHotspotOnChanged: if (quickControls.hotspotOn !== hotspotOn) quickControls.hotspotOn = hotspotOn
    onVolumeChanged: if (Math.abs(quickControls.volume - volume) > 0.001) quickControls.volume = volume
    onBrightnessChanged: if (Math.abs(quickControls.brightness - brightness) > 0.001) quickControls.brightness = brightness

    onPlayingChanged: if (mediaControls.playing !== playing) mediaControls.playing = playing
    onTrackProgressChanged: if (Math.abs(mediaControls.trackProgress - trackProgress) > 0.001) mediaControls.trackProgress = trackProgress
    onMusicTabChanged: if (mediaControls.musicTab !== musicTab) mediaControls.musicTab = musicTab
    onMusicDetailOpenChanged: if (mediaControls.musicDetailOpen !== musicDetailOpen) mediaControls.musicDetailOpen = musicDetailOpen
    onLikedChanged: if (mediaControls.liked !== liked) mediaControls.liked = liked
    onRepeatOnChanged: if (mediaControls.repeatOn !== repeatOn) mediaControls.repeatOn = repeatOn

    onCentralLockChanged: if (vehicleControls.centralLock !== centralLock) vehicleControls.centralLock = centralLock
    onFuelTankLockChanged: if (vehicleControls.fuelTankLock !== fuelTankLock) vehicleControls.fuelTankLock = fuelTankLock
    onTrunkOpenChanged: if (vehicleControls.trunkOpen !== trunkOpen) vehicleControls.trunkOpen = trunkOpen
    onHybridModeChanged: if (vehicleControls.hybridMode !== hybridMode) vehicleControls.hybridMode = hybridMode
    onLightControlChanged: if (vehicleControls.lightControl !== lightControl) vehicleControls.lightControl = lightControl
    onSpecialRoadChanged: if (vehicleControls.specialRoad !== specialRoad) vehicleControls.specialRoad = specialRoad
    onControlTabChanged: if (vehicleControls.controlTab !== controlTab) vehicleControls.controlTab = controlTab
    onBatteryLevelChanged: if (Math.abs(vehicleControls.batteryLevel - batteryLevel) > 0.001) vehicleControls.batteryLevel = batteryLevel
    onConsumptionChanged: if (Math.abs(vehicleControls.consumption - consumption) > 0.001) vehicleControls.consumption = consumption
    onRegenChanged: if (Math.abs(vehicleControls.regen - regen) > 0.001) vehicleControls.regen = regen
    onBatteryTempChanged: if (vehicleControls.batteryTemp !== batteryTemp) vehicleControls.batteryTemp = batteryTemp
    onChargingChanged: if (vehicleControls.charging !== charging) vehicleControls.charging = charging
    onVehicleMovingChanged: if (vehicleControls.vehicleMoving !== vehicleMoving) vehicleControls.vehicleMoving = vehicleMoving
    onWindowsClosedChanged: if (vehicleControls.windowsClosed !== windowsClosed) vehicleControls.windowsClosed = windowsClosed
    onTirePressureWarningChanged: if (vehicleControls.tirePressureWarning !== tirePressureWarning) vehicleControls.tirePressureWarning = tirePressureWarning

    onDriverTempChanged: if (Math.abs(climateControls.driverTemp - driverTemp) > 0.001) climateControls.driverTemp = driverTemp
    onPassengerTempChanged: if (Math.abs(climateControls.passengerTemp - passengerTemp) > 0.001) climateControls.passengerTemp = passengerTemp
}
