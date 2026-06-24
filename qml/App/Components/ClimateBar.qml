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
import QtQuick.Layouts
import App.Theme
import App.Components
import App.Icons

Surface {
    id: bar

    property real leftTemp: 18.0
    property real rightTemp: 18.0

    // delta is +0.5 / -0.5
    signal leftTempStep(real delta)
    signal rightTempStep(real delta)

    radius: height / 2
    neomorph: true
    color: Theme.colors.tile
    implicitHeight: 84

    // ---- Inline parts -----------------------------------------------------
    component Seg: Item {
        id: seg
        property url icon
        signal activated()
        Layout.fillWidth: true
        Layout.fillHeight: true
        AppIcon {
            anchors.centerIn: parent
            source: seg.icon
            size: 27
            color: Theme.colors.icon
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: seg.activated()
        }
    }

    component Sep: Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 40
        Layout.alignment: Qt.AlignVCenter
        color: Theme.colors.divider
    }

    component Temp: ColumnLayout {
        id: t
        property real value: 18.0
        signal step(real delta)
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 0

        AppIcon {
            Layout.alignment: Qt.AlignHCenter
            source: Icons.chevronUp
            size: 16
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
            font.pixelSize: 24
            font.weight: Theme.typography.weightMedium
        }
        AppIcon {
            Layout.alignment: Qt.AlignHCenter
            source: Icons.chevronDown
            size: 16
            color: Theme.colors.iconMuted
            MouseArea {
                anchors.fill: parent
                anchors.margins: -8
                cursorShape: Qt.PointingHandCursor
                onClicked: t.step(-0.5)
            }
        }
    }

    // ---- Layout -----------------------------------------------------------
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 22
        anchors.rightMargin: 22
        spacing: 0

        Seg { icon: Icons.steering }
        Sep {}
        Seg { icon: Icons.seat }
        Sep {}
        Temp { value: bar.leftTemp; onStep: (d) => bar.leftTempStep(d) }
        Sep {}
        Seg { icon: Icons.fan }
        Sep {}
        Temp { value: bar.rightTemp; onStep: (d) => bar.rightTempStep(d) }
        Sep {}
        Seg { icon: Icons.seat }
        Sep {}
        Seg { icon: Icons.defrost }
    }
}
