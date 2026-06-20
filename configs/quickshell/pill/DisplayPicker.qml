pragma ComponentBehavior: Bound

import QtQuick
import "Singletons"

/**
 * Labelled dropdown for the display surface: a left caption, a value chip showing
 * the current option, and a clipped scrollable list that expands below when open.
 * Picking emits picked(value) and the parent closes it; tapping the chip emits
 * requestToggle so the surface can keep only one dropdown open at a time. Sized to
 * the card width so a long mode list never overflows the pill.
 */
Item {
    id: pick

    property real s: 1
    property string label: ""
    property var options: []
    property var value
    property bool open: false
    signal picked(var value)
    signal requestToggle()

    readonly property string currentLabel: {
        for (var i = 0; i < options.length; i++)
            if (options[i].value === value)
                return options[i].label;
        return options.length ? options[0].label : "";
    }

    readonly property real rowH: 26 * pick.s
    readonly property real listH: pick.open ? Math.min(options.length * 24 * pick.s + 4 * pick.s, 150 * pick.s) : 0

    width: parent ? parent.width : 0
    implicitHeight: rowH + (pick.open ? listH + 4 * pick.s : 0)

    Row {
        id: head
        width: parent.width
        height: pick.rowH
        spacing: 8 * pick.s

        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: 64 * pick.s
            text: pick.label
            color: Theme.faint
            font.family: Theme.font
            font.pixelSize: 10.5 * pick.s
            font.weight: Font.Medium
        }

        Rectangle {
            id: field
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 72 * pick.s
            height: 24 * pick.s
            radius: 8 * pick.s
            color: Theme.tileBg
            border.width: 1
            border.color: pick.open ? Qt.alpha(Theme.vermLit, 0.5) : Theme.border
            Behavior on border.color { ColorAnimation { duration: Motion.fast } }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 10 * pick.s
                anchors.verticalCenter: parent.verticalCenter
                text: pick.currentLabel
                color: Theme.cream
                font.family: Theme.font
                font.pixelSize: 10.5 * pick.s
                font.weight: Font.DemiBold
            }

            GlyphIcon {
                anchors.right: parent.right
                anchors.rightMargin: 8 * pick.s
                anchors.verticalCenter: parent.verticalCenter
                width: 13 * pick.s
                height: 13 * pick.s
                name: pick.open ? "chevron-up" : "chevron-down"
                color: Theme.iconDim
                stroke: 2
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: pick.requestToggle()
            }
        }
    }

    Rectangle {
        anchors.top: head.bottom
        anchors.topMargin: 4 * pick.s
        anchors.left: parent.left
        anchors.leftMargin: 72 * pick.s
        anchors.right: parent.right
        height: pick.listH
        visible: pick.open
        clip: true
        radius: 8 * pick.s
        color: Theme.cardBot
        border.width: 1
        border.color: Theme.border

        ListView {
            anchors.fill: parent
            anchors.margins: 2 * pick.s
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            model: pick.options

            delegate: Rectangle {
                id: optRow
                required property var modelData
                readonly property bool current: pick.value === modelData.value

                width: ListView.view.width
                height: 24 * pick.s
                radius: 6 * pick.s
                color: optHover.hovered ? Theme.frameBg
                    : (optRow.current ? Qt.alpha(Theme.vermLit, 0.14) : "transparent")

                HoverHandler { id: optHover }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 9 * pick.s
                    anchors.verticalCenter: parent.verticalCenter
                    text: optRow.modelData.label
                    color: optRow.current ? Theme.vermLit : Theme.subtle
                    font.family: Theme.font
                    font.pixelSize: 10.5 * pick.s
                    font.weight: optRow.current ? Font.Bold : Font.Medium
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: pick.picked(optRow.modelData.value)
                }
            }
        }
    }
}
