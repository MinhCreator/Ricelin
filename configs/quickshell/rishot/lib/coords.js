// rishot — pure coordinate math for the multi-output global space. No Qt imports.

function globalToLocal(point, screenX, screenY) {
    return { x: point.x - screenX, y: point.y - screenY };
}

function localToGlobal(point, screenX, screenY) {
    return { x: point.x + screenX, y: point.y + screenY };
}

// Intersect a global-space rect {x,y,w,h} with a screen rect {x,y,width,height}.
// Returns the overlapping region in coords LOCAL to that screen, or null if disjoint.
function intersectRect(globalRect, screenRect) {
    var gx1 = globalRect.x;
    var gy1 = globalRect.y;
    var gx2 = globalRect.x + globalRect.w;
    var gy2 = globalRect.y + globalRect.h;

    var sx1 = screenRect.x;
    var sy1 = screenRect.y;
    var sx2 = screenRect.x + screenRect.width;
    var sy2 = screenRect.y + screenRect.height;

    var ix1 = Math.max(gx1, sx1);
    var iy1 = Math.max(gy1, sy1);
    var ix2 = Math.min(gx2, sx2);
    var iy2 = Math.min(gy2, sy2);

    if (ix2 <= ix1 || iy2 <= iy1) return null;

    return {
        x: ix1 - screenRect.x,
        y: iy1 - screenRect.y,
        w: ix2 - ix1,
        h: iy2 - iy1
    };
}

// Normalize two global points (press, current) into a {x,y,w,h} rect with positive size.
function rectFromPoints(a, b) {
    var x = Math.min(a.x, b.x);
    var y = Math.min(a.y, b.y);
    return { x: x, y: y, w: Math.abs(b.x - a.x), h: Math.abs(b.y - a.y) };
}

if (typeof module !== "undefined" && module.exports) {
    module.exports = { globalToLocal, localToGlobal, intersectRect, rectFromPoints };
}
