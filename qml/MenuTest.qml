import QtQuick 2.0

import "menu"

FocusScope {
    anchors.fill: parent
    focus: true
    TestMenu {
        id: rootMenu
    }

    VrMenu {
        id: vrMenu
        rootMenu: rootMenu
    }

    Keys.onMenuPressed: {
        console.log("Menu press");
        vrMenu.lastMousePosition.x = mouseArea.mouseX
        vrMenu.lastMousePosition.y = mouseArea.mouseY
        vrMenu.enabled = !vrMenu.enabled;
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            vrMenu.lastMousePosition.x = mouseX
            vrMenu.lastMousePosition.y = mouseY
            vrMenu.enabled = !vrMenu.enabled;
        }
    }

}

