import QtQuick 2.5

import "../controls"
import "../../js/utils.js" as Utils

CrossBarChild {
    id: root
    property var model;
    property var listView;

    delegate: Component {
        Rectangle {
            id: listViewContainer
            height: listView.contentHeight + 64
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            radius: 10
            border.width: 5
            border.color: "gray"

            ListView {
                id: listView
                anchors.fill: parent
                anchors.topMargin: 32
                anchors.margins: 8
                model: root.model

                Component.onCompleted: {
                    root.listView = listView;

                }

                function triggerCurrentItem() {
                    if (currentIndex >= 0 && currentItem.enabled) {
                        model.get(currentIndex).item.trigger()
                        closeChild();
                        Utils.closeDialog(root);
                    }
                }

                highlight: Rectangle {
                    //width: root.currentItem ? root.currentItem.width : 0
                    //height: root.currentItem ? root.currentItem.height : 0
                    color: "lightsteelblue"; radius: 3
                }

                delegate: Item {
                    implicitWidth: text.implicitWidth + check.width * 2 + 8
                    implicitHeight: text.implicitHeight
                    anchors.left: parent.left
                    anchors.right: parent.right
                    enabled: item.enabled
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (index == listView.currentIndex) {
                                listView.triggerCurrentItem()
                            } else {
                                listView.currentIndex = index;
                            }
                        }
                    }

                    FontAwesome{
                        id: check
                        text: "\uf00c"
                        visible: item.checked
                        anchors.top: text.top
                        anchors.bottom: text.bottom
                        width: height
                        anchors.right: text.left
                        anchors.rightMargin: 4
                        font.pointSize: 18
                    }

                    Text {
                        id: text
                        text: name
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: lightFont.name
                        color: item.enabled ? "#222" : "gray"
                        font.pointSize: 18
                        font.capitalization: Font.AllUppercase
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Component.onCompleted: {
                        var widthPlusMargins = implicitWidth + 16
                        if (listViewContainer.width < widthPlusMargins) {
                            listViewContainer.width = widthPlusMargins
                        }
                    }
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
