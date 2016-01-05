import QtQuick 2.5

import "../crossbar"
import "../../js/utils.js" as Utils

CrossBarChild {
    id: root
    property alias model: listView.model

    Rectangle {
        id: listViewContainer
        height: listView.contentHeight + 16

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
        radius: 10
        border.width: 5
        border.color: "gray"

        ListView {
            id: listView
            anchors.fill: parent
            anchors.margins: 8
            model: root.model

            function triggerCurrentItem() {
                if (currentIndex >= 0) {
                    model.get(currentIndex).item.trigger()
                    closeChild();
                    Utils.closeDialog(root);
                }
            }

            highlight: Rectangle {
                width: root.currentItem ? root.currentItem.width : 0
                height: root.currentItem ? root.currentItem.height : 0
                color: "lightsteelblue"; radius: 3
            }

            delegate: Text {
                text: name
                Component.onCompleted: {
                    var widthPlusMargins = implicitWidth + 16
                    if (listViewContainer.width < widthPlusMargins) {
                        listViewContainer.width = widthPlusMargins
                    }
                }

                font.family: mainFont.name
                font.pointSize: 24
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: listView.currentIndex = index
                    onClicked: listView.triggerCurrentItem()
                }
            }
        }
    }

    Keys.onUpPressed: listView.decrementCurrentIndex()
    Keys.onDownPressed: listView.incrementCurrentIndex()
    Keys.onReturnPressed: listView.triggerCurrentItem()
    Keys.onSpacePressed: listView.triggerCurrentItem()
    Keys.onEnterPressed: listView.triggerCurrentItem()
}
