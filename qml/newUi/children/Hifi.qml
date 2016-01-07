import QtQuick 2.5

import "../../controls/crossbar"

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
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.pointSize: 36
            text: "Hifi Menu\nNot Implemented Yet"
        }
    }
}
