import QtQuick
import QtQuick.Effects
import Quickshell
import "Singletons"

Item {
    id: content
    property real s: 1

    readonly property var deLocale: Qt.locale("de_DE")

    SystemClock {
        id: sysClock
        precision: SystemClock.Seconds
    }

    component TransportButton: Item {
        property string icon: ""
        property real box: 18
        property bool hovered: tArea.containsMouse
        width: box * content.s
        height: box * content.s

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
            colorizationColor: parent.hovered ? Theme.accent : Theme.cream
        }
        MouseArea {
            id: tArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: console.log("transport: " + parent.icon)
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
                return hh + "<font color=\"" + Theme.accent + "\">:</font>" + mm;
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
            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.accent }
                GradientStop { position: 1.0; color: "#180d09" }
            }
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Theme.accent
                shadowBlur: 0.6
                shadowVerticalOffset: 0
                shadowHorizontalOffset: 0
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 3 * content.s

            Text {
                text: "NOW PLAYING"
                color: Theme.accent
                font.family: Theme.font
                font.pixelSize: 9 * content.s
                font.weight: Font.Bold
                font.capitalization: Font.AllUppercase
                font.letterSpacing: 2 * content.s
            }
            Text {
                text: "水槽の中の脳"
                color: Theme.text
                font.family: Theme.font
                font.pixelSize: 15 * content.s
                font.weight: Font.DemiBold
            }
            Text {
                text: "MIMiNARI"
                color: Theme.textDim
                font.family: Theme.font
                font.pixelSize: 12 * content.s
                font.weight: Font.Medium
                bottomPadding: 4 * content.s
            }
            Rectangle {
                width: 200 * content.s
                height: 3
                radius: 99
                color: Theme.trackBg
                Rectangle {
                    width: parent.width * 0.46
                    height: parent.height
                    radius: 99
                    color: Theme.accent
                }
            }
            Row {
                topPadding: 12 * content.s
                spacing: 22 * content.s

                TransportButton {
                    icon: "prev"
                    box: 18
                    anchors.verticalCenter: parent.verticalCenter
                }
                TransportButton {
                    icon: "pause"
                    box: 18
                    anchors.verticalCenter: parent.verticalCenter
                }
                TransportButton {
                    icon: "next"
                    box: 18
                    anchors.verticalCenter: parent.verticalCenter
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
        color: Theme.fieldBg
        border.width: 1
        border.color: input.activeFocus ? Theme.accent : Theme.fieldBorder

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
        }
        Text {
            anchors.centerIn: parent
            visible: input.text.length === 0 && !input.activeFocus
            text: "enter password"
            color: Theme.textDim
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
