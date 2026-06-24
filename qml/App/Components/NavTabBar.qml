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
    spacing: 10
    background: Item {}
}
