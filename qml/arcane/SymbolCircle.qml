import QtQuick 2.5

import "."

Canvas {
    id: root
    Constants { id: arcane }
    property int symbolCount: 8
    readonly property var symbols: []
    property bool rotate: true
    property bool clockwise: true
    property color backgroundColor: Qt.rgba(0, 0, 0, 1);
    property color color: Qt.rgba(1, 1, 1, 1);


    // Revolutions per second
    implicitWidth: 2.0 * maxRadius + circleThickness
    implicitHeight: implicitWidth
    property real speed: 0.08
    property string fontFamily: arcane.demonicFont.name
    property real textPixelSize: radius * 0.1
    property real radius: (Math.min(height, width) / 2);
    property real circleThickness: 1.6
    property real radiusWidth: textPixelSize * 1.2
    property real outerRadius: radius + radiusWidth / 2.0;
    property real innerRadius: radius - radiusWidth / 2.0;
    property real maxRadius: outerRadius;
    property real minRadius: innerRadius;
    property rect geometry: Qt.rect(0, 0, width, height)
    property real intervalAngle: Math.PI * 2.0 / symbolCount;
    property var fillCenter: function(ctx) {

    }

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

            ctx.font = textPixelSize + "px " + fontFamily
            ctx.textBaseline = "middle"
            ctx.strokeStyle = root.backgroundColor;
            ctx.lineWidth = (maxRadius - minRadius);

            ctx.beginPath();
            ctx.arc(0, 0, radius, 0, Math.PI * 2, true);
            ctx.stroke();

            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1);
            ctx.lineWidth = circleThickness;

            ctx.beginPath();
            ctx.arc(0, 0, maxRadius, 0, Math.PI * 2, true);
            ctx.stroke();

            ctx.beginPath();
            ctx.arc(0, 0, minRadius, 0, Math.PI * 2, true);
            ctx.stroke();

            ctx.fillStyle = Qt.rgba(1, 1, 1, 1);
            ctx.save();
            for (var i = 0; i < symbolCount; ++i) {
                ctx.rotate(intervalAngle)
                ctx.fillText(symbols[i], 0, radius);
            }
            ctx.restore();

        }
        ctx.restore();
        fillCenter(ctx)
    }
}
