import QtQuick
import QtQuick.Effects
import "Singletons"

Card {
    id: root
    eyebrow: "Network"

    Item {
        width: parent.width
        implicitHeight: 36 * root.s

        Rectangle {
            id: iconbox
            width: 36 * root.s; height: 36 * root.s; radius: 11 * root.s
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.tileBg
            border.width: 1
            border.color: Theme.border
            Image {
                id: ethIcon
                anchors.centerIn: parent
                width: 19 * root.s; height: 19 * root.s
                source: Qt.resolvedUrl("assets/icons/ethernet.svg")
                sourceSize.width: 64; sourceSize.height: 64
                fillMode: Image.PreserveAspectFit
                smooth: true; mipmap: true; visible: false
            }
            MultiEffect {
                anchors.fill: ethIcon
                source: ethIcon
                colorization: 1.0
                colorizationColor: Theme.vermLit
            }
        }

        Column {
            anchors.left: iconbox.right
            anchors.leftMargin: 12 * root.s
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2 * root.s
            Text {
                text: "Ethernet"
                color: Theme.cream
                font.family: Theme.font
                font.pixelSize: 13 * root.s
                font.weight: Font.DemiBold
            }
            Row {
                spacing: 0
                Text {
                    text: "Connected · "
                    color: Theme.dim
                    font.family: Theme.font
                    font.pixelSize: 11 * root.s
                    font.weight: Font.Medium
                }
                Text {
                    text: "1.0 Gb/s"
                    color: "#b9a99e"
                    font.family: Theme.font
                    font.pixelSize: 11 * root.s
                    font.weight: Font.DemiBold
                }
            }
        }

        Rectangle {
            id: ip
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            radius: 8 * root.s
            color: Theme.tileBg
            border.width: 1
            border.color: Theme.border
            implicitHeight: 22 * root.s
            width: ipText.implicitWidth + 18 * root.s
            height: implicitHeight
            Text {
                id: ipText
                anchors.centerIn: parent
                text: "192.168.0.10"
                color: "#b9a99e"
                font.family: Theme.font
                font.pixelSize: 11 * root.s
                font.weight: Font.DemiBold
            }
        }
    }

    Item {
        width: parent.width
        implicitHeight: 24 * root.s

        Rectangle {
            id: autochip
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            radius: 999
            color: Theme.tileBg
            border.width: 1
            border.color: Theme.border
            implicitHeight: 18 * root.s
            width: autoRow.implicitWidth + 14 * root.s
            height: implicitHeight
            Row {
                id: autoRow
                anchors.centerIn: parent
                spacing: 4 * root.s
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 5 * root.s; height: 5 * root.s; radius: width / 2
                    color: Theme.vermLit
                }
                Text {
                    text: "Auto"
                    color: Theme.dim
                    font.family: Theme.font
                    font.pixelSize: 8.5 * root.s
                    font.weight: Font.Bold
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 0.85 * root.s
                }
            }
        }

        Rectangle {
            id: disconnect
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            radius: 9 * root.s
            color: Theme.tileBg
            border.width: 1
            border.color: Theme.border
            implicitHeight: 24 * root.s
            width: discRow.implicitWidth + 22 * root.s
            height: implicitHeight
            Row {
                id: discRow
                anchors.centerIn: parent
                spacing: 6 * root.s
                Item {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 13 * root.s; height: 13 * root.s
                    Image {
                        id: linkIcon
                        anchors.fill: parent
                        source: Qt.resolvedUrl("assets/icons/link.svg")
                        sourceSize.width: 64; sourceSize.height: 64
                        fillMode: Image.PreserveAspectFit
                        smooth: true; mipmap: true; visible: false
                    }
                    MultiEffect {
                        anchors.fill: linkIcon
                        source: linkIcon
                        colorization: 1.0
                        colorizationColor: Theme.vermLit
                    }
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Disconnect"
                    color: "#b9a99e"
                    font.family: Theme.font
                    font.pixelSize: 10.5 * root.s
                    font.weight: Font.DemiBold
                }
            }
        }
    }
}
