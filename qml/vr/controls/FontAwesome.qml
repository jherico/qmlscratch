import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import ".."

Text {
    FontLoader { id: iconFont; source: "../fonts/FontAwesome.otf" }
    id: root
    property int size: 32
    width: size
    height: size
    font.pixelSize: size
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    font.family: iconFont.name
}

