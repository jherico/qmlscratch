import QtQuick 2.5
import QtGraphicalEffects 1.0

import "."

Rectangle {
    Constants { id: arcane }
    color: "black"

    function getPoint(angle, radius) {
        angle += (90)
        var result = Qt.vector2d(Math.cos(angle), Math.sin(angle));
        if (radius) {
            result = result.times(radius);
        }
        return result;
    }

    Item {
        id: content
        anchors.fill: parent
        property var popups: []

        SymbolCircle {
            id: main
            anchors.centerIn: parent
            symbolCount: 79
            radius: parent.width / 2.0 * 0.9
            scale: 0
            backgroundColor: "#7f000000"
            Component.onCompleted: scale = 1.0
        }

        Component {
            id: smallCircleMaker
            SymbolCircle {
                symbolCount: 13
                width: main.radius / 5
                height: main.radius / 5
                textPixelSize: 8
                clockwise: false
                speed: 0.15
                scale: 0
                backgroundColor: "#00000000"
                anchors.centerIn: main
            }
        }

        Component {
            id: circleMaker
            SymbolCircle {
                symbolCount: 29
                textPixelSize: 13
                clockwise: false
                speed: 0.15
                scale: 1
                backgroundColor: "#0000FF"
                anchors.centerIn: main
            }
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

        Component.onCompleted: {
            var smallCircleCount = 7
            var interval = 2.0 * Math.PI / smallCircleCount;
            for (var i = 0; i < smallCircleCount; ++i) {
                var offsets = getPoint(i * interval, main.radius)
                console.log(offsets.x + " x " + offsets.y);
                var newCircle = smallCircleMaker.createObject(content);
                //newCircle.anchors.centerIn = undefined
                //newCircle.x += i * 20
                newCircle.anchors.verticalCenterOffset = offsets.y
                newCircle.anchors.horizontalCenterOffset = offsets.x
                popups.push(newCircle);
                console.log(popups.length)

            }
            popups = shuffle(popups);
            interval = main.textPixelSize * 3;
        }

        Timer {
            running: true;
            interval: 500;
            repeat: true
            onTriggered: {
                if (content.popups.length) {
                    interval = 50
                    if (Math.random() < 0.4) {
                        var item = content.popups.pop();
                        item.scale = 1
                    }
                } else {
                    repeat = false
                }
            }
        }
    }


    Glow {
        anchors.fill: content
        radius: 8
        samples: 16
        color: "blue"
        source: content
    }

}
