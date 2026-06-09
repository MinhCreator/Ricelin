pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import Quickshell.Services.Mpris
import "Singletons"

/**
 * Media surface: circular album art ringed by a progress arc that echoes the
 * pill's comet, with play/pause on the art itself and the track plus skip
 * controls beside it. Driven by the active MPRIS player; fills the lower body
 * of the morphing pill.
 */
Item {
    id: root

    property real s: 1
    property bool active: false
    signal requestClose()

    readonly property var player: {
        var list = Mpris.players.values;
        if (!list || list.length === 0)
            return null;
        var controllable = null;
        for (var i = 0; i < list.length; i++) {
            var p = list[i];
            if (!p)
                continue;
            if (p.isPlaying)
                return p;
            if (!controllable && p.canControl)
                controllable = p;
        }
        return controllable ? controllable : list[0];
    }

    readonly property bool hasPlayer: player !== null
    readonly property bool playing: hasPlayer && player.isPlaying
    readonly property string title: hasPlayer && player.trackTitle ? player.trackTitle : "Nothing playing"
    readonly property string artist: {
        if (!hasPlayer)
            return "";
        if (player.trackArtists && player.trackArtists.length > 0)
            return player.trackArtists;
        return player.trackArtist ? player.trackArtist : "";
    }
    readonly property string artUrl: hasPlayer && player.trackArtUrl ? player.trackArtUrl : ""
    readonly property real lengthSec: hasPlayer && player.length > 0 ? player.length : 0
    readonly property real positionSec: hasPlayer ? player.position : 0
    readonly property real frac: lengthSec > 0 ? Math.max(0, Math.min(1, positionSec / lengthSec)) : 0

    function fmt(sec) {
        if (!(sec > 0))
            return "0:00";
        var t = Math.floor(sec);
        var m = Math.floor(t / 60);
        var ss = t % 60;
        return m + ":" + (ss < 10 ? "0" + ss : ss);
    }

    Timer {
        interval: 1000
        running: root.active && root.playing
        repeat: true
        onTriggered: if (root.player) root.player.positionChanged();
    }

    Item {
        id: artWrap
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: height

        readonly property real ringW: 2.6 * root.s
        readonly property real r: width / 2

        Rectangle {
            anchors.fill: parent
            radius: artWrap.r
            color: "transparent"
            border.width: artWrap.ringW
            border.color: Theme.trackBg
        }

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeColor: Theme.vermLit
                strokeWidth: artWrap.ringW
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                PathAngleArc {
                    centerX: artWrap.r
                    centerY: artWrap.r
                    radiusX: artWrap.r - artWrap.ringW / 2
                    radiusY: artWrap.r - artWrap.ringW / 2
                    startAngle: -90
                    sweepAngle: 360 * root.frac
                }
            }
        }

        Rectangle {
            id: artCircle
            anchors.centerIn: parent
            width: parent.width - 9 * root.s
            height: width
            radius: width / 2
            color: Theme.tileBg
            clip: true

            Image {
                id: art
                anchors.fill: parent
                source: root.artUrl
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: true
                visible: status === Image.Ready && source != ""
            }
            GlyphIcon {
                anchors.centerIn: parent
                width: parent.width * 0.36
                height: width
                name: "music"
                color: Theme.faint
                visible: !art.visible
            }

            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: Qt.rgba(0, 0, 0, 0.5)
                opacity: artArea.containsMouse ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 130 } }

                GlyphIcon {
                    anchors.centerIn: parent
                    width: 26 * root.s
                    height: width
                    name: root.playing ? "pause" : "play"
                    color: Theme.onAccent
                }
            }
        }

        MouseArea {
            id: artArea
            anchors.fill: parent
            hoverEnabled: true
            enabled: root.hasPlayer && root.player.canTogglePlaying
            cursorShape: Qt.PointingHandCursor
            onClicked: if (root.player) root.player.togglePlaying();
        }
    }

    Item {
        anchors.left: artWrap.right
        anchors.leftMargin: 16 * root.s
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Column {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 3 * root.s

            Text {
                width: parent.width
                text: root.title
                color: Theme.cream
                font.family: Theme.font
                font.pixelSize: 15 * root.s
                font.weight: Font.DemiBold
                elide: Text.ElideRight
            }
            Text {
                width: parent.width
                text: root.artist
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: 11.5 * root.s
                elide: Text.ElideRight
                visible: text.length > 0
            }
        }

        Row {
            id: skips
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            spacing: 20 * root.s

            Item {
                width: 22 * root.s
                height: 22 * root.s
                GlyphIcon {
                    anchors.fill: parent
                    name: "prev"
                    color: prevArea.containsMouse ? Theme.vermLit : (prevArea.enabled ? Theme.cream : Theme.disabled)
                }
                MouseArea {
                    id: prevArea
                    anchors.fill: parent
                    anchors.margins: -6 * root.s
                    hoverEnabled: true
                    enabled: root.hasPlayer && root.player.canGoPrevious
                    cursorShape: Qt.PointingHandCursor
                    onClicked: if (root.player) root.player.previous();
                }
            }
            Item {
                width: 22 * root.s
                height: 22 * root.s
                GlyphIcon {
                    anchors.fill: parent
                    name: "next"
                    color: nextArea.containsMouse ? Theme.vermLit : (nextArea.enabled ? Theme.cream : Theme.disabled)
                }
                MouseArea {
                    id: nextArea
                    anchors.fill: parent
                    anchors.margins: -6 * root.s
                    hoverEnabled: true
                    enabled: root.hasPlayer && root.player.canGoNext
                    cursorShape: Qt.PointingHandCursor
                    onClicked: if (root.player) root.player.next();
                }
            }
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 3 * root.s
            text: root.fmt(root.positionSec) + "  /  " + root.fmt(root.lengthSec)
            color: Theme.faint
            font.family: Theme.font
            font.pixelSize: 10 * root.s
            font.features: { "tnum": 1 }
        }
    }
}
