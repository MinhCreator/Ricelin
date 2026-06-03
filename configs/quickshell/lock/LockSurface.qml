import QtQuick
import "Singletons"

Item {
    id: surface
    property real s: 1

    clip: true

    Image {
        anchors.fill: parent
        source: "file:///tmp/lock-dev-bg.jpg"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        mipmap: true
        cache: false
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.accent
        opacity: Theme.gradeIntensity
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Theme.scrimTop }
            GradientStop { position: 0.45; color: "transparent" }
            GradientStop { position: 1.0; color: Theme.scrimBottom }
        }
    }

    Content {
        anchors.fill: parent
        s: surface.s
    }
}
