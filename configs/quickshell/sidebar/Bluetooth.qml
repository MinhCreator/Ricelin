import QtQuick
import QtQuick.Effects
import "Singletons"

Card {
    id: root

    property var devices: [
        { name: "WH-1000XM5", meta: "Headphones · connected", icon: "bluetooth", connected: true, battery: "82%" },
        { name: "DualSense", meta: "Controller · paired", icon: "bluetooth", connected: false, battery: "" },
        { name: "8BitDo Ultimate", meta: "Controller · paired", icon: "bluetooth", connected: false, battery: "" },
        { name: "Magic Trackpad", meta: "Pointer · paired", icon: "bluetooth", connected: false, battery: "" },
        { name: "Galaxy Buds", meta: "Earbuds · paired", icon: "bluetooth", connected: false, battery: "" },
        { name: "Keychron K2", meta: "Keyboard · paired", icon: "bluetooth", connected: false, battery: "" }
    ]

    Item {
        width: parent.width
        implicitHeight: 21 * root.s

        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10 * root.s

            Item {
                anchors.verticalCenter: parent.verticalCenter
                width: 18 * root.s; height: 18 * root.s
                Image {
                    id: btHead
                    anchors.fill: parent
                    source: Qt.resolvedUrl("assets/icons/bluetooth.svg")
                    sourceSize.width: 64; sourceSize.height: 64
                    fillMode: Image.PreserveAspectFit
                    smooth: true; mipmap: true; visible: false
                }
                MultiEffect {
                    anchors.fill: btHead
                    source: btHead
                    colorization: 1.0
                    colorizationColor: "#cdbfb4"
                }
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Bluetooth"
                color: Theme.cream
                font.family: Theme.font
                font.pixelSize: 13 * root.s
                font.weight: Font.DemiBold
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "3 connected"
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: 10 * root.s
                font.weight: Font.DemiBold
            }
        }

        Rectangle {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 38 * root.s; height: 21 * root.s; radius: 11 * root.s
            border.width: 1
            border.color: Theme.vermLit
            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.vermLit }
                GradientStop { position: 1.0; color: Theme.verm }
            }
            Rectangle {
                width: 15 * root.s; height: 15 * root.s; radius: width / 2
                color: "#fbeee7"
                y: 2 * root.s
                x: parent.width - width - 2 * root.s
            }
        }
    }

    Item {
        width: parent.width
        implicitHeight: Math.min(list.contentHeight, 170 * root.s)

        Flickable {
            id: list
            anchors.fill: parent
            contentHeight: rows.implicitHeight
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            Column {
                id: rows
                width: list.width
                spacing: 6 * root.s

                Repeater {
                    model: root.devices
                    delegate: Rectangle {
                        required property var modelData
                        width: rows.width
                        implicitHeight: 46 * root.s
                        radius: 11 * root.s
                        color: modelData.connected ? Theme.accent16 : "transparent"
                        border.width: 1
                        border.color: modelData.connected ? Theme.accent45 : "transparent"

                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 9 * root.s
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 11 * root.s

                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                width: 30 * root.s; height: 30 * root.s; radius: 9 * root.s
                                color: modelData.connected ? Theme.accent16 : Theme.tileBg
                                border.width: 1
                                border.color: modelData.connected ? Theme.accent45 : Theme.border
                                Image {
                                    id: dico
                                    anchors.centerIn: parent
                                    width: 16 * root.s; height: 16 * root.s
                                    source: Qt.resolvedUrl("assets/icons/" + modelData.icon + ".svg")
                                    sourceSize.width: 64; sourceSize.height: 64
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true; mipmap: true; visible: false
                                }
                                MultiEffect {
                                    anchors.fill: dico
                                    source: dico
                                    colorization: 1.0
                                    colorizationColor: modelData.connected ? Theme.vermLit : Theme.dim
                                }
                            }
                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 1 * root.s
                                Text {
                                    text: modelData.name
                                    color: modelData.connected ? Theme.cream : "#b9a99e"
                                    font.family: Theme.font
                                    font.pixelSize: 12.5 * root.s
                                    font.weight: modelData.connected ? Font.DemiBold : Font.Medium
                                }
                                Text {
                                    text: modelData.meta
                                    color: "#6f635b"
                                    font.family: Theme.font
                                    font.pixelSize: 10 * root.s
                                    font.weight: Font.Medium
                                }
                            }
                        }

                        Text {
                            visible: modelData.connected
                            anchors.right: parent.right
                            anchors.rightMargin: 11 * root.s
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.battery
                            color: Theme.vermLit
                            font.family: Theme.font
                            font.pixelSize: 10.5 * root.s
                            font.weight: Font.DemiBold
                        }

                        Rectangle {
                            visible: !modelData.connected
                            anchors.right: parent.right
                            anchors.rightMargin: 9 * root.s
                            anchors.verticalCenter: parent.verticalCenter
                            radius: 8 * root.s
                            color: Theme.tileBg
                            border.width: 1
                            border.color: Theme.border
                            implicitHeight: 22 * root.s
                            width: connText.implicitWidth + 18 * root.s
                            height: implicitHeight
                            Text {
                                id: connText
                                anchors.centerIn: parent
                                text: "Connect"
                                color: Theme.dim
                                font.family: Theme.font
                                font.pixelSize: 10 * root.s
                                font.weight: Font.DemiBold
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
            height: 18 * root.s
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: Theme.panelBot }
            }
        }
    }
}
