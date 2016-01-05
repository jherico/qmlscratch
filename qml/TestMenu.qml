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
        title: "EditLongName"

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

        Menu {
            title: "More Stuff"

            MenuItem {
                text: "Do Nothing"
                onTriggered: console.log("Nothing")
            }
        }
    }

    Menu {
        title: "View"
        Menu {
            title: "Camera Mode"
            MenuItem {
                text: "First Person";
                onTriggered: console.log(text)
            }
            MenuItem {
                text: "Third Person";
                onTriggered: console.log(text)
            }
            MenuItem {
                text: "Independent Mode";
                onTriggered: console.log(text)
            }
            MenuItem {
                text: "Entity Mode";
                onTriggered: console.log(text)
            }
            MenuItem {
                text: "Fullscreen Mirror";
                onTriggered: console.log(text)
            }
        }
    }
}
