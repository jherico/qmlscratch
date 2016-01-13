import QtQuick 2.5
import QtGraphicalEffects 1.0

import "."

Rectangle {
    Constants { id: arcane }
    color: "black"

    function getPoint(angle, radius) {
        angle -= (Math.PI / 2.0)
        var result = Qt.vector2d(Math.cos(angle), Math.sin(angle));
        if (radius) {
            result = result.times(radius);
        }
        return result;
    }



    function shuffle(array) {
      var currentIndex = array.length, temporaryValue, randomIndex;

      // While there remain elements to shuffle...
      while (0 !== currentIndex) {

        // Pick a remaining element...
        randomIndex = Math.floor(Math.random() * currentIndex);
        currentIndex -= 1;

        // And swap it with the current element.
        temporaryValue = array[currentIndex];
        array[currentIndex] = array[randomIndex];
        array[randomIndex] = temporaryValue;
      }

      return array;
    }

    property real intensity: 0.3
    property int pointCount: 5
    property var vertices: []
    property real vertexInterval: 2.0 * Math.PI / pointCount;
    property var colors: [
        Qt.rgba(intensity,intensity,intensity,1),
        Qt.rgba(intensity,0,0,1),
        Qt.rgba(0,intensity,intensity,1),
        Qt.rgba(0,intensity,0,1),
        Qt.rgba(intensity,0,intensity,1),
        Qt.rgba(0,0,intensity,1),
        Qt.rgba(intensity,intensity,0,1),
    ];


    Canvas {
        id: content
        anchors.fill: parent
        property var popups: []
        property var pointCircles: []

        SymbolCircle {
            id: main
            anchors.centerIn: parent
            symbolCount: 127
            radius: Math.min(parent.width, parent.height)/ 2.0 * 0.8
            textPixelSize: radius * 0.08
            scale: 0
            backgroundColor: "#7f000000"
            Component.onCompleted: scale = 1.0
            onScaleChanged: content.updateSize();
            onRadiusChanged: content.updateSize();


            SymbolCircle {
                anchors.centerIn: parent
                symbolCount: 79
                radius: main.radius * 0.7
                textPixelSize: main.textPixelSize
                speed: main.speed * 2
                clockwise: false
                scale: 0
                backgroundColor: "#000000"
                Component.onCompleted: scale = 1.0

                SymbolCircle {
                    speed: 0.14
                    anchors.centerIn: parent
                    symbolCount: 43
                    radius: main.radius * 0.4
                    textPixelSize: main.textPixelSize
                    scale: 0
                    backgroundColor: "#7f000000"
                    Component.onCompleted: scale = 1.0
                }
            }
        }


        Component {
            id: smallCircleMaker
            SymbolCircle {
                property int vertexIndex: 0
                symbolCount: 13
                radius: main.radius / 8
                textPixelSize: 16
                clockwise: false
                speed: 0.15
                scale: 0
                anchors.centerIn: main
                fillCenter: function(ctx) {
                    ctx.fillStyle = Qt.rgba(1, 1, 1, 1);
                    ctx.save();
                    ctx.translate(height/2, height/2);
                    ctx.fillRect(-10, -10, 20, 20);
                    ctx.beginPath();
                    ctx.arc(0, 0, minRadius, 0, 2 * Math.PI, false);
                    ctx.fillStyle = 'black';
                    ctx.fill();
                    ctx.restore();
                }

//                Canvas {
//                    anchors.fill: parent
//                    anchors.centerIn: parent
//                    onPaint: {
//                        var ctx = getContext('2d');
//                        ctx.save();
//                        if (true) {
//                            ctx.fillStlye = Qt.rgba(1, 0, 1, 0);
//                            ctx.fillRect(0, 0, width, height)
//                        }
//                        ctx.restore();

//                    }
//                }
            }
        }

        function line(ctx, indexa, indexb) {
            if (vertices.length == 0) {
                return;
            }

            var a = vertices[indexa % pointCount];
            var b = vertices[indexb % pointCount];
            ctx.moveTo(a.x, a.y)
            ctx.lineTo(b.x, b.y)
        }

        onPaint: {
            var ctx = getContext('2d');
            ctx.save();
            if (true) {
                ctx.translate(width / 2, height / 2);
                ctx.lineWidth = 2.5;
                ctx.strokeStyle = Qt.rgba(1, 1, 1, 1);
                var even = pointCount % 2 == 0;
                var start, end, i, j;
                ctx.beginPath();
                if (even) {
                    for (i = 0; i < (pointCount / 2); ++i) {
                        for (j = 0; j < 2; ++j) {
                            start = i * 2 + j
                            end = start + 2;
                            line(ctx, start, end);
                        }
                    }
                } else {
                    var half = (pointCount - 1) / 2;
                    for (i = 0; i < half + 1; ++i) {
                        start = i;
                        for (j = 0; j < 2; ++j) {
                            end = half + i + j
                            line(ctx, start, end);
                        }
                    }
                }
                ctx.stroke();
            }
            ctx.restore();
        }

        function updateSize() {
            for (var i = 0; i < pointCount; ++i) {
                vertices[i] = getPoint(i * vertexInterval, main.radius)
                var circle = pointCircles[i];
                circle.anchors.horizontalCenterOffset = vertices[i].x
                circle.anchors.verticalCenterOffset = vertices[i].y
            }
            content.markDirty(Qt.rect(0, 0, content.width, content.height));
            content.requestPaint();
        }

        Component.onCompleted: {
            for (var i = 0; i < pointCount; ++i) {
                vertices.push(getPoint(i * vertexInterval, main.radius))
                var newCircle = smallCircleMaker.createObject(content);
                newCircle.vertexIndex = i;
                newCircle.backgroundColor = colors[i % colors.length]
                content.popups.push(newCircle);
                pointCircles.push(newCircle);
            }
            content.popups = shuffle(content.popups);
        }


        Timer {
            running: true;
            interval: 50;
            repeat: true
            property var startTime: new Date().getTime()

            onTriggered: {
                if (main.scale === 1 && content.popups.length) {
                    if (Math.random() < 0.5) {
                        var item = content.popups.pop();
                        item.scale = 1
                    }
                }
                var elapsed = (new Date().getTime()) - startTime;
                elapsed /= 1000.0
                //glow.opacity = 0.5 + 0.5 * Math.sin(elapsed * Math.PI * 2.0);
            }
        }
    }


    Glow {
        id: glow
        anchors.fill: content
        opacity: 1.0
        radius: 8
        samples: 16
        color: "#FFF"
        source: content
    }

}
