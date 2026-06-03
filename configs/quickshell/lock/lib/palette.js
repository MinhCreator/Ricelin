.pragma library

function parseHex(s) {
    if (!s)
        return null;
    var m = /#([0-9A-Fa-f]{6})/.exec(s);
    if (!m)
        return null;
    var n = parseInt(m[1], 16);
    return {
        r: ((n >> 16) & 255) / 255,
        g: ((n >> 8) & 255) / 255,
        b: (n & 255) / 255
    };
}

function rgbToHsl(r, g, b) {
    var max = Math.max(r, g, b);
    var min = Math.min(r, g, b);
    var h = 0;
    var s = 0;
    var l = (max + min) / 2;
    var d = max - min;
    if (d > 0.00001) {
        s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
        if (max === r)
            h = (g - b) / d + (g < b ? 6 : 0);
        else if (max === g)
            h = (b - r) / d + 2;
        else
            h = (r - g) / d + 4;
        h /= 6;
    }
    return { h: h, s: s, l: l };
}

function hue2rgb(p, q, t) {
    if (t < 0)
        t += 1;
    if (t > 1)
        t -= 1;
    if (t < 1 / 6)
        return p + (q - p) * 6 * t;
    if (t < 1 / 2)
        return q;
    if (t < 2 / 3)
        return p + (q - p) * (2 / 3 - t) * 6;
    return p;
}

function hslToRgb(h, s, l) {
    if (s === 0)
        return { r: l, g: l, b: l };
    var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    var p = 2 * l - q;
    return {
        r: hue2rgb(p, q, h + 1 / 3),
        g: hue2rgb(p, q, h),
        b: hue2rgb(p, q, h - 1 / 3)
    };
}

function clampHex(hex) {
    var rgb = parseHex(hex);
    if (!rgb)
        return null;
    var hsl = rgbToHsl(rgb.r, rgb.g, rgb.b);
    hsl.s = Math.max(0.45, Math.min(0.95, hsl.s));
    hsl.l = Math.max(0.40, Math.min(0.62, hsl.l));
    var out = hslToRgb(hsl.h, hsl.s, hsl.l);
    return Qt.rgba(out.r, out.g, out.b, 1);
}
