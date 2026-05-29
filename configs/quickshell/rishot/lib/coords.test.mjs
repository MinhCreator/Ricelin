// rishot — node test for pure coord math. Run: node coords.test.mjs
import { createRequire } from "node:module";
const require = createRequire(import.meta.url);
const { globalToLocal, localToGlobal, intersectRect, rectFromPoints } = require("./coords.js");

let failed = 0;
function eq(actual, expected, msg) {
    const a = JSON.stringify(actual);
    const e = JSON.stringify(expected);
    if (a === e) {
        console.log("PASS " + msg);
    } else {
        failed++;
        console.log("FAIL " + msg + "\n  expected " + e + "\n  got      " + a);
    }
}

// DP-1 at x=2560. Global point on DP-1 -> local.
const dpX = 2560, dpY = 0;
eq(globalToLocal({ x: 2600, y: 100 }, dpX, dpY), { x: 40, y: 100 }, "globalToLocal DP-1 point");

// Round-trip inverts.
const g = { x: 2600, y: 100 };
const local = globalToLocal(g, dpX, dpY);
eq(localToGlobal(local, dpX, dpY), g, "round-trip localToGlobal inverts");

// HDMI-A-1 at x=0.
eq(globalToLocal({ x: 300, y: 200 }, 0, 0), { x: 300, y: 200 }, "globalToLocal HDMI point");

// Selection spanning the seam (x=2560). Global {x:2400,y:200,w:400,h:300} -> spans both.
const span = { x: 2400, y: 200, w: 400, h: 300 };
const hdmi = { x: 0, y: 0, width: 2560, height: 1440 };
const dp = { x: 2560, y: 0, width: 2560, height: 1440 };

eq(intersectRect(span, hdmi), { x: 2400, y: 200, w: 160, h: 300 }, "intersect span on HDMI-A-1");
eq(intersectRect(span, dp), { x: 0, y: 200, w: 240, h: 300 }, "intersect span on DP-1");

// Selection fully on DP-1 -> null on HDMI.
const onDp = { x: 2700, y: 300, w: 700, h: 450 };
eq(intersectRect(onDp, hdmi), null, "DP-only selection has no HDMI intersection");
eq(intersectRect(onDp, dp), { x: 140, y: 300, w: 700, h: 450 }, "DP-only selection local on DP-1");

// rectFromPoints normalizes negative drag.
eq(rectFromPoints({ x: 100, y: 100 }, { x: 40, y: 30 }), { x: 40, y: 30, w: 60, h: 70 }, "rectFromPoints normalizes");

if (failed > 0) {
    console.log("\n" + failed + " test(s) FAILED");
    process.exit(1);
}
console.log("\nAll tests PASSED");
