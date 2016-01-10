import QtQuick 2.3
import QtQuick.Controls 1.3 as Original
import QtQuick.Controls.Styles 1.3

import ".."

Original.Button {
    style: ButtonStyle {
        Constants { id: vr }
        padding { top: 4; bottom: 4; left: 16; right: 16 }
        readonly property var colors: vr.controls.colors

        background:  Rectangle {
            anchors.fill: parent
            radius: 8
            color: control.enabled ? colors.background : colors.disabledBackground
        }

        label: Text {
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: vr.mainFont.name
            font.bold: true
            font.pixelSize: vr.fonts.pixelSize
            text: control.text
            color: !control.enabled ? colors.disabledText : control.activeFocus ? colors.focusedText : colors.text
        }
    }
}


