import QtQuick 2.0

Item {
    id: root

    FontLoader { id: lightFont; source: "fonts/ProximaNova-Light.otf" }
    FontLoader { id: mainFont; source: "fonts/ProximaNova-Regular.otf" }
    FontLoader { id: iconFont; source: "fonts/FontAwesome.otf" }

    readonly property alias mainFont: mainFont
    readonly property alias lightFont: lightFont
    readonly property alias iconFont: iconFont

    readonly property alias styles: stylesObject
    QtObject {
        id: stylesObject
        readonly property real radius: 8
        readonly property real borderWidth: 5
        readonly property real borderRadius: borderWidth * 2
    }

    readonly property alias controls: controlsObject
    Item {
        id: controlsObject
        readonly property var colors: controlColors
        QtObject {
            id: controlColors
            readonly property color background: "#444"
            readonly property color disabledBackground: "#777"
            readonly property color text: "white"
            readonly property color disabledText: "#DDD"
            readonly property color focusedText: "yellow"
            readonly property color inputText: "black"
            readonly property color inputBackground: "#EEE"
            readonly property color hintText: "gray"  // A bit darker than sysPalette.dark so that it is visible on the DK2
        }

        readonly property alias layout: controlLayouts
        QtObject {
            id: controlLayouts
            property int spacing: 8
            property int rowHeight: 32
            property int windowTitleHeight: 48
        }
    }

    readonly property alias windows: windowsObject
    Item {
        id: windowsObject
        readonly property alias colors: windowColors
        QtObject {
            id: windowColors
            readonly property color border: root.colors.tron
            readonly property color inactiveBorder: root.controls.colors.background
            readonly property color background: "#FFF"
        }
    }

    readonly property alias colors: colorsObject
    QtObject {
        id: colorsObject
        readonly property color tron: "#008080"
    }

    readonly property alias fonts: fontsObject
    QtObject {
        id: fontsObject
        readonly property alias mainFontName: mainFont.name
        readonly property alias lightFontName: lightFont.name
        readonly property real pixelSize: 22
        readonly property real headerPixelSize: 32
    }

    readonly property alias effects: effectsObject
    QtObject {
        id: effectsObject
        readonly property int fadeInDuration: 300
    }

}
