// NowPlayingCard.qml
// The media surface on the right of the panel: track title, artist, a progress
// line and transport controls over a dark album backdrop with a soft glow.
// This card stays dark in both themes (it represents album artwork).

import QtQuick
import QtQuick.Effects
import App.Theme
import App.Components
import App.Icons

Rectangle {
    id: card

    property string title: "Fake plastic tree"
    property string artist: "Radiohead"
    property bool playing: false
    property real progress: 0.5

    signal toggled()
    signal next()
    signal previous()

    radius: Theme.metrics.cardRadius
    color: Theme.colors.mediaBackground
    clip: true

    // Soft album glow
    Rectangle {
        width: 280
        height: 280
        radius: width / 2
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 18
        color: Theme.colors.mediaGlow
        opacity: 0.55
        layer.enabled: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: 1.0
            blurMax: 64
        }
    }

    // Title + artist
    Column {
        id: meta
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: Theme.metrics.paddingLg
        spacing: 6

        Text {
            width: parent.width
            text: card.title
            elide: Text.ElideRight
            color: Theme.colors.mediaText
            font.family: Theme.typography.family
            font.pixelSize: Theme.typography.title
            font.weight: Theme.typography.weightMedium
        }
        Text {
            text: card.artist
            color: Theme.colors.mediaSecondary
            font.family: Theme.typography.family
            font.pixelSize: Theme.typography.subtitle
        }
    }

    // Progress line
    Rectangle {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Theme.metrics.paddingLg
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 6
        height: 3
        radius: 1.5
        color: Theme.colors.mediaTrack

        Rectangle {
            width: parent.width * card.progress
            height: parent.height
            radius: parent.radius
            color: Theme.colors.mediaText
        }
        Rectangle {
            width: 8; height: 8; radius: 4
            color: Theme.colors.mediaText
            x: parent.width * card.progress - width / 2
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Transport controls
    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.metrics.paddingLg
        spacing: 26

        TransportButton {
            anchors.verticalCenter: parent.verticalCenter
            iconSource: Icons.previous
            size: 26
            onClicked: card.previous()
        }
        TransportButton {
            anchors.verticalCenter: parent.verticalCenter
            iconSource: card.playing ? Icons.pause : Icons.play
            size: 30
            onClicked: {
                card.playing = !card.playing
                card.toggled()
            }
        }
        TransportButton {
            anchors.verticalCenter: parent.verticalCenter
            iconSource: Icons.next
            size: 26
            onClicked: card.next()
        }
    }
}
