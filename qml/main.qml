import QtQuick 2.5
import QtQuick.Controls 1.4

import "controls"
import "."
import "../js/utils.js" as Utils
import "newUi" as NewUi

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    title: qsTr("Scratch App")

    Item {
        anchors.fill: parent
        objectName: Utils.OFFSCREEN_ROOT_OBJECT_NAME
        property var rootMenu: TestMenu { objectName: "rootMenu" }

        Timer {
            id: timer
            running: false
            interval: 100
            onTriggered: wireFrameContainer.enabled = true
        }

        Item {
            id: wireFrameContainer
            objectName: Utils.OFFSCREEN_DIALOG_OBJECT_NAME
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

    }
}
