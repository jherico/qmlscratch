import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import ".."

Text {
    id: root
    text: name ? name : ""
    font.family: mainFont.name
    font.pointSize: 16 * (1.0 + 0.6 * PathView.selectedValue)
    color: PathView.isCurrentItem ? "black" : "grey"

    signal pressed(var index)

    MouseArea {
        anchors.fill: parent
        onClicked: root.pressed(index)
    }
}
