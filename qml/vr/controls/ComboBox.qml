import QtQuick 2.3
import QtQuick.Controls 1.3 as Original
import QtQuick.Controls.Styles 1.3

import ".."

Original.ComboBox {
    Constants { id: vr }
    readonly property var colors: vr.controls.colors
    property var textColor: !enabled ? colors.disabledText : activeFocus ? colors.focusedText : colors.text
    style: ComboBoxStyle {
        background: Rectangle {
            implicitWidth: 200
            implicitHeight: 32
            anchors.fill: parent
            radius: vr.styles.borderRadius
            color: !control.enabled ? colors.disabledBackground : colors.background
            FontAwesome {
                id: glyph
                size: 16
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10
                text: "\uF078"
                color: control.textColor
                states: State {
                    name: "inverted"
                    when: __popup.__popupVisible
                    PropertyChanges { target: glyph; rotation: 180 }
                }

                transitions: Transition {
                    RotationAnimation { duration: 250; direction: RotationAnimation.Clockwise }
                }
            }
        }

        label: Text {
            font.family: vr.mainFont.name
            verticalAlignment: Qt.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 5
            text: control.currentText
            color: control.textColor
            anchors.fill: parent
            font.pointSize: 14
        }
    }
}
