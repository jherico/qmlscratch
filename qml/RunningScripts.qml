import QtQuick 2.5
import QtQuick.Controls 1.4

import "vr" as Vr
import "vr/controls" as VrControls

Item {
    id: root
    Vr.Constants { id: vr }
    implicitWidth: 384; implicitHeight: 640

    property var scripts: ScriptDiscoveryService;
    property var scriptsModel: scripts.scriptsModelFilter
    property var runningScriptsModel: ListModel { }

    Connections {
        target: ScriptDiscoveryService
        onScriptCountChanged: updateRunningScripts();
    }

    Component.onCompleted: updateRunningScripts()
    onVisibleChanged: if(visible) updateRunningScripts();

    function updateRunningScripts() {
        var runningScripts = ScriptDiscoveryService.getRunning();
        runningScriptsModel.clear()
        for (var i = 0; i < runningScripts.length; ++i) {
            runningScriptsModel.append(runningScripts[i]);
        }
    }

    function loadScript(script) {
        console.log("Load script " + script);
        scripts.loadOneScript(script);
    }

    function reloadScript(script) {
        console.log("Reload script " + script);
        scripts.stopScript(script, true);
    }

    function stopScript(script) {
        console.log("Stop script " + script);
        scripts.stopScript(script);
    }

    function reloadAll() {
        console.log("Reload all scripts");
        scripts.reloadAllScripts();
    }

    function stopAll() {
        console.log("Stop all scripts");
        scripts.stopAllScripts();
    }

    Item {
        anchors { fill: parent; margins: 8 }

        Text {
            id: title
            font.bold: true
            font.pointSize: 16
            color: "#0e7077"
            text: "Currently Running"
        }

        Row {
            id: allButtons
            anchors.top: title.bottom
            anchors.topMargin: 8
            spacing: 8
            Button { text: "Reload all"; onClicked: reloadAll() }
            Button { text: "Stop all"; onClicked: stopAll() }
        }

        ListView {
            clip: true
            anchors {
                top: allButtons.bottom;
                left: parent.left;
                right: parent.right;
                topMargin: 8
                bottom: row1.top
                bottomMargin: 8
            }

            model: runningScriptsModel

            delegate: Rectangle {
                radius: 3
                anchors { left: parent.left; right: parent.right }

                height: scriptName.height + 12
                color: index % 2 ? "#ddd" : "#eee"

                Text {
                    anchors { left: parent.left; leftMargin: 4; verticalCenter: parent.verticalCenter }
                    id: scriptName
                    text: name
                }

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 4
                    spacing: 4
                    VrControls.FontAwesome {
                        text: "\uf021"; size: scriptName.height;
                        MouseArea {
                            anchors { fill: parent; margins: -2; }
                            onClicked: reloadScript(model.url)
                        }
                    }
                    VrControls.FontAwesome {
                        size: scriptName.height; text: "\uf00d"
                        MouseArea {
                            anchors { fill: parent; margins: -2; }
                            onClicked: stopScript(model.url)
                        }
                    }
                }
            }
        }


        Text {
            id: loadLabel
            text: "Load Scripts"
            font.bold: true
            font.pointSize: 16
            color: "#0e7077"

            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: filterEdit.top
            anchors.bottomMargin: 8
        }

        Row {
            id: row1
            spacing: 8
            anchors.bottom: filterEdit.top
            anchors.bottomMargin: 8
            anchors.right: parent.right
            Button { text: "from URL" }
            Button { text: "from Disk" }
        }

        TextField {
            id: filterEdit
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: treeView.top
            anchors.bottomMargin: 8
            placeholderText: "filter"
            onTextChanged: scriptsModel.filterRegExp =  new RegExp("^.*" + text + ".*$")
        }

        TreeView {
            id: treeView
            height: 128
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            headerVisible: false
            onDoubleClicked: isExpanded(index) ? collapse(index) : expand(index)
            onActivated: {
                var path = scriptsModel.data(index, 0x100)
                if (path) {
                    loadScript(path)
                }
            }

            //color: "#7fff0000"
            model: scriptsModel
            TableViewColumn {
                title: "Name"
                role: "display"
            }
        }
    }
}

