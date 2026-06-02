import QtQuick
import "Singletons"

Item {
    id: root
    property real s: 1
    property real value: 0.5
    property int throttleMs: 0
    signal moved(real v)
    signal committed(real v)

    implicitHeight: 17 * s

    Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width; height: 8 * root.s; radius: 99
        color: Theme.trackBg
        border.width: 1; border.color: Theme.border
        Rectangle {
            height: parent.height; radius: 99
            width: Math.max(0, Math.min(1, root.value)) * parent.width
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: Theme.verm }
                GradientStop { position: 1.0; color: Theme.vermLit }
            }
        }
        Rectangle {
            width: 17 * root.s; height: 17 * root.s; radius: 99
            color: "#f1e4db"; border.width: 2; border.color: Theme.vermLit
            y: (parent.height - height) / 2
            x: Math.max(0, Math.min(1, root.value)) * parent.width - width / 2
        }
    }
    Timer {
        id: throttle
        interval: root.throttleMs; repeat: false
        onTriggered: root.committed(root.value)
    }
    MouseArea {
        anchors.fill: parent
        anchors.margins: -8 * root.s
        function setFromX(mx) {
            var v = Math.max(0, Math.min(1, mx / width));
            root.value = v; root.moved(v);
            if (root.throttleMs > 0) { if (!throttle.running) throttle.start(); }
            else root.committed(v);
        }
        onPressed: (e) => setFromX(e.x)
        onPositionChanged: (e) => { if (pressed) setFromX(e.x); }
        onReleased: root.committed(root.value)
    }
}
