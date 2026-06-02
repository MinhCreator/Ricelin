import QtQuick
import QtQuick.Effects
import "Singletons"

Card {
    id: root
    eyebrow: "Audio"

    component SinkRow: Item {
        property string label: ""
        property string device: ""
        property string chip: ""
        width: parent ? parent.width : 0
        implicitHeight: 24 * root.s

        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0
            Text {
                text: label + " · "
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: 11.5 * root.s
                font.weight: Font.Medium
            }
            Text {
                text: device
                color: "#b9a99e"
                font.family: Theme.font
                font.pixelSize: 11.5 * root.s
                font.weight: Font.DemiBold
            }
        }
        Rectangle {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            radius: 9 * root.s
            color: Theme.tileBg
            border.width: 1
            border.color: Theme.border
            implicitHeight: 24 * root.s
            width: chipRow.implicitWidth + 20 * root.s
            height: implicitHeight
            Row {
                id: chipRow
                anchors.centerIn: parent
                spacing: 6 * root.s
                Item {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 13 * root.s; height: 13 * root.s
                    Image {
                        id: chevIcon
                        anchors.fill: parent
                        source: Qt.resolvedUrl("assets/icons/chevron.svg")
                        sourceSize.width: 64; sourceSize.height: 64
                        fillMode: Image.PreserveAspectFit
                        smooth: true; mipmap: true; visible: false
                    }
                    MultiEffect {
                        anchors.fill: chevIcon
                        source: chevIcon
                        colorization: 1.0
                        colorizationColor: "#b9a99e"
                    }
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: chip
                    color: "#b9a99e"
                    font.family: Theme.font
                    font.pixelSize: 10.5 * root.s
                    font.weight: Font.DemiBold
                }
            }
        }
    }

    component VolRow: Item {
        property string icon: ""
        property real value: 0.5
        property string valueLabel: ""
        property bool hasMic: false
        width: parent ? parent.width : 0
        implicitHeight: 26 * root.s

        Item {
            id: vicon
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 19 * root.s; height: 19 * root.s
            Image {
                id: vIconImg
                anchors.fill: parent
                source: Qt.resolvedUrl("assets/icons/" + icon + ".svg")
                sourceSize.width: 64; sourceSize.height: 64
                fillMode: Image.PreserveAspectFit
                smooth: true; mipmap: true; visible: false
            }
            MultiEffect {
                anchors.fill: vIconImg
                source: vIconImg
                colorization: 1.0
                colorizationColor: Theme.vermLit
            }
        }
        Text {
            id: vval
            anchors.right: hasMic ? micbtn.left : parent.right
            anchors.rightMargin: hasMic ? 10 * root.s : 0
            anchors.verticalCenter: parent.verticalCenter
            width: 34 * root.s
            horizontalAlignment: Text.AlignRight
            text: valueLabel
            color: "#b9a99e"
            font.family: Theme.font
            font.pixelSize: 11 * root.s
            font.weight: Font.DemiBold
        }
        Slider {
            s: root.s
            value: parent.value
            anchors.left: vicon.right
            anchors.leftMargin: 12 * root.s
            anchors.right: vval.left
            anchors.rightMargin: 12 * root.s
            anchors.verticalCenter: parent.verticalCenter
        }
        Rectangle {
            id: micbtn
            visible: hasMic
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 26 * root.s; height: 26 * root.s; radius: 8 * root.s
            color: Theme.accent16
            border.width: 1
            border.color: Theme.accent45
            Image {
                id: micOffImg
                anchors.centerIn: parent
                width: 14 * root.s; height: 14 * root.s
                source: Qt.resolvedUrl("assets/icons/mic-off.svg")
                sourceSize.width: 64; sourceSize.height: 64
                fillMode: Image.PreserveAspectFit
                smooth: true; mipmap: true; visible: false
            }
            MultiEffect {
                anchors.fill: micOffImg
                source: micOffImg
                colorization: 1.0
                colorizationColor: Theme.vermLit
            }
        }
    }

    SinkRow { label: "Output"; device: "Edifier R1280T"; chip: "HDMI" }
    VolRow { icon: "speaker"; value: 0.68; valueLabel: "68%" }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.hair
    }

    SinkRow { label: "Input"; device: "HyperX QuadCast"; chip: "Webcam Mic" }
    VolRow { icon: "mic"; value: 0.55; valueLabel: "55%"; hasMic: true }
}
