import QtQuick 2.0
import QtQuick.Controls 1.4

import "../../js/utils.js" as Utils

ListView {
    id: root
    focus: true
    highlight: Rectangle { color: "lightsteelblue"; radius: 3 }
    onContentHeightChanged: height = contentHeight
    delegate: Item {
        id: menuDelegate
        implicitWidth: text.implicitWidth + check.width * 2
        implicitHeight: text.implicitHeight
        anchors.left: parent.left
        anchors.right: parent.right
        enabled: ((item.type === MenuItemType.Menu) && item.items.length != 0) ||
                 ((item.type === MenuItemType.Item) && item.enabled)

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (index == root.currentIndex) {
                    root.trigger()
                } else {
                    root.currentIndex = index;
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: (parent.height / 2) - 2
            visible: item.type === MenuItemType.Separator
            color: "gray"
            radius: 2
        }

        FontAwesome{
            id: check
            text: "\uf00c"
            visible: (item.type === MenuItemType.Item) && item.checkable && item.checked
            size: 16
            anchors.top: text.top
            anchors.bottom: text.bottom
            anchors.right: text.left
            anchors.rightMargin: 4
        }

        Text {
            id: text
            text: name
            visible: item.type !== MenuItemType.Separator
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: lightFont.name
            color: menuDelegate.enabled ? "#222" : "gray"
            font.pointSize: 18
            font.capitalization: Font.AllUppercase
            horizontalAlignment: Text.AlignHCenter
        }

        FontAwesome{
            id: sub
            text: "\uf0da"
            visible: item.type === MenuItemType.Menu
            color: menuDelegate.enabled ? "#222" : "gray"
            size: 16
            anchors.top: text.top
            anchors.bottom: text.bottom
            anchors.right: parent.right
        }

        Component.onCompleted: {
            if (root.width < implicitWidth) {
                root.width = implicitWidth
            }
        }
    }

    signal triggered(var menu)
    signal triggerFailed(var menu)

    Rectangle {
        id: border
        z: root.z - 1
        anchors.fill: parent
        anchors.margins: -8
        color: "white"
        radius: 10
        border.width: 5
        border.color: "gray"
    }

    function trigger() {
        if (currentIndex < 0 || currentIndex > model.length) {
            console.warn("Invalid current index, should never happen");
            return;
        }

        if (!currentItem) {
            console.warn("No current item, should never happen");
            return;
        }

        if (!currentItem.enabled) {
            return;
        }

        var item = model.get(currentIndex).item;
        if (!item) {
            console.warn("Missing model item, should never happen");
            return;
        }

        root.triggered(item);
    }

    Keys.onUpPressed: decrementCurrentIndex()
    Keys.onDownPressed: incrementCurrentIndex()
    Keys.onReturnPressed: trigger()
    Keys.onSpacePressed: trigger()
    Keys.onEnterPressed: trigger()
}

