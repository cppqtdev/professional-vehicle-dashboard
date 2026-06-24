// NavTabBar.qml
// A transparent, themed TabBar. Pair with NavTabButton.
//
//     NavTabBar {
//         NavTabButton { text: "Control" }
//         NavTabButton { text: "Energy" }
//         NavTabButton { text: "Setting" }
//     }

import QtQuick
import QtQuick.Controls.Basic as Basic

Basic.TabBar {
    id: control
    property int buttonWidth: 184

    spacing: 10
    implicitWidth: count * buttonWidth + Math.max(0, count - 1) * spacing
    implicitHeight: 56
    background: Item {}
}
