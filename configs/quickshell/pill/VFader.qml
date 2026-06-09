import QtQuick
import "Singletons"

/**
 * Vertical filament fader. A thin matte thread with a rising fill and a flat
 * tick marker. Dim at rest; saturates and reveals its readout when lit (hover
 * or keyboard focus). No knob, no glow. Value is normalised 0..1.
 */
Item {
    id: root

    property real s: 1
    property string icon: ""
    property real value: 0.5
    property string valueLabel: ""
    property bool focused: false

    signal moved(real v)
    signal committed(real v)

    readonly property alias hovered: hoverArea.containsMouse
    readonly property bool lit: hovered || focused

    readonly property real trackH: 86 * s

    implicitWidth: 54 * s
    implicitHeight: trackH + 44 * s

    /**
     * Nudge the value by a signed percentage (e.g. +1 / -1), clamped to 0..100%,
     * emitting `moved` and `committed` so live hardware updates on each step.
     */
    function step(deltaPct) {
        const v = Math.max(0, Math.min(1, root.value + deltaPct / 100));
        root.moved(v);
        root.committed(v);
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
    }

    Item {
        id: trackArea
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: 22 * root.s
        height: root.trackH

        Rectangle {
            id: thread
            anchors.horizontalCenter: parent.horizontalCenter
            width: 2 * root.s
            height: parent.height
            radius: width / 2
            color: Qt.rgba(0.94, 0.88, 0.84, 0.13)

            Rectangle {
                id: fill
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height * Math.max(0, Math.min(1, root.value))
                radius: parent.radius
                gradient: Gradient {
                    GradientStop { position: 0.0; color: root.lit ? Theme.vermLit : "#8a5440" }
                    GradientStop { position: 1.0; color: root.lit ? "#8a2c14" : "#5a3526" }
                }
                Behavior on height { NumberAnimation { duration: Motion.fast } }
            }
        }

        Rectangle {
            id: tick
            anchors.horizontalCenter: parent.horizontalCenter
            y: (1 - Math.max(0, Math.min(1, root.value))) * (root.trackH - height)
            width: 11 * root.s
            height: 2.5 * root.s
            radius: 2 * root.s
            color: root.lit ? Theme.flameCore : "#cbb6a3"
        }

        MouseArea {
            anchors.fill: parent
            anchors.margins: -10 * root.s
            preventStealing: true
            function setFromY(my) {
                const v = 1 - Math.max(0, Math.min(1, (my - 10 * root.s) / root.trackH));
                root.moved(v);
            }
            onPressed: (e) => setFromY(e.y)
            onPositionChanged: (e) => { if (pressed) setFromY(e.y); }
            onReleased: root.committed(root.value)
        }
    }

    Text {
        id: readout
        anchors.top: trackArea.bottom
        anchors.topMargin: 7 * root.s
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.valueLabel
        color: Theme.cream
        opacity: root.lit ? 1 : 0
        font.family: Theme.font
        font.pixelSize: 9 * root.s
        font.weight: Font.DemiBold
        Behavior on opacity { NumberAnimation { duration: Motion.fast } }
    }

    Item {
        id: iconBox
        anchors.top: readout.bottom
        anchors.topMargin: 3 * root.s
        anchors.horizontalCenter: parent.horizontalCenter
        width: 18 * root.s
        height: 18 * root.s

        GlyphIcon {
            anchors.fill: parent
            name: root.icon
            color: root.lit ? Theme.cream : Theme.iconDim
            stroke: 1.7
        }
    }
}
