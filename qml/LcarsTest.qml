import QtQuick 2.0

Item {

    Action {
        shortcut: "Ctrl-Q"
        onTriggered: Qt.quit()
    }

    Rectangle {
        color: "black"
        anchors.fill: parent

        Lcars.Constants {
            id: lcars
        }

        Item {
            anchors.fill: parent
            anchors.margins: 10
            Rectangle {
                radius: 32
                height: 64
                color: lcars.colors.pink
                anchors.left: parent.left
                anchors.right: parent.right
                Rectangle {
                    x: 64
                    color: "black"
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: label.width + 16
                    Text {
                        id: label
                        x: 8
                        y: -12
                        font.pointSize: 64
                        fontSizeMode: Text.FixedSize
                        verticalAlignment: Text.AlignVCenter
                        color: lcars.colors.orange
                        font.family: lcars.fonts.narrowFontName
                        font.capitalization: Font.AllUppercase
                        text: "SYSTEM INFO"
                    }
                }
            }
        }
    }
}

