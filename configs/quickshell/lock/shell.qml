import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: win
            required property var modelData
            readonly property real s: modelData ? modelData.height / 1080 : 1

            screen: modelData
            visible: true
            color: "transparent"

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "lock-preview"

            anchors { top: true; right: true; bottom: true; left: true }

            LockSurface {
                anchors.fill: parent
                s: win.s
            }
        }
    }
}
