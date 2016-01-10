import QtQuick 2.3

import ".."

Rectangle {
    Constants { id: vr }
    implicitHeight: 64
    implicitWidth: 64
    color: vr.windows.colors.background
    border.color: vr.controls.colors.background
    border.width: vr.styles.borderWidth
    radius: vr.styles.borderRadius
}

