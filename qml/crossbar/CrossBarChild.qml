import QtQuick 2.5
import QtQuick.Controls 1.4

FocusScope {
    id: root
    anchors.fill: parent
    visible: false
    enabled: visible
    property var crossBar: null

    function closeChild() {
        visible = false
        root.crossBar.restore()
    }

    Action {
        shortcut: "Escape"
        onTriggered: root.closeChild()
        enabled: root.visible
    }

    Keys.onEscapePressed: {
        closeChild()
    }
}
