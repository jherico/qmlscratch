import QtQuick 2.5
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0

import "../controls"
import "../controls/crossbar"
import "../../js/utils.js" as Utils
import "../../js/Global.js" as Global
import "children" as Child

FocusScope {
    id: topRoot
    clip: true

    FontLoader { id: lightFont; source: "fonts/ProximaNova-Light.otf" }
    FontLoader { id: mainFont; source: "fonts/ProximaNova-Regular.otf" }

    Component.onCompleted: {
        crossBar.restore();
        if (enabled) {
            if (Global.Interfaces.Account.isLoggedIn()) {
                username.text = Global.Interfaces.Account.getUsername();
            }
        }
    }

    onEnabledChanged: {
        crossBar.restore()
        if (enabled) {
            if (Global.Interfaces.Account.isLoggedIn()) {
                username.text = Global.Interfaces.Account.getUsername();
            }
        }
        // FIXME this will break once we have more than one dialog visible
        offscreenFlags.navigationFocused = enabled;
    }

    // Blur for the content when a cross bar child item is up
    GaussianBlur {
        id: blur
        z: content.z - 1
        anchors.fill: parent
        source: content
        radius: 8
        samples: 16
        visible: false
    }

    // Enclose the content in a single rectangle in order to
    // support the blur effect (blur and target should be siblings)
    Rectangle {
        color: "white"
        id: content
        anchors.fill: parent
        Row {
            spacing: 48
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height * 0.1

            IconOverText {
                id: quitIcon
                icon: "\uf00d"
                text: "Quit"

                onPressed: Qt.quit()
                KeyNavigation.down: crossBar
                KeyNavigation.left: resumeIcon
                KeyNavigation.right: resumeIcon
            }

            // Spacer to account for the asymmetry of the
            // text item with wide letter spacing
            Item { width: 10; height: 1 }

            Text {
                anchors.top: parent.top
                font.weight: Font.Thin
                anchors.bottom: parent.bottom
                font.family: lightFont.name
                font.letterSpacing: 10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.capitalization: Font.AllUppercase
                text: "Paused"
                font.pointSize: 24
            }

            IconOverText {
                id: resumeIcon
                icon: "\uf04b"
                text: "Resume"
                onPressed: {
                    Utils.closeDialog(topRoot)
                }
                KeyNavigation.down: crossBar
                KeyNavigation.left: quitIcon
                KeyNavigation.right: quitIcon
            }
        }

        CrossBar {
            id: crossBar
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height / 3.0
            y: parent.height / 3.0
            targetParent: topRoot

            subItems: [ subHifi, subMic, subAudio, subView, subDisplay, subDirectory, subMarket, subSettings ]

            model: ListModel {
                ListElement { icon: "/images/hifi-logo.svg" }
                ListElement { name: "Mic" }
                ListElement { name: "Audio" }
                ListElement { name: "View" }
                ListElement { name: "Display" }
                ListElement { name: "Directory" }
                ListElement { name: "Market" }
                ListElement { name: "Settings" }
            }

            Component { id: subHifi; Child.Hifi { } }
            Component { id: subMic; Child.Mic { } }
            Component { id: subAudio; Child.Audio { } }
            Component { id: subDirectory; Child.Directory { } }
            Component { id: subMarket; Child.Market { } }
            Component { id: subDisplay; Child.Display { } }
            Component { id: subSettings; Child.Settings { } }
            Component { id: subView; Child.View { } }


            onChildOpened: {
                blur.visible = true
                content.visible = false
            }

            onRestore: {
                content.visible = true
                blur.visible = false
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: forceActiveFocus()
            }

            KeyNavigation.up: resumeIcon
            KeyNavigation.down: resumeIcon
        }

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height * 0.8

            Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: "Update Available"
                font.family: lightFont.name
                font.pointSize: 12
            }

            Item {
                width: 1
                height: 8
            }

            Text {
                id: username
                anchors.left: parent.left
                anchors.right: parent.right
                text: "Unknown User"
                font.pointSize: 16
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    function closeOverlayWindow(item) {
        while (item && item.objectName !== "topLevelWindow") {
            item = item.parent
        }
        if (item) {
            item.enabled = false
        } else {
            console.warn("No top level window found")
        }
    }

    Keys.onEscapePressed: closeOverlayWindow(topRoot)

    KeyNavigation.up: crossBar
    KeyNavigation.down: crossBar
    KeyNavigation.left: crossBar
    KeyNavigation.right: crossBar
}
