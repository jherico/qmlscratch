import QtQuick 2.5
import QtQuick.Controls 1.4
import Qt.labs.settings 1.0

import "file:///C:/Users/bdavis/Git/hifi/interface/resources/qml"
import "file:///C:/Users/bdavis/Git/hifi/interface/resources/qml/windows"

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    title: qsTr("Scratch App")

    Root {
        id: desktop
        anchors.fill: parent

        Row {
            anchors { margins: 8; left: parent.left; top: parent.top }
            spacing: 8
            Button {
                text: "restore all"
                onClicked: {
                    for (var i = 0; i < desktop.windows.length; ++i) {
                        desktop.windows[i].enabled = true
                    }
                }
            }

            Button {
                text: "add web tab"
                onClicked: {
                    desktop.toolWindow.addWebTab({
                        title: "test",
                        source: "file:///C:/Users/bdavis/Git/hifi/examples/html/entityProperties.html",
                        width: 500, height: 720
                    });
                }
            }

        }


        Window {
            id: blue
            x: 1280 / 2; y: 720 / 2
            closable: false
            Settings {
                category: "TestWindow.Position"
                property alias x: blue.x
                property alias y: blue.y
            }

            width: 100; height: 100
            resizable: false
            Rectangle {
                anchors.fill: parent
                color: "blue"
            }
        }
    }

    /*

    Item {
        id: desktop
        anchors.fill: parent
        objectName: Desktop._OFFSCREEN_ROOT_OBJECT_NAME
        property bool uiVisible: true
        property variant toolbars: { "_root" : null }
        focus: true



        Arcane.Test {
            anchors.centerIn: parent
            height: 600; width: 600
        }

        Rectangle {
            id: root
            Vr.Constants { id: vr }
            implicitWidth: 384; implicitHeight: 640
            anchors.centerIn: parent
            color: vr.windows.colors.background
            border.color: vr.controls.colors.background
            border.width: vr.styles.borderWidth
            radius: vr.styles.borderRadius
            RunningScripts { }
        }

        FileDialog {
            id: fileDialog
            width: 800; height: 600
            anchors.centerIn: parent
            onSelectedFile: console.log("Chose file " + file)
        }
        Timer {
            id: timer
            running: false
            interval: 100
            onTriggered: wireFrameContainer.enabled = true
        }

        Item {
            id: wireFrameContainer
            objectName: Desktop._OFFSCREEN_DIALOG_OBJECT_NAME
            anchors.fill: parent
            onEnabledChanged: if (!enabled) timer.running = true

            NewUi.Main {
                id: wireFrame
                anchors.fill: parent

                property var offscreenFlags: Item {
                    property bool navigationFocused: false
                }

                property var urlHandler: Item {
                    function fixupUrl(url) {
                        var urlString = url.toString();
                        if (urlString.indexOf("https://metaverse.highfidelity.com/") !== -1 &&
                            urlString.indexOf("access_token") === -1) {
                            console.log("metaverse URL, fixing")
                            return urlString + "?access_token=875885020b1d5f1ea694ce971c8601fa33ffd77f61851be01ed1e3fde8cabbe9"
                        }
                        return url
                    }

                    function canHandleUrl(url) {
                        var urlString = url.toString();
                        if (urlString.indexOf("hifi://") === 0) {
                            console.log("Can handle hifi addresses: " + urlString)
                            return true;
                        }

                        if (urlString.indexOf(".svo.json?") !== -1) {
                            console.log("Can handle svo json addresses: " + urlString)
                            return true;
                        }

                        if (urlString.indexOf(".js?") !== -1) {
                            console.log("Can handle javascript addresses: " + urlString)
                            return true;
                        }

                        return false
                    }

                    function handleUrl(url) {
                        return true
                    }
                }

                property var addressManager: Item {
                    function navigate(url) {
                        console.log("Navigate to: " + url);
                    }
                }
            }
        }
        Keys.onMenuPressed: desktop.uiVisible = !desktop.uiVisible
        Keys.onEscapePressed: desktop.uiVisible = !desktop.uiVisible
        }
*/
}
