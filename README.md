# Smart UI — Themeable Infotainment Panel (Qt 6 / QML)

A small but production-shaped Qt Quick app that recreates the car control-panel
mockup with full **light + dark** theming, reusable components, and module-based
imports (no `../` paths).

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
