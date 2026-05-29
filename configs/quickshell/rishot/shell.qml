// rishot — entry. One keyboard-exclusive overlay window per screen over a frozen capture.
// Selection tracked in GLOBAL coords; each overlay renders the intersecting sub-rect.
// Pollution rule (Spike 0): capture each screen's frozen frame, then STOP capturing before
// any opaque dim/chrome becomes visible — re-capturing would grab our own surface.
import QtQuick
import Quickshell
import Quickshell.Wayland
import "lib/coords.js" as Coords

ShellRoot {
    id: root

    // Shared selection state in global coordinate space.
    property var globalSel: null      // {x,y,w,h} | null
    property var pressPoint: null     // {x,y} | null
    property bool capturing: false

    readonly property bool testRect: Quickshell.env("RISHOT_TESTRECT") === "1"

    property var overlays: []
    property int frozenCount: 0

    function beginSelection(gx, gy) {
        pressPoint = { x: gx, y: gy };
        capturing = true;
        globalSel = { x: gx, y: gy, w: 0, h: 0 };
    }
    function updateSelection(gx, gy) {
        if (!pressPoint) return;
        globalSel = Coords.rectFromPoints(pressPoint, { x: gx, y: gy });
    }
    function endSelection() {
        capturing = false;
    }

    function noteFrozen() {
        frozenCount += 1;
        if (testRect && frozenCount >= Quickshell.screens.length) testDriver.start();
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: win
            required property var modelData
            screen: modelData

            anchors { top: true; left: true; right: true; bottom: true }
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            WlrLayershell.namespace: "rishot"

            // PanelWindow is not an Item — Keys/focus must live on a child FocusScope.
            FocusScope {
                anchors.fill: parent
                focus: true
                Keys.onEscapePressed: Qt.quit()

                Overlay {
                    id: ov
                    anchors.fill: parent
                    screenData: win.modelData
                    globalSel: root.globalSel
                    capturing: root.capturing

                    onPressedAt: (gx, gy) => root.beginSelection(gx, gy)
                    onMovedTo: (gx, gy) => root.updateSelection(gx, gy)
                    onReleased: root.endSelection()
                    onFrozen: root.noteFrozen()
                }
            }

            Component.onCompleted: root.overlays.push(win)

            readonly property string scrName: win.modelData.name
            function grabTo(path, cb) {
                var scheduled = ov.grabToImage(function(result) {
                    var ok = result ? result.saveToFile(path) : false;
                    console.log("rishot-p1: " + path + " => " + ok);
                    cb();
                });
                if (!scheduled) cb();   // grab couldn't be scheduled — don't hang the driver
            }
        }
    }

    // --- gated self-validation (RISHOT_TESTRECT=1) ---
    // Two passes: a DP-1-only rect, then a seam-spanning rect. Each pass grabs every
    // overlay to /tmp/rishot-p1-<pass>-<screen>.png, then quits.
    QtObject {
        id: testState
        property var passes: [
            { tag: "dp", rect: { x: 2700, y: 300, w: 700, h: 450 } },
            { tag: "seam", rect: { x: 2400, y: 200, w: 400, h: 300 } }
        ]
        property int passIdx: -1
    }

    Timer {
        id: testDriver
        interval: 350
        repeat: false
        onTriggered: root.runTestPass()
    }

    function runTestPass() {
        testState.passIdx += 1;
        if (testState.passIdx >= testState.passes.length) { Qt.quit(); return; }
        var p = testState.passes[testState.passIdx];
        root.globalSel = p.rect;
        grabTimer.tag = p.tag;
        grabTimer.start();
    }

    Timer {
        id: grabTimer
        interval: 250                 // let the new selection render before grabbing
        repeat: false
        property string tag: ""
        property int pending: 0
        onTriggered: {
            pending = root.overlays.length;
            for (var i = 0; i < root.overlays.length; i++) {
                var w = root.overlays[i];
                w.grabTo("/tmp/rishot-p1-" + tag + "-" + w.scrName + ".png", function() {
                    grabTimer.pending -= 1;
                    if (grabTimer.pending === 0) testDriver.restart();
                });
            }
        }
    }
}
