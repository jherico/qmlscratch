import QtQuick 2.5
import QtQuick.Controls 1.4
import "crossbar"
import "controls"
import "."

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    title: qsTr("Hello World")
    objectName: "parentWindow"
    
    WireFrame {
        property var urlHandler: Item {
            function fixupUrl(url) {
                console.log("Fixup URL: " + url);
                return url
            }
        }

        property var addressManager: Item {
            function navigate(url) {
                console.log("Navigate to: " + url);
            }
        }
        anchors.fill: parent
    }
}
