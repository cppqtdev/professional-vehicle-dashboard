# Smart UI — Themeable Infotainment Panel (Qt 6 / QML)

A small but production-shaped Qt Quick app that recreates the car control-panel
mockup with full **light + dark** theming, reusable components, and module-based
imports (no `../` paths).

## Product Roadmap / Pending Case Study Features

This backlog is based on modern automotive HMI patterns from Android for Cars,
CarPlay-style dashboards, EV control systems, and in-car glanceable UI design.

### Implemented

- Live clock and date from the C++ backend.
- Live Open-Meteo weather for Nanshan/Shenzhen with forecast fallback.
- Persisted dark/light theme with `QSettings`.
- Persisted weather texture toggle with `QSettings`.
- Persisted settings toggles for Wi-Fi, auto lock, driver assist, and eco mode.
- Customizable Home right-side widget slot.
- Home widget options: Weather, Music, Energy, Quick Controls, Navigation,
  Climate, Vehicle Status/Tires, and Trip.
- App launcher/menu page with feature tiles and direct navigation.
- Dedicated Navigation screen with map mock, route summary, ETA, traffic,
  nearby chargers/parking/incidents/tolls, and start-guidance controls.
- Vehicle Status screen for doors, windows, lights, tire pressure, warnings,
  and service reminders.
- Climate screen for temperature zones, fan, seat comfort, defrost, airflow,
  and sync controls.
- Expanded EV Energy screen with charge limit, charging schedule, battery
  health, cost estimate, arrival battery, and fast-charge stop summary.
- Driver Profiles screen for saved seat, climate, theme, and widget presets.
- Notifications center for vehicle alerts, calls/messages, weather, charging,
  and maintenance.
- Voice Assistant screen with listening state and command suggestions.
- Parked Mode dashboard for video/apps/browser-style tiles.
- Safety screen for driving lockouts, simplified UI, larger touch targets, and
  do-not-disturb style controls.
- Theme Studio screen for auto day/night, ambient accent, texture packs, and
  wallpaper-style presets.
- Home weather detail view with 5-day forecast.
- Music browse/detail pages.
- Control, Energy, and Settings tabs inside the vehicle control screen.
- Infotainment quick-settings page opened from the sidebar menu.

### High Priority Next

- Home widget editor with drag/reorder, widget size presets, and live preview.
- Multiple Home widget slots instead of only one right-side widget.
- Real map SDK integration with turn-by-turn route geometry and live traffic.
- Real vehicle signal binding for doors, tires, lights, climate, charging, and
  warning states.
- Persist driver profiles and home widget layouts through `QSettings`.
- Real media queue/library data and connected call/message notification data.

### Medium Priority

- Voice command recognition and hands-free command execution.
- True parked-mode gating using vehicle speed/gear state.
- Real browser/video app integration for parked mode.
- Theme presets with saved accent/wallpaper/texture combinations.
- Side navigation redesign: active indicators, badges, long-press shortcuts.
- Calendar/commute widget and calls/messages widgets.
- Accessibility pass: contrast, touch targets, focus order, reduced motion.

### Case Study Polish

- Document design tokens and component library.
- Add interaction-state screenshots for hover/pressed/active/disabled.
- Add before/after comparison screens for each feature area.
- Add architecture diagram for C++ backend, QML controller, and reusable
  components.
- Add UX rationale for glanceability, visual hierarchy, safety, and persistence.

## Architecture

```
smartuidesign/
├── main.cpp                     # registers Theme & Icons singletons, adds qrc:/qml import path
├── main.qml                     # Window -> InfotainmentScreen
├── qml.qrc                      # all QML, qmldir and icon assets
├── icons/                       # monochrome SVGs, recoloured at runtime
└── qml/App/
    ├── Theme/Theme.qml          # design tokens: colors (light/dark), typography, metrics, motion
    ├── Icons/Icons.qml          # central icon-path registry
    ├── Components/              # module App.Components (reusable controls)
    │   ├── AppIcon  Surface  ToggleTile  ValueSlider
    │   ├── TransportButton  NowPlayingCard  SideRail
    │   └── StatusBar  ThemeToggle
    ├── Controllers/             # module App.Controllers
    │   └── SystemController.qml # view-model holding UI state
    └── Screens/                 # module App.Screens
        └── InfotainmentScreen.qml
```

### Theming
`Theme` is a single source of truth registered from C++:

```cpp
engine.addImportPath("qrc:/qml");
qmlRegisterSingletonType(QUrl("qrc:/qml/App/Theme/Theme.qml"), "App.Theme", 1, 0, "Theme");
qmlRegisterSingletonType(QUrl("qrc:/qml/App/Icons/Icons.qml"),  "App.Icons", 1, 0, "Icons");
```

Because they are registered here, `Theme.qml` / `Icons.qml` are plain
`QtObject`s (no `pragma Singleton`, no qmldir entry). Every colour binding reads
`Theme.colors.*`, so switching the whole UI is one write:

```qml
Theme.dark = false        // or Theme.toggle()  (the ☾/☀ button, top-right)
```

### Module imports (no `../`)
Component folders ship a `qmldir` (e.g. `module App.Components`) and the resource
root is on the import path, so files import by module name:

```qml
import App.Theme
import App.Icons
import App.Components
```

### Icons
SVGs are authored as solid black shapes on transparent ground; `AppIcon` recolours
them to any theme token via `MultiEffect.colorization`, so one asset serves both
themes.

### State
`SystemController` keeps UI state (toggles, slider values, track, network) out of
the views; `InfotainmentScreen` instantiates one and binds controls to it — easy
to later swap for a C++-backed model.

## Build & run

Qt 6.7+ (uses `QtQuick.Effects`, per-corner `Rectangle` radius). qmake:

```bash
qmake6 smartuidesign.pro && make && ./smartuidesign
```

or open `smartuidesign.pro` in Qt Creator and Run.
