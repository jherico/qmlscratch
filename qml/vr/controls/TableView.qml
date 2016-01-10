import QtQuick 2.5
import QtQuick.Controls 1.4 as Original
import QtQuick.Controls.Styles 1.4

import ".."

Original.TableView {
    Constants { id: vr }

    id: root
    frameVisible: false

    headerDelegate: Rectangle {
        height: headerName.height
        width: parent.width
        clip: true
        radius: 3
        color: vr.controls.colors.background

        Text {
            id: headerName
            font.family: vr.fonts.mainFontName
            font.pointSize: 12
            font.bold: true
            text: styleData.value
            color: vr.controls.colors.text
        }
    }

    rowDelegate:  Rectangle {
        radius: 3
        color: styleData.selected ? "#444" : styleData.alternate ? "#ddd" : "#eee"
    }

    itemDelegate: Item {
        Text {
            anchors.verticalCenter: parent.verticalCenter
            font.family: vr.fonts.lightFontName
            font.pointSize: 12
            color: tableView.activeFocus && styleData.row === tableView.currentRow ? vr.controls.colors.focusedText : styleData.textColor
            elide: styleData.elideMode
        }
    }
}

