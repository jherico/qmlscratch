import QtQuick 2.5
import QtQuick.Controls 1.4

Menu {
    id: root
    objectName: "rootMenu"
    Menu {
        title: "File"
        MenuItem {
            text: "Quit"
            shortcut: "Ctrl+Q"
            onTriggered: Qt.quit()
        }
    }
    Menu {
        title: "Edit"

        MenuItem {
            text: "Cut"
            shortcut: "Ctrl+X"
            onTriggered: console.log("Cut")
        }

        MenuItem {
            text: "Copy"
            shortcut: "Ctrl+C"
            enabled: false
            onTriggered: console.log("Copy")
        }

        MenuItem {
            text: "Paste"
            shortcut: "Ctrl+V"
            visible: false
            onTriggered: console.log("Paste")
        }

        MenuSeparator { }

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
}
