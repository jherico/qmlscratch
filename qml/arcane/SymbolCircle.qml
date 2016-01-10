import QtQuick 2.5

import "."

Canvas {
    id: root
    Constants { id: arcane }
    property int symbolCount: 8
    readonly property var symbols: []
    property bool rotate: true
    property bool clockwise: true
    property color backgroundColor: "#000000"

    // Revolutions per second
    implicitWidth: 2.0 * maxRadius + circleThickness
    implicitHeight: implicitWidth
    property real speed: 0.08
    property string fontFamily: arcane.demonicFont.name
    property real textPixelSize: 15
    property real radius: (Math.min(height, width) / 2) - textPixelSize * 1.8 / 2.0;
    property real circleThickness: 1.5
    property real radiusWidth: textPixelSize * 1.5
    property real outerRadius: radius + radiusWidth / 2.0;
    property real innerRadius: radius - radiusWidth / 2.0;
    property real maxRadius: outerRadius;
    property real minRadius: innerRadius;
    property rect geometry: Qt.rect(0, 0, width, height)
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    Component.onCompleted: {
        for (var i = 0; i < symbolCount; ++i) {
            symbols.push(arcane.randomLetter());
        }
    }

    RotationAnimator {
        target: root; from: 0; to: clockwise ? 360 : -360;
        running: rotate
        duration: 1000 / root.speed
        onStopped: running = rotate
    }

    Behavior on scale {
        NumberAnimation {
            duration: 500; easing.type: Easing.OutCubic
        }
    }

    onPaint: {
        var ctx = getContext('2d');
        ctx.save();
        {
            ctx.translate(width / 2, height / 2);

            var textRadius = radius + (textPixelSize / 2.0) - circleThickness
            ctx.font = textPixelSize + "px " + fontFamily

            ctx.strokeStyle = root.backgroundColor;
            ctx.lineWidth = (maxRadius - minRadius);
            ctx.beginPath();
            ctx.arc(0, 0, radius, 0, Math.PI * 2, true);
            ctx.stroke();

            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1);
            ctx.lineWidth = circleThickness;
            ctx.beginPath();
            ctx.arc(0, 0, outerRadius, 0, Math.PI * 2, true);
            ctx.stroke();

            ctx.beginPath();
            ctx.arc(0, 0, innerRadius, 0, Math.PI * 2, true);
            ctx.stroke();

            var intervalAngle = Math.PI * 2.0 / symbolCount;
            ctx.lineWidth = 0.8;
            ctx.save();
            for (var i = 0; i < symbolCount; ++i) {
                ctx.beginPath();
                ctx.rotate(intervalAngle)
                ctx.text(symbols[i], 0, textRadius);
                ctx.stroke();
            }
            ctx.restore();
        }
        ctx.restore();
    }
}
