import QtQuick 2.5
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0

import "crossbar"
import "controls"
import "subMenus" as Sub

Item {
    id: topRoot
    clip: true

    FontLoader { id: lightFont; source: "../fonts/ProximaNova-Light.otf" }
    FontLoader { id: mainFont; source: "../fonts/ProximaNova-Regular.otf" }

    Sub.Mic {
        id: subMic
        crossBar: crossBar
    }
    Sub.Audio {
        id: subAudio
        crossBar: crossBar
    }
    Sub.Directory {
        id: subDirectory
        crossBar: crossBar
    }
    Sub.Market {
        id: subMarket
        crossBar: crossBar
    }
    Sub.Display {
        id: subDisplay
        crossBar: crossBar
    }
    Sub.Settings {
        id: subSettings
        crossBar: crossBar
    }
    Sub.View {
        id: subView
        crossBar: crossBar
    }

    onEnabledChanged: {
        console.log("Enabled changed " + enabled);
        crossBar.restore()
        if (enabled) {
            if (Account.isLoggedIn()) {
                username.text = Account.getUsername();
            }
        }
        // FIXME this will break once we have more than one dialog visible
        offscreenFlags.navigationFocused = enabled;
    }

    GaussianBlur {
        id: blur
        z: content.z - 1
        anchors.fill: parent
        source: content
        radius: 8
        samples: 16
        visible: false
    }

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

            Item {
                width: 10
                height: 1
            }

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
                    var obj = topRoot;
                    // Find the parent object
                    while (obj != null && obj.objectName != "topLevelWindow") {
                        obj = obj.parent
                    }
                    if (obj) {
                        obj.enabled = false;
                    }
                }
                KeyNavigation.down: crossBar
                KeyNavigation.left: quitIcon
                KeyNavigation.right: quitIcon
            }
        }


        CrossBar {
            id: crossBar
            focus: true
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height / 3.0
            y: parent.height / 3.0

            model: ListModel {
                ListElement { name: "Mic" }
                ListElement { name: "Audio" }
                ListElement { name: "View" }
                ListElement { name: "Display" }
                ListElement { name: "Directory" }
                ListElement { name: "Market" }
                ListElement { name: "Settings" }
            }

            subItems: [ subMic, subAudio, subView, subDisplay, subDirectory, subMarket, subSettings ]

            onFocusChanged: {
                if (crossBar.activeFocus) {
                    blur.visible = false
                }
            }


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
    KeyNavigation.up: crossBar
    KeyNavigation.down: crossBar
    KeyNavigation.left: crossBar
    KeyNavigation.right: crossBar
}
