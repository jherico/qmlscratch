import QtQuick 2.4

Item {
    FontLoader { id: mainFont; source: "fonts/tt0105m_.TTF" }
    FontLoader { id: narrowFont; source: "fonts/tt0106m0.TTF" }

    readonly property alias colors: colors
    readonly property alias layout: layout
    readonly property alias fonts: fonts
    readonly property alias styles: styles
    readonly property alias effects: effects

    Item {
        id: colors
        readonly property color orange: "#F90"
        readonly property color pink: "#C9C"
        readonly property color brown: "#C66"
        readonly property color cyan: "#9CF"
        readonly property color blue: "#66F"
        readonly property color lightBlue: "#69C"
        readonly property color purple: "#96F"
        readonly property color lilac: "#CCF"
        readonly property color red: "#F30"
        readonly property color darkRed: "#C30"
     }

    QtObject {
        id: fonts
        readonly property string mainFontName: mainFont.name
        readonly property string narrowFontName: narrowFont.name
        readonly property real pixelSize: 22  // Logical pixel size; works on Windows and OSX at varying physical DPIs
        readonly property real headerPixelSize: 32
    }

    QtObject {
        id: layout
        property int spacing: 8
        property int rowHeight: 40
        property int windowTitleHeight: 48
    }

    QtObject {
        id: styles
        readonly property int borderWidth: 5
        readonly property int borderRadius: borderWidth * 2
    }

    QtObject {
        id: effects
        readonly property int fadeInDuration: 300
    }
}
