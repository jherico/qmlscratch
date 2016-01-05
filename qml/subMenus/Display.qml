import QtQuick 2.5

import "../crossbar"

CrossBarChild {
    Rectangle {
        width: 640; height: 480
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
        radius: 10
        border.width: 5
        border.color: "gray"
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 36
            focus: true
            text: "Not Implemented Yet"
        }
    }
}
