// NavigationPage.qml
// Dedicated navigation dashboard: route overview, map mock, ETA, traffic,
// nearby places and route controls. This is a designed mock surface ready to be
// backed by a real maps SDK later.

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import App.Theme
import App.Icons
import App.Components
import App.Controllers

Control {
    id: page
    property SystemController controller
    property int routeMode: 0
    property bool guidanceActive: false

    component RouteChip: Control {
        id: chip
        property url icon
        property string title
        property string subtitle
        property bool active: false
        signal clicked()

        padding: 18
        background: Surface {
            radius: 20
            color: active ? Theme.colors.accent : Theme.colors.tile
            neomorph: true
            pressed: chipMouse.pressed
        }

        contentItem: RowLayout {
            spacing: 10

            AppIcon {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                source: chip.icon
                size: 28
                color: chip.active ? Theme.colors.onaccent : Theme.colors.icon
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 1

                Text {
                    text: chip.title
                    color: chip.active ? Theme.colors.onaccent : Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.subtitle
                    font.weight: Theme.typography.weightMedium
                }

                Text {
                    text: chip.subtitle
                    color: chip.active ? Qt.rgba(1, 1, 1, 0.72) : Theme.colors.textSecondary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.caption
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        MouseArea {
            id: chipMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: chip.clicked()
        }
    }

    component PlaceCard: Control {
        id: place
        property url icon
        property string title
        property string meta
        property color accent: Theme.colors.accent
        signal clicked()

        padding: 18
        background: Surface {
            radius: 18
            color: Theme.colors.tile
            neomorph: true
            pressed: placeMouse.pressed
        }

        contentItem: RowLayout {
            spacing: 10

            AppIcon {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                source: place.icon
                size: 30
                color: place.accent
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 1

                Text {
                    text: place.title
                    color: Theme.colors.textPrimary
                    font.family: Theme.typography.family
                    font.pixelSize: 17
                    font.weight: Theme.typography.weightMedium
                }
                Text {
                    text: place.meta
                    color: Theme.colors.textSecondary
                    font.family: Theme.typography.family
                    font.pixelSize: Theme.typography.caption
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        MouseArea {
            id: placeMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: place.clicked()
        }
    }

    contentItem: RowLayout {
        spacing: 0

        Control {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            background: Surface {
                radius: Theme.metrics.cardRadius
                color: Theme.colors.tile
                neomorph: true
            }

            Rectangle {
                anchors.fill: parent
                color: Theme.dark ? "#1F222A" : "#E8E8F3"
            }

            Repeater {
                model: 10
                delegate: Rectangle {
                    required property int index
                    width: parent.width * 1.2
                    height: 3
                    radius: 1.5
                    rotation: index % 2 === 0 ? 18 : -24
                    opacity: Theme.dark ? 0.22 : 0.36
                    color: Theme.dark ? "#454956" : "#C6C7D7"
                    x: -parent.width * 0.1
                    y: 40 + index * 46
                }
            }

            PathView {
                id: routeDots
                anchors.fill: parent
                interactive: false
                model: 9
                path: Path {
                    startX: 70; startY: routeDots.height - 70
                    PathCubic {
                        x: routeDots.width - 95
                        y: 82
                        control1X: routeDots.width * 0.28
                        control1Y: routeDots.height * 0.58
                        control2X: routeDots.width * 0.64
                        control2Y: routeDots.height * 0.35
                    }
                }
                delegate: Rectangle {
                    required property int index
                    width: index === 0 || index === 8 ? 18 : 10
                    height: width
                    radius: width / 2
                    color: index === 0 ? Theme.colors.success
                         : index === 8 ? Theme.colors.danger
                         : Theme.colors.accent
                    border.width: 3
                    border.color: Theme.colors.tile
                }
            }

            Control {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 20
                anchors.topMargin: 20

                padding: 12
                background: Rectangle {
                    implicitWidth: 250
                    implicitHeight: 92
                    radius: 8
                    color: Theme.dark ? Qt.rgba(0.07, 0.08, 0.11, 0.86)
                                      : Qt.rgba(1, 1, 1, 0.78)
                }

                contentItem: RowLayout {
                    spacing: 14

                    AppIcon { source: Icons.nav; Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter; size: 34; color: Theme.colors.accent }

                    ColumnLayout {
                        spacing: 2

                        Text {
                            text: "Continue on Shennan Ave"
                            color: Theme.colors.textPrimary
                            font.family: Theme.typography.family
                            font.pixelSize: 17
                            font.weight: Theme.typography.weightMedium
                        }
                        Text {
                            text: page.controller.routeInfo.nextTurn || "Turn right in 1.2 km"
                            color: Theme.colors.textSecondary
                            font.family: Theme.typography.family
                            font.pixelSize: Theme.typography.caption
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }
                }
            }

            Row {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 20

                spacing: 12
                IconButton { diameter: 54; checkable: false; iconSource: Icons.search; iconSize: 24; onClicked: appBackend.refreshRoute() }
                IconButton { diameter: 54; checkable: false; iconSource: Icons.globe; iconSize: 24; onClicked: page.routeMode = (page.routeMode + 1) % 2 }
            }
        }

        Flickable {
            id: routePanel
            Layout.preferredWidth: 372
            Layout.fillHeight: true
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            contentWidth: width
            contentHeight: routeContent.height

            Control {
                width: routePanel.width
                padding: 20

                contentItem: ColumnLayout {
                    id: routeContent
                    spacing: Theme.metrics.spacing

                    Control {
                        Layout.fillWidth: true
                        Layout.minimumHeight: 154
                        padding: 18

                        background: Surface {
                            radius: Theme.metrics.cardRadius
                            color: Theme.colors.tile
                            neomorph: true
                        }

                        contentItem: ColumnLayout {
                            spacing: 10

                            RowLayout {
                                Layout.fillWidth: true
                                Text {
                                    Layout.fillWidth: true
                                    text: page.controller.routeInfo.destination || "Home"
                                    color: Theme.colors.textPrimary
                                    font.family: Theme.typography.family
                                    font.pixelSize: 28
                                    font.weight: Theme.typography.weightBold
                                }

                                AppIcon { source: Icons.more; size: 22; color: Theme.colors.iconMuted }
                            }

                            Text {
                                text: "ETA " + (page.controller.routeInfo.eta || "00:35")
                                      + " • " + (page.controller.routeInfo.distance || "7.8 km")
                                      + " • " + (page.controller.routeInfo.traffic || "Light traffic")
                                color: Theme.colors.textSecondary
                                font.family: Theme.typography.family
                                font.pixelSize: Theme.typography.caption
                            }

                            RowLayout {
                                spacing: 16

                                Text {
                                    text: page.controller.routeInfo.duration || "18 min"
                                    color: Theme.colors.textPrimary
                                    font.family: Theme.typography.family
                                    font.pixelSize: 32
                                    font.weight: Theme.typography.weightBold
                                }
                                Text {
                                    text: "+3 min traffic"
                                    color: Theme.colors.danger
                                    font.family: Theme.typography.family
                                    font.pixelSize: Theme.typography.caption
                                }
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 70
                        spacing: 12
                        RouteChip { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.nav; title: "Fastest"; subtitle: page.controller.routeInfo.duration || "18 min"; active: page.routeMode === 0; onClicked: page.routeMode = 0 }
                        RouteChip { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.leaf; title: "Eco"; subtitle: "21 min"; active: page.routeMode === 1; onClicked: page.routeMode = 1 }
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 170
                        columns: 2
                        rowSpacing: 12
                        columnSpacing: 12

                        PlaceCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.bolt; title: "Chargers"; meta: (page.controller.routeInfo.chargers || 4) + " nearby"; accent: Theme.colors.accent; onClicked: appBackend.refreshRoute() }
                        PlaceCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.car; title: "Parking"; meta: page.controller.routeInfo.parking || "2.1 km"; accent: Theme.colors.success; onClicked: appBackend.refreshRoute() }
                        PlaceCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.warning; title: "Incidents"; meta: page.guidanceActive ? "Monitoring" : "1 delay"; accent: Theme.colors.danger; onClicked: page.guidanceActive = !page.guidanceActive }
                        PlaceCard { Layout.fillWidth: true; Layout.fillHeight: true; icon: Icons.road; title: "Tolls"; meta: page.routeMode === 1 ? "Avoid on" : "Avoid off"; accent: Theme.colors.iconMuted; onClicked: page.routeMode = page.routeMode === 1 ? 0 : 1 }
                    }

                    Control {
                        Layout.fillWidth: true
                        Layout.minimumHeight: 116

                        padding: 12

                        background: Surface {
                            radius: Theme.metrics.cardRadius
                            color: Theme.colors.tile
                            neomorph: true
                        }

                        contentItem: RowLayout {
                            spacing: 16

                            IconButton { diameter: 64; checkable: false; iconSource: page.guidanceActive ? Icons.pause : Icons.play; iconSize: 28; onClicked: page.guidanceActive = !page.guidanceActive }

                            Control {
                                Layout.fillWidth: true

                                contentItem: ColumnLayout {
                                    spacing: 2

                                    Text {
                                        text: page.guidanceActive ? "Guidance active" : "Start guidance"
                                        color: Theme.colors.textPrimary
                                        font.family: Theme.typography.family
                                        font.pixelSize: Theme.typography.subtitle
                                        font.weight: Theme.typography.weightBold
                                    }

                                    Text {
                                        text: "Voice prompts, lane assist and reroute controls"
                                        Layout.maximumWidth: 200
                                        color: Theme.colors.textSecondary
                                        font.family: Theme.typography.family
                                        font.pixelSize: Theme.typography.caption
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }
                        }
                    }

                    Item { Layout.fillWidth: true; Layout.preferredHeight: 20 }
                }
            }
        }
    }
}
