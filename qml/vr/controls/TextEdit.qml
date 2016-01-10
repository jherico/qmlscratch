import QtQuick 2.3 as Original
import QtQuick.Controls.Styles 1.3

import ".."

Original.TextEdit {
    Constants { id: vr }
    font.family: vr.mainFont.name
    font.pixelSize: vr.fonts.pixelSize
    verticalAlignment: Original.Text.AlignVCenter
    // FIXME support disabled / active focus coloring
    color: vr.controls.colors.inputText
}


