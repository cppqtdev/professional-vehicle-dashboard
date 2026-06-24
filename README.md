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
- Home weather detail view with 5-day forecast.
- Music browse/detail pages.
- Control, Energy, and Settings tabs inside the vehicle control screen.
- Infotainment quick-settings page opened from the sidebar menu.

### High Priority Next

- Home widget editor with drag/reorder, widget size presets, and live preview.
- Multiple Home widget slots instead of only one right-side widget.
- Dedicated Navigation page: map mock, route cards, ETA, traffic, nearby chargers
  and parking.
- Vehicle status page: doors, windows, lights, tire pressure, warnings, service
  reminders.
- Climate page: seat heat/ventilation, airflow direction, defrost, fan zones,
  sync mode.
- EV/energy expansion: charging schedule, charge limit, battery health, cost
  estimate, route-aware range.
- App launcher/menu page: grid of apps with categories and search.
- Notifications center: vehicle alerts, calls/messages, weather alerts,
  maintenance reminders.

### Medium Priority

- Driver profile system with saved seat/climate/theme/widget preferences.
- Voice assistant panel with command suggestions and listening state.
- Safety states: driving lockouts, simplified UI while moving, larger active
  touch targets.
- Theme system: auto day/night, ambient accent color, wallpaper/texture packs.
- Side navigation redesign: active indicators, badges, long-press shortcuts.
- Parked mode: video/apps/browser-style dashboard only while parked.
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
```
```
