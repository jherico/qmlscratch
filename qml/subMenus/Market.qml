import QtQuick 2.5
import QtQuick.Controls 1.4
import QtWebEngine 1.1

import "../crossbar"
import "../controls"

CrossBarChild {
    id: root

    Action {
        shortcut: "Escape"
        onTriggered: root.closeChild()
        enabled: root.visible
    }

    Rectangle {
        width: 800; height: 600
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
        radius: 10
        border.width: 5
        border.color: "gray"

        HifiWebView {
            id: webview
            anchors.fill: parent
            anchors.margins: 10
            url: "https://metaverse.highfidelity.com/marketplace"
        }
    }
}
