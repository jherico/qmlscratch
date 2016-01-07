import QtQuick 2.5
import QtQuick.Controls 1.4

Item {

    Item {
        objectName: "Account"
        function isLoggedIn() { return true; }
        function getUsername() { return "Jherico"; }
    }

    Item {
        id: menuHelper
        objectName: "MenuHelper"

        Component {
            id: modelMaker
            ListModel { }
        }

        function toModel(menu, parent) {
            if (!parent) { parent = menuHelper }
            var result = modelMaker.createObject(parent);
            if (menu.type !== MenuItemType.Menu) {
                console.warn("Not a menu: " + menu);
                return result;
            }

            var items = menu.items;
            for (var i = 0; i < items.length; ++i) {
                var item = items[i];
                switch (item.type) {
                case 2:
                    result.append({"name": item.title, "item": item})
                    break;
                case 1:
                    result.append({"name": item.text, "item": item})
                    break;
                case 0:
                    result.append({"name": "", "item": item})
                    break;
                }
            }
            return result;
        }

    }

    Item {
        objectName: "Desktop"

        property string _OFFSCREEN_ROOT_OBJECT_NAME: "desktopRoot";
        property string _OFFSCREEN_DIALOG_OBJECT_NAME: "topLevelWindow";


        function findChild(item, name) {
            for (var i = 0; i < item.children.length; ++i) {
                if (item.children[i].objectName === name) {
                    return item.children[i];
                }
            }
            return null;
        }

        function findParent(item, name) {
            while (item) {
                if (item.objectName === name) {
                    return item;
                }
                item = item.parent;
            }
            return null;
        }

        function findDialog(item) {
            item = findParent(item, _OFFSCREEN_DIALOG_OBJECT_NAME);
            return item;
        }

        function closeDialog(item) {
            item = findDialog(item);
            if (item) {
                item.enabled = false
            } else {
                console.warn("Could not find top level dialog")
            }
        }
    }

    Menu {
        id: root
        objectName: "rootMenu"

        Menu {
            title: "Audio"
        }

        Menu {
            title: "Avatar"
        }

        Menu {
            title: "Display"
            ExclusiveGroup { id: displayMode }
            Menu {
                title: "More Stuff"

                Menu { title: "Empty" }

                MenuItem {
                    text: "Do Nothing"
                    onTriggered: console.log("Nothing")
                }
            }
            MenuItem {
                text: "Oculus"
                exclusiveGroup: displayMode
                checkable: true
            }
            MenuItem {
                text: "OpenVR"
                exclusiveGroup: displayMode
                checkable: true
            }
            MenuItem {
                text: "OSVR"
                exclusiveGroup: displayMode
                checkable: true
            }
            MenuItem {
                text: "2D Screen"
                exclusiveGroup: displayMode
                checkable: true
                checked: true
            }
            MenuItem {
                text: "3D Screen (Active)"
                exclusiveGroup: displayMode
                checkable: true
            }
            MenuItem {
                text: "3D Screen (Passive)"
                exclusiveGroup: displayMode
                checkable: true
            }
        }

        Menu {
            title: "View"
            Menu {
                title: "Camera Mode"
                ExclusiveGroup { id: cameraMode }
                MenuItem {
                    exclusiveGroup: cameraMode
                    text: "First Person";
                    onTriggered: console.log(text + " checked " + checked)
                    checkable: true
                    checked: true
                }
                MenuItem {
                    exclusiveGroup: cameraMode
                    text: "Third Person";
                    onTriggered: console.log(text)
                    checkable: true
                }
                MenuItem {
                    exclusiveGroup: cameraMode
                    text: "Independent Mode";
                    onTriggered: console.log(text)
                    checkable: true
                }
                MenuItem {
                    exclusiveGroup: cameraMode
                    text: "Entity Mode";
                    onTriggered: console.log(text)
                    enabled: false
                    checkable: true
                }
                MenuItem {
                    exclusiveGroup: cameraMode
                    text: "Fullscreen Mirror";
                    onTriggered: console.log(text)
                    checkable: true
                }
            }
        }

        Menu {
            title: "Edit"

            MenuItem {
                text: "Undo"
                shortcut: "Ctrl+Z"
                enabled: false
                onTriggered: console.log(text)
            }

            MenuItem {
                text: "Redo"
                shortcut: "Ctrl+Shift+Z"
                enabled: false
                onTriggered: console.log(text)
            }

            MenuSeparator { }

            MenuItem {
                text: "Cut"
                shortcut: "Ctrl+X"
                onTriggered: console.log(text)
            }

            MenuItem {
                text: "Copy"
                shortcut: "Ctrl+C"
                onTriggered: console.log(text)
            }

            MenuItem {
                text: "Paste"
                shortcut: "Ctrl+V"
                visible: false
                onTriggered: console.log("Paste")
            }
        }

        Menu {
            title: "Navigate"
        }

        Menu {
            title: "Market"
        }

        Menu {
            title: "Settings"
        }

        Menu {
            title: "Developer"
        }

        Menu {
            title: "Quit"
        }

        Menu {
            title: "File"

            Action  {
                id: login
                text: "Login"
            }

            Action  {
                id: quit
                text: "Quit"
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit();
            }

            MenuItem { action: quit }
            MenuItem { action: login }
        }
    }

}

