// MusicPage.qml
// Music browser (tabs, search, avatar, a horizontally Flickable row of category
// cards, and a now-playing bar) plus an in-page now-playing detail view.

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Basic
import QtQuick.Effects
import App.Theme
import App.Icons
import App.Components
import App.Controllers

Item {
    id: page
    property SystemController controller

    // ---- Category card ----------------------------------------------------
    component CatCard: Surface {
        id: c
        property string title
        property string subtitle
        property url art
        property color fg: Theme.colors.textPrimary
        signal clicked()

        width: 182
        height: 220
        radius: Theme.metrics.cardRadius
        elevated: true

        Text {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 22
            text: c.title
            color: c.fg
            font.family: Theme.typography.family
            font.pixelSize: 23
            font.weight: Theme.typography.weightBold
        }
        Text {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 54
            anchors.leftMargin: 22
            text: c.subtitle
            color: c.fg
            opacity: 0.66
            font.family: Theme.typography.family
            font.pixelSize: Theme.typography.caption
        }
        Image {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 20
            width: 78; height: 78
            source: c.art
            fillMode: Image.PreserveAspectFit
            smooth: true; mipmap: true
        }
        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: c.clicked() }
    }

    StackLayout {
        anchors.fill: parent
        currentIndex: page.controller.musicDetailOpen ? 1 : 0

        // ================= Browse =================
        Item {
            id: browse
            Item {
                anchors.fill: parent
                anchors.leftMargin: Theme.metrics.paddingLg
                anchors.rightMargin: Theme.metrics.paddingLg
                anchors.topMargin: Theme.metrics.paddingMd
                anchors.bottomMargin: Theme.metrics.paddingLg

                // ---- Top: tabs + search + avatar -------------------------
                Item {
                    id: topRow
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: 52

                    NavTabBar {
                        id: tabs
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        currentIndex: page.controller.musicTab
                        onCurrentIndexChanged: page.controller.musicTab = currentIndex
                        NavTabButton { text: "Music";      tabWidth: 110 }
                        NavTabButton { text: "Podcasts";    tabWidth: 130 }
                        NavTabButton { text: "Audio Book";  tabWidth: 150 }
                        NavTabButton { text: "FM";          tabWidth: 70 }
                    }

                    Row {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 16

                        // search pill
                        Surface {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 300; height: 46
                            radius: height / 2
                            neomorph: true
                            color: Theme.colors.tile
                            Row {
                                anchors.left: parent.left
                                anchors.leftMargin: 18
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 12
                                AppIcon {
                                    anchors.verticalCenter: parent.verticalCenter
                                    source: Icons.search; size: 20; color: Theme.colors.iconMuted
                                }
                                Basic.TextField {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 220
                                    placeholderText: "Search Music"
                                    placeholderTextColor: Theme.colors.textSecondary
                                    color: Theme.colors.textPrimary
                                    font.family: Theme.typography.family
                                    font.pixelSize: Theme.typography.subtitle
                                    background: Item {}
                                }
                            }
                        }

                        // avatar
                        Surface {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 46; height: 46
                            radius: width / 2
                            neomorph: true
                            color: Theme.colors.accent
                            AppIcon {
                                anchors.centerIn: parent
                                source: Icons.person; size: 24; color: Theme.colors.onaccent
                            }
                        }
                    }
                }

                // ---- Flickable card row ----------------------------------
                Flickable {
                    id: cardFlick
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: topRow.bottom
                    anchors.topMargin: Theme.metrics.spacing
                    height: 220
                    clip: true
                    contentWidth: cardRow.width
                    contentHeight: height
                    flickableDirection: Flickable.HorizontalFlick
                    boundsBehavior: Flickable.StopAtBounds

                    Row {
                        id: cardRow
                        height: parent.height
                        spacing: Theme.metrics.spacing

                        // Featured "Daily Recommended"
                        Surface {
                            width: 372; height: 220
                            radius: 8
                            elevated: true
                            color: "#0E1424"

                            Rectangle {
                                id: featuredMask
                                anchors.fill: parent
                                radius: 8
                                visible: false
                                layer.enabled: true
                            }

                            Item {
                                anchors.fill: parent
                                layer.enabled: true
                                layer.effect: MultiEffect {
                                    maskEnabled: true
                                    maskSource: featuredMask
                                }

                                Image {
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    width: parent.height
                                    source: Icons.albumCover
                                    fillMode: Image.PreserveAspectCrop
                                    smooth: true; mipmap: true
                                }
                                // left fade for legibility
                                Rectangle {
                                    anchors.fill: parent
                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal
                                        GradientStop { position: 0.0; color: "#0E1424" }
                                        GradientStop { position: 0.55; color: "#000E1424" }
                                    }
                                }
                                Row {
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    anchors.margins: 22
                                    spacing: 8
                                    Text {
                                        text: "29"; color: "#FFFFFF"
                                        font.family: Theme.typography.family
                                        font.pixelSize: 40; font.weight: Theme.typography.weightBold
                                    }
                                    Text {
                                        anchors.top: parent.top; anchors.topMargin: 4
                                        text: "JUN"; color: "#FFFFFF"
                                        font.family: Theme.typography.family
                                        font.pixelSize: 16; font.weight: Theme.typography.weightMedium
                                    }
                                }
                                Row {
                                    anchors.left: parent.left
                                    anchors.bottom: parent.bottom
                                    anchors.margins: 22
                                    spacing: 12
                                    Rectangle {
                                        width: 42; height: 42; radius: 21
                                        color: "transparent"
                                        border.width: 2; border.color: "#FFFFFF"
                                        anchors.verticalCenter: parent.verticalCenter
                                        AppIcon {
                                            anchors.centerIn: parent
                                            source: Icons.play; size: 18; color: "#FFFFFF"
                                        }
                                    }
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "Daily\nRecommended"
                                        color: "#FFFFFF"
                                        font.family: Theme.typography.family
                                        font.pixelSize: Theme.typography.caption
                                        lineHeight: 1.1
                                    }
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: page.controller.musicDetailOpen = true
                            }
                        }

                        CatCard {
                            title: "Favorite"; subtitle: "365 Songs"
                            art: Icons.cHeart; color: "#F3B0C6"; fg: "#3A1020"
                            onClicked: page.controller.musicDetailOpen = true
                        }
                        CatCard {
                            title: "Radio"; subtitle: "Subtitle"
                            art: Icons.cWave; color: "#0C0C10"; fg: "#FFFFFF"
                            onClicked: page.controller.musicDetailOpen = true
                        }
                        CatCard {
                            title: "Popular"; subtitle: "Top 100"
                            art: Icons.cStar; color: "#BFC0F2"; fg: "#1B1B3A"
                            onClicked: page.controller.musicDetailOpen = true
                        }
                        CatCard {
                            title: "Discover"; subtitle: "Explore more"
                            art: Icons.cDiscover; color: "#9BA0AE"; fg: "#FFFFFF"
                            onClicked: page.controller.musicDetailOpen = true
                        }
                    }
                }

                // ---- Now-playing bar -------------------------------------
                RowLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 72
                    spacing: 16

                    IconButton {
                        diameter: 56; checkable: false
                        iconSource: Icons.previous; iconSize: 22
                    }
                    IconButton {
                        diameter: 56; checkable: false
                        iconSource: page.controller.playing ? Icons.pause : Icons.play
                        iconSize: 24
                        onClicked: page.controller.playing = !page.controller.playing
                    }
                    IconButton {
                        diameter: 56; checkable: false
                        iconSource: Icons.next; iconSize: 22
                    }

                    ColumnLayout {
                        Layout.leftMargin: 8
                        spacing: 0
                        Text {
                            text: page.controller.trackTitle
                            color: Theme.colors.textPrimary
                            font.family: Theme.typography.family
                            font.pixelSize: Theme.typography.subtitle
                            font.weight: Theme.typography.weightMedium
                        }
                        Text {
                            text: page.controller.trackArtist
                            color: Theme.colors.textSecondary
                            font.family: Theme.typography.family
                            font.pixelSize: Theme.typography.caption
                        }
                    }

                    Item { Layout.fillWidth: true }

                    AppIcon {
                        source: Icons.queue; size: 26; color: Theme.colors.icon
                        MouseArea {
                            anchors.fill: parent; anchors.margins: -10
                            cursorShape: Qt.PointingHandCursor
                            onClicked: page.controller.musicDetailOpen = true
                        }
                    }
                }
            }
        }

        // ================= Now-playing detail =================
        Basic.Page {
            id: detail
            padding: Theme.metrics.paddingLg
            background: Item {}

            header: Basic.Control {
                topPadding: 20
                bottomPadding: 20
                leftPadding: 30
                rightPadding: 30

                Rectangle {
                    id: dDivider
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    anchors.bottom: parent.bottom
                    height: 1
                    color: Theme.colors.divider
                }

                contentItem: RowLayout {
                    id: dTop
                    spacing: 16

                    AppIcon {
                        source: Icons.back; size: 26; color: Theme.colors.icon
                        MouseArea {
                            anchors.fill: parent; anchors.margins: -10
                            cursorShape: Qt.PointingHandCursor
                            onClicked: page.controller.musicDetailOpen = false
                        }
                    }

                    ColumnLayout {
                        spacing: 0

                        Text {
                            text: page.controller.trackTitle
                            color: Theme.colors.textPrimary
                            font.family: Theme.typography.family
                            font.pixelSize: Theme.typography.title
                            font.weight: Theme.typography.weightBold
                        }

                        Text {
                            text: page.controller.trackArtist
                            color: Theme.colors.textSecondary
                            font.family: Theme.typography.family
                            font.pixelSize: Theme.typography.subtitle
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    AppIcon { source: Icons.more; size: 22; color: Theme.colors.iconMuted }
                }
            }

            contentItem: RowLayout {
                spacing: Theme.metrics.spacing

                // left: controls + progress + transport
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 0

                    RowLayout {
                        spacing: 40
                        AppIcon {
                            source: Icons.heartOutline; size: 26
                            color: page.controller.liked ? Theme.colors.danger : Theme.colors.icon
                            MouseArea { anchors.fill: parent; anchors.margins: -8
                                cursorShape: Qt.PointingHandCursor
                                onClicked: page.controller.liked = !page.controller.liked }
                        }
                        AppIcon {
                            source: Icons.repeat; size: 26
                            color: page.controller.repeatOn ? Theme.colors.accent : Theme.colors.icon
                            MouseArea { anchors.fill: parent; anchors.margins: -8
                                cursorShape: Qt.PointingHandCursor
                                onClicked: page.controller.repeatOn = !page.controller.repeatOn }
                        }
                        AppIcon { source: Icons.queue; size: 26; color: Theme.colors.icon }
                        AppIcon { source: Icons.volume; size: 26; color: Theme.colors.icon }
                    }

                    Item { Layout.fillHeight: true; Layout.preferredHeight: 1 }

                    // progress
                    Basic.Slider {
                        id: progress
                        Layout.fillWidth: true
                        from: 0; to: 1
                        value: page.controller.trackProgress
                        onMoved: page.controller.trackProgress = value
                        background: Rectangle {
                            x: progress.leftPadding
                            y: progress.topPadding + progress.availableHeight / 2 - height / 2
                            width: progress.availableWidth
                            height: 5
                            radius: height / 2
                            color: Theme.colors.sliderTrack
                            Rectangle {
                                width: progress.visualPosition * parent.width
                                height: parent.height
                                radius: parent.radius
                                color: Theme.colors.textPrimary
                            }
                            Behavior on color {
                                ColorAnimation { duration: Theme.motion.normal; easing.type: Easing.OutCubic }
                            }
                        }
                        handle: Rectangle {
                            x: progress.leftPadding + progress.visualPosition * (progress.availableWidth - width)
                            y: progress.topPadding + progress.availableHeight / 2 - height / 2
                            width: 16; height: 16; radius: 8
                            color: Theme.colors.textPrimary
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: 8
                        Text {
                            text: page.controller.trackElapsed
                            color: Theme.colors.textSecondary
                            font.family: Theme.typography.family
                            font.pixelSize: Theme.typography.caption
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: page.controller.trackDuration
                            color: Theme.colors.textSecondary
                            font.family: Theme.typography.family
                            font.pixelSize: Theme.typography.caption
                        }
                    }

                    Item { Layout.fillHeight: true; Layout.preferredHeight: 1 }

                    // big transport
                    RowLayout {
                        spacing: 28
                        IconButton { diameter: 78; checkable: false; iconSource: Icons.previous; iconSize: 28 }
                        IconButton {
                            diameter: 78; checkable: false
                            iconSource: page.controller.playing ? Icons.pause : Icons.play
                            iconSize: 32
                            onClicked: page.controller.playing = !page.controller.playing
                        }
                        IconButton { diameter: 78; checkable: false; iconSource: Icons.next; iconSize: 28 }
                    }

                    Item { Layout.fillHeight: true; Layout.preferredHeight: 1 }
                }

                // right: album art
                Item {
                    id: albumArtFrame
                    Layout.preferredWidth: 322
                    Layout.preferredHeight: 322
                    Layout.alignment: Qt.AlignVCenter

                    Rectangle {
                        id: albumArtMask
                        anchors.fill: parent
                        radius: 8
                        visible: false
                        layer.enabled: true
                    }

                    Image {
                        anchors.fill: parent
                        source: Icons.albumCover
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                        mipmap: true
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            maskEnabled: true
                            maskSource: albumArtMask
                        }
                    }
                }
            }
        }
    }
}
