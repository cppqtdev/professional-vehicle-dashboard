// ClimateBar.qml
// The bottom climate strip: a rounded soft-UI bar with icon segments and two
// temperature steppers, separated by thin dividers.
//
//     ClimateBar {
//         leftTemp: controller.driverTemp
//         rightTemp: controller.passengerTemp
//         onLeftTempStep: controller.driverTemp += delta
//         onRightTempStep: controller.passengerTemp += delta
//     }

import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import App.Theme
import App.Icons

TabBar {
    id: control

    property real leftTemp: 18.0
    property real rightTemp: 18.0

    // delta is +0.5 / -0.5
    signal leftTempStep(real delta)
    signal rightTempStep(real delta)

    leftPadding: 10
    rightPadding: 10
    padding: 20
    bottomPadding: 0

    background: Item {
        implicitHeight: 84
    }

    // ---- Inline parts -----------------------------------------------------
    component Seg: BottonTabButton {
        id: seg
        property string iconsource: ""
        signal activated()

        Layout.fillWidth: true
        Layout.fillHeight: true

        onClicked: seg.activated()

        AppIcon {
            anchors.centerIn: parent
            source: seg.iconsource
            size: 28
            color: Theme.colors.icon
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.NoButton
        }
    }

    component Sep: Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 38
        Layout.alignment: Qt.AlignVCenter
        color: Theme.colors.divider
    }

    component Temp: BottonTabButton {
        id: t
        property real value: 18.0
        signal step(real delta)

        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 0

        contentItem: ColumnLayout {
            spacing: 3

            AppIcon {
                Layout.alignment: Qt.AlignHCenter
                source: Icons.chevronUp
                size: 14
                color: Theme.colors.iconMuted

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -8
                    cursorShape: Qt.PointingHandCursor
                    onClicked: t.step(0.5)
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: t.value.toFixed(1)
                color: Theme.colors.textPrimary
                font.family: Theme.typography.family
                font.pixelSize: 14
                font.weight: Theme.typography.weightMedium
            }

            AppIcon {
                Layout.alignment: Qt.AlignHCenter
                source: Icons.chevronDown
                size: 14
                color: Theme.colors.iconMuted
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -8
                    cursorShape: Qt.PointingHandCursor
                    onClicked: t.step(-0.5)
                }
            }
        }
    }

    // ---- Layout -----------------------------------------------------------
    contentItem: RowLayout {
        spacing: 0

        Seg {
            iconsource: Icons.steering
            topleftradius: height / 2
            bottomleftradius: height / 2
        }
        Sep {}
        Seg { iconsource: Icons.seat }
        Sep {}
        Temp { value: control.leftTemp; onStep: (d) => control.leftTempStep(d) }
        Sep {}
        Seg { iconsource: Icons.fan }
        Sep {}
        Temp { value: control.rightTemp; onStep: (d) => control.rightTempStep(d) }
        Sep {}
        Seg { iconsource: Icons.seat }
        Sep {}
        Seg {
            iconsource: Icons.defrost
            toprightradius: height / 2
            bottomrightradius: height / 2
        }
    }
}
