import QtQuick
import QtQuick.Effects
import "Singletons"

Rectangle {
    id: root
    property real s: 1

    radius: 16 * s
    color: "transparent"
    border.width: 1
    border.color: Theme.border
    implicitHeight: col.implicitHeight
    clip: true
    gradient: Gradient {
        GradientStop { position: 0.0; color: Theme.panelTop }
        GradientStop { position: 1.0; color: Theme.panelBot }
    }
    Rectangle {
        anchors { left: parent.left; right: parent.right; top: parent.top }
        anchors.margins: 1
        height: 1; radius: 16 * root.s
        color: Theme.sheen
    }

    component TBtn: Item {
        property string icon: ""
        property real box: 20
        property string tint: "#b9a99e"
        width: box * root.s; height: box * root.s
        signal clicked()
        Image {
            id: tImg
            anchors.fill: parent
            source: Qt.resolvedUrl("assets/icons/" + icon + ".svg")
            sourceSize.width: 64; sourceSize.height: 64
            fillMode: Image.PreserveAspectFit
            smooth: true; mipmap: true; visible: false
        }
        MultiEffect {
            anchors.fill: tImg
            source: tImg
            colorization: 1.0
            colorizationColor: tint
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.clicked()
        }
    }

    Column {
        id: col
        width: parent.width

        Row {
            width: parent.width
            leftPadding: 14 * root.s
            rightPadding: 14 * root.s
            topPadding: 14 * root.s
            bottomPadding: 14 * root.s
            spacing: 13 * root.s

            Rectangle {
                width: 76 * root.s; height: 76 * root.s; radius: 12 * root.s
                border.width: 1
                border.color: Theme.border
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#3a2118" }
                    GradientStop { position: 1.0; color: "#1c1410" }
                }
                Rectangle {
                    anchors.centerIn: parent
                    width: 22 * root.s; height: 22 * root.s; radius: width / 2
                    color: "transparent"
                    border.width: 1
                    border.color: Qt.rgba(230/255, 214/255, 203/255, 0.22)
                }
            }

            Column {
                width: parent.width - 76 * root.s - 13 * root.s - 28 * root.s
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2 * root.s
                Text {
                    text: "Now Playing"
                    color: Theme.vermLit
                    font.family: Theme.font
                    font.pixelSize: 9 * root.s
                    font.weight: Font.DemiBold
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 1.5 * root.s
                    bottomPadding: 5 * root.s
                }
                Text {
                    width: parent.width
                    text: "Spiegel im Spiegel"
                    color: Theme.cream
                    font.family: Theme.font
                    font.pixelSize: 14 * root.s
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                }
                Text {
                    width: parent.width
                    text: "Arvo Pärt"
                    color: Theme.dim
                    font.family: Theme.font
                    font.pixelSize: 11.5 * root.s
                    font.weight: Font.Medium
                    elide: Text.ElideRight
                }
            }
        }

        Column {
            width: parent.width
            leftPadding: 14 * root.s
            rightPadding: 14 * root.s
            bottomPadding: 4 * root.s
            spacing: 7 * root.s

            Rectangle {
                width: parent.width - 28 * root.s
                height: 4 * root.s
                radius: 99
                color: Theme.trackBg
                Rectangle {
                    width: parent.width * 0.38
                    height: parent.height
                    radius: 99
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: Theme.verm }
                        GradientStop { position: 1.0; color: Theme.vermLit }
                    }
                }
            }
            Item {
                width: parent.width - 28 * root.s
                implicitHeight: 12 * root.s
                Text {
                    anchors.left: parent.left
                    text: "3:42"
                    color: "#6f635b"
                    font.family: Theme.font
                    font.pixelSize: 10 * root.s
                    font.weight: Font.DemiBold
                }
                Text {
                    anchors.right: parent.right
                    text: "9:38"
                    color: "#6f635b"
                    font.family: Theme.font
                    font.pixelSize: 10 * root.s
                    font.weight: Font.DemiBold
                }
            }
        }

        Item {
            width: parent.width
            implicitHeight: 42 * root.s + 24 * root.s

            Row {
                anchors.centerIn: parent
                spacing: 18 * root.s

                TBtn {
                    icon: "prev"
                    box: 20
                    anchors.verticalCenter: parent.verticalCenter
                }
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 42 * root.s; height: 42 * root.s; radius: width / 2
                    border.width: 1
                    border.color: Theme.vermLit
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Theme.vermLit }
                        GradientStop { position: 1.0; color: Theme.verm }
                    }
                    Image {
                        id: playImg
                        anchors.centerIn: parent
                        width: 18 * root.s; height: 18 * root.s
                        source: Qt.resolvedUrl("assets/icons/play.svg")
                        sourceSize.width: 64; sourceSize.height: 64
                        fillMode: Image.PreserveAspectFit
                        smooth: true; mipmap: true; visible: false
                    }
                    MultiEffect {
                        anchors.fill: playImg
                        source: playImg
                        colorization: 1.0
                        colorizationColor: "#fbeee7"
                    }
                }
                TBtn {
                    icon: "next"
                    box: 20
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
