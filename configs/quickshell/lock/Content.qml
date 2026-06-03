import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Mpris
import "Singletons"

Item {
    id: content
    property real s: 1
    property color accent: Theme.accent
    property var auth: null

    readonly property bool authenticating: auth ? auth.authenticating : false
    property bool showError: false

    Connections {
        target: content.auth
        enabled: content.auth !== null
        function onFailed() {
            content.showError = true;
            input.text = "";
            shake.restart();
        }
        function onSucceeded() {
            content.showError = false;
            input.text = "";
        }
    }

    readonly property var deLocale: Qt.locale("de_DE")

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

    readonly property string trackTitle: {
        if (!player)
            return "";
        return player.trackTitle ? player.trackTitle : "";
    }
    readonly property string trackArtist: {
        if (!player)
            return "";
        if (player.trackArtists && player.trackArtists.length > 0)
            return player.trackArtists;
        return player.trackArtist ? player.trackArtist : "";
    }
    readonly property string artUrl: {
        if (!player)
            return "";
        return player.trackArtUrl ? player.trackArtUrl : "";
    }
    readonly property real lengthSec: hasPlayer && player.length > 0 ? player.length : 0
    readonly property real positionSec: hasPlayer ? player.position : 0
    readonly property real progress: lengthSec > 0 ? Math.max(0, Math.min(1, positionSec / lengthSec)) : 0

    SystemClock {
        id: sysClock
        precision: SystemClock.Seconds
    }

    Timer {
        interval: 1000
        running: content.playing
        repeat: true
        onTriggered: if (content.player) content.player.positionChanged()
    }

    component TransportButton: Item {
        property string icon: ""
        property real box: 18
        property bool enabledAction: true
        property bool hovered: tArea.containsMouse
        signal triggered()
        width: box * content.s
        height: box * content.s
        opacity: enabledAction ? 1 : 0.35

        Image {
            id: tImg
            anchors.fill: parent
            source: Qt.resolvedUrl("assets/icons/" + icon + ".svg")
            sourceSize.width: 64
            sourceSize.height: 64
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            visible: false
        }
        MultiEffect {
            anchors.fill: tImg
            source: tImg
            colorization: 1.0
            colorizationColor: parent.hovered && parent.enabledAction ? content.accent : Theme.cream
        }
        MouseArea {
            id: tArea
            anchors.fill: parent
            hoverEnabled: true
            enabled: parent.enabledAction
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.triggered()
        }
    }

    Column {
        id: clockStack
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 0.4 - height / 2
        spacing: 14 * content.s

        Text {
            id: clockText
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: 96 * content.s
            font.weight: Font.Medium
            font.letterSpacing: -3 * content.s
            font.features: { "tnum": 1 }
            textFormat: Text.StyledText
            text: {
                var hh = Qt.formatDateTime(sysClock.date, "HH");
                var mm = Qt.formatDateTime(sysClock.date, "mm");
                return hh + "<font color=\"" + content.accent + "\">:</font>" + mm;
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: sysClock.date.toLocaleDateString(content.deLocale, "dddd · d. MMMM")
            color: Theme.textDim
            font.family: Theme.font
            font.pixelSize: 13 * content.s
            font.weight: Font.Medium
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 5 * content.s
        }
    }

    Row {
        id: nowPlaying
        visible: content.hasPlayer
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 30 * content.s
        anchors.bottomMargin: 30 * content.s
        spacing: 14 * content.s

        Rectangle {
            id: cover
            width: 54 * content.s
            height: 54 * content.s
            radius: 10 * content.s
            anchors.verticalCenter: parent.verticalCenter
            clip: true
            gradient: Gradient {
                GradientStop { position: 0.0; color: content.accent }
                GradientStop { position: 1.0; color: "#180d09" }
            }
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: content.accent
                shadowBlur: 0.6
                shadowVerticalOffset: 0
                shadowHorizontalOffset: 0
            }
            Image {
                id: coverImg
                anchors.fill: parent
                visible: content.artUrl.length > 0
                source: content.artUrl
                fillMode: Image.PreserveAspectCrop
                smooth: true
                mipmap: true
                cache: false
                asynchronous: true
                layer.enabled: true
                layer.effect: MultiEffect {
                    maskEnabled: true
                    maskSource: coverMask
                }
            }
            Item {
                id: coverMask
                anchors.fill: parent
                layer.enabled: true
                visible: false
                Rectangle {
                    anchors.fill: parent
                    radius: 10 * content.s
                }
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 3 * content.s

            Text {
                text: "NOW PLAYING"
                color: content.accent
                font.family: Theme.font
                font.pixelSize: 9 * content.s
                font.weight: Font.Bold
                font.capitalization: Font.AllUppercase
                font.letterSpacing: 2 * content.s
            }
            Text {
                text: content.trackTitle.length > 0 ? content.trackTitle : "Unknown"
                color: Theme.text
                font.family: Theme.font
                font.pixelSize: 15 * content.s
                font.weight: Font.DemiBold
                elide: Text.ElideRight
                width: 200 * content.s
            }
            Text {
                visible: content.trackArtist.length > 0
                text: content.trackArtist
                color: Theme.textDim
                font.family: Theme.font
                font.pixelSize: 12 * content.s
                font.weight: Font.Medium
                bottomPadding: 4 * content.s
                elide: Text.ElideRight
                width: 200 * content.s
            }
            Rectangle {
                width: 200 * content.s
                height: 3
                radius: 99
                color: Theme.trackBg
                Rectangle {
                    width: parent.width * content.progress
                    height: parent.height
                    radius: 99
                    color: content.accent
                }
            }
            Row {
                topPadding: 12 * content.s
                spacing: 22 * content.s

                TransportButton {
                    icon: "prev"
                    box: 18
                    enabledAction: content.hasPlayer && content.player.canGoPrevious
                    anchors.verticalCenter: parent.verticalCenter
                    onTriggered: if (content.player && content.player.canGoPrevious) content.player.previous()
                }
                TransportButton {
                    icon: content.playing ? "pause" : "play"
                    box: 18
                    enabledAction: content.hasPlayer && content.player.canTogglePlaying
                    anchors.verticalCenter: parent.verticalCenter
                    onTriggered: if (content.player && content.player.canTogglePlaying) content.player.togglePlaying()
                }
                TransportButton {
                    icon: "next"
                    box: 18
                    enabledAction: content.hasPlayer && content.player.canGoNext
                    anchors.verticalCenter: parent.verticalCenter
                    onTriggered: if (content.player && content.player.canGoNext) content.player.next()
                }
            }
        }
    }

    Rectangle {
        id: field
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 34 * content.s
        width: 230 * content.s
        height: input.implicitHeight + 22 * content.s
        radius: 14 * content.s
        color: content.showError ? Theme.errorBg : Theme.fieldBg
        border.width: 1
        border.color: content.showError ? Theme.error : (input.activeFocus ? content.accent : Theme.fieldBorder)
        opacity: content.authenticating ? 0.6 : 1

        transform: Translate { id: fieldShift }

        SequentialAnimation {
            id: shake
            NumberAnimation { target: fieldShift; property: "x"; to: 9 * content.s; duration: 45 }
            NumberAnimation { target: fieldShift; property: "x"; to: -9 * content.s; duration: 70 }
            NumberAnimation { target: fieldShift; property: "x"; to: 6 * content.s; duration: 70 }
            NumberAnimation { target: fieldShift; property: "x"; to: 0; duration: 55 }
        }

        Behavior on color { ColorAnimation { duration: 200 } }
        Behavior on border.color { ColorAnimation { duration: 200 } }

        TextInput {
            id: input
            anchors.fill: parent
            anchors.leftMargin: 16 * content.s
            anchors.rightMargin: 16 * content.s
            verticalAlignment: TextInput.AlignVCenter
            horizontalAlignment: TextInput.AlignHCenter
            echoMode: TextInput.Password
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: 13 * content.s
            font.weight: Font.Medium
            clip: true
            focus: true
            enabled: !content.authenticating
            onTextChanged: if (text.length > 0) content.showError = false
            onAccepted: {
                if (content.auth && text.length > 0)
                    content.auth.submit(text);
            }
        }
        Text {
            anchors.centerIn: parent
            visible: input.text.length === 0 && !input.activeFocus
            text: content.showError ? "wrong password" : "enter password"
            color: content.showError ? Theme.error : Theme.textDim
            font.family: Theme.font
            font.pixelSize: 13 * content.s
            font.weight: Font.Medium
        }
    }

    Text {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 30 * content.s
        anchors.bottomMargin: 34 * content.s
        color: Theme.textDim
        font.family: Theme.font
        font.pixelSize: 12 * content.s
        font.weight: Font.Medium
        textFormat: Text.StyledText
        text: "<b><font color=\"" + Theme.cream + "\">ricelin</font></b> · torii"
    }
}
