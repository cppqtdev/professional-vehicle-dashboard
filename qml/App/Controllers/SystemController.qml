// SystemController.qml
// View-model holding the screen's UI state, kept separate from the views so the
// layout stays declarative and the state is easy to bind, test or later replace
// with a C++-backed model. The InfotainmentScreen instantiates one of these and
// binds every control to it.

import QtQuick

QtObject {
    id: controller

    // Quick settings
    property bool cellularOn: true
    property bool bluetoothOn: false
    property bool notificationsMuted: true
    property bool hotspotOn: false

    // Sliders (0..1)
    property real volume: 0.32
    property real brightness: 0.6

    // Media
    property bool playing: false
    property real trackProgress: 0.45
    property string trackTitle: "House of Card"
    property string trackArtist: "Radiohead"
    property string trackElapsed: "02:09"
    property string trackDuration: "05:46"
    property int musicTab: 0          // 0 Music, 1 Podcasts, 2 Audio Book, 3 FM
    property bool musicDetailOpen: false
    property bool liked: false
    property bool repeatOn: false

    // Status bar / rail
    property string network: "4G"
    property string time: "09:35"
    property string date: "Saturday | Jun 29"
    property int navIndex: 0   // 0 nav/home, 1 music, 2 car/control, 3 menu/infotainment

    // ---- Control page -----------------------------------------------------
    property bool centralLock: true
    property bool fuelTankLock: false
    property bool trunkOpen: false
    property bool hybridMode: true
    property bool lightControl: false
    property bool specialRoad: false
    property real driverTemp: 18.0
    property real passengerTemp: 18.0
    property int controlTab: 0   // 0 Control, 1 Energy, 2 Setting

    // ---- Energy -----------------------------------------------------------
    property real batteryLevel: 0.78   // 0..1
    property int rangeKm: 412
    property real consumption: 16.2     // kWh / 100km
    property real regen: 2.1            // kWh recovered
    property int batteryTemp: 24        // °C
    property bool charging: false

    // ---- Settings ---------------------------------------------------------
    property bool wifiOn: true
    property bool autoLock: true
    property bool driverAssist: true
    property bool ecoMode: false
    property string language: "English"
    property string units: "Metric"

    // ---- Home / weather ---------------------------------------------------
    property string city: "Nanshan | Shenzhen"
    property int weatherTemp: 35
    property string weatherCondition: "Mostly Clear"
    property int rainChance: 90
    property int humidity: 75
    property bool weatherDetailOpen: false

    // 5-day forecast (icon is one of Icons.w*)
    property var forecast: [
        { day: "27 SUN", icon: "wRain",   hi: 23, lo: 18, cond: "Showers",       rain: 90 },
        { day: "28 MON", icon: "wPartly", hi: 26, lo: 20, cond: "Partly Cloudy", rain: 40 },
        { day: "29 TUE", icon: "wSun",    hi: 35, lo: 27, cond: "Mostly Clear",  rain: 18 },
        { day: "30 WED", icon: "wRain",   hi: 20, lo: 16, cond: "Rain",          rain: 86 },
        { day: "1 FRI",  icon: "wStorm",  hi: 25, lo: 18, cond: "Mostly Clear",  rain: 72 }
    ]
}
