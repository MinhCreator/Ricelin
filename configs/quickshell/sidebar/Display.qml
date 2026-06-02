import QtQuick
import QtQuick.Effects
import "Singletons"

Card {
    id: root
    eyebrow: "Display"

    component VolRow: Item {
        property string icon: ""
        property real value: 0.5
        property string valueLabel: ""
        width: parent ? parent.width : 0
        implicitHeight: 19 * root.s

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
            anchors.right: parent.right
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
    }

    Column {
        width: parent.width
        spacing: 8 * root.s
        Text {
            text: "Brightness"
            color: Theme.dim
            font.family: Theme.font
            font.pixelSize: 11.5 * root.s
            font.weight: Font.Medium
        }
        VolRow { icon: "sun"; value: 0.80; valueLabel: "80%" }
    }

    Column {
        width: parent.width
        spacing: 8 * root.s
        Text {
            text: "Vibrance"
            color: Theme.dim
            font.family: Theme.font
            font.pixelSize: 11.5 * root.s
            font.weight: Font.Medium
        }
        VolRow { icon: "monitor"; value: 0.50; valueLabel: "50%" }
    }
}
