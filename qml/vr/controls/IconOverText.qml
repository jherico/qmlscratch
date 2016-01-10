import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

FocusScope {
    id: root
    property alias icon: icon.text
    property alias text: text.text
    property real spacing: 8
    implicitHeight: icon.height + text.height + spacing + spacing
    implicitWidth: Math.max(icon.width, text.width) + spacing

    signal pressed()

    FontAwesome {
        anchors.top: parent.top
        anchors.topMargin: root.spacing / 2
        id: icon
        anchors.horizontalCenter: parent.horizontalCenter
        size: 12
    }

    MouseArea {
        hoverEnabled: true
        onEntered: forceActiveFocus()
        anchors.fill: parent
        onClicked: root.pressed();
    }

    Keys.onReturnPressed: root.pressed();

    Text {
        id: text
        anchors.top: icon.bottom
        anchors.topMargin: root.spacing
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 8
        font.family: lightFont.name
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
        visible: root.activeFocus
        anchors.fill: parent
        z: text.z - 1
        color: "lightsteelblue"
    }
}
