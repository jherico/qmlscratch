import QtQuick 2.0

import "../controls"

Item {
    id: root
    Connections { target: desktop; onUiVisibleChanged: updateVisibility() }
    property bool pinned: false
    property bool closed: false
    property bool closeable: true

    QtObject {
        id: d
        property vector2d controlPadding:
            Qt.vector2d(-2.0 * desktopControls.anchors.margins,
                        -1.0 * (desktopControls.anchors.margins + desktopControls.anchors.topMargin))
    }


    onPinnedChanged: updateVisibility();
    onClosedChanged: updateVisibility()

    Connections {
        target: desktop
        onUiVisibleChanged: updateVisibility();
    }


    function clamp(value, min, max) {
        return Math.min(Math.max(value, min), max);
    }

    function moveTo(inX, inY) {
        var min = Qt.vector2d(0 - desktopControls.anchors.margins,
                              0 - desktopControls.anchors.topMargin)
        var max = Qt.vector2d(desktop.width - width - d.controlPadding.x,
                              desktop.height - height - d.controlPadding.y)

        console.log(min)
        console.log(max)
        var newX = inX ? inX : Math.random() * (max.x - min.x) + min.x
        var newY = inY ? inY : Math.random() * (max.y - min.y) + min.y
        x = clamp(newX, min.x, max.x);
        y = clamp(newY, min.y, max.y);
    }


    function close() {
        closed = true;
    }

    function updateVisibility() {
        if (closed) {
            visible = false;
            return;
        }

        if (pinned) {
            visible = true;
            return;
        }

        visible = desktop.uiVisible;
    }


    Rectangle {
        color: "#3f00ffff"
        z: -1
        id: desktopControls
        anchors.fill: parent
        visible: desktop.uiVisible
        anchors {
            fill: parent;
            margins: -12
            topMargin: -24;
        }

        MouseArea {
            id: controlsArea
            anchors.fill: parent
            hoverEnabled: true
            drag {
                target: root
            }

        }

        Row {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 4
            anchors.topMargin: 4
            spacing: 4

            FontAwesome {
                text: "\uf08d"
                size: 16
                color: root.pinned ? "red" : "black"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.pinned = !root.pinned
                    }
                }
            }

            FontAwesome {
                text: closeClickArea.containsMouse ? "\uf057" : "\uf05c"
                size: 16
                MouseArea {
                    id: closeClickArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.close();
                }
            }
        }
    }

}
