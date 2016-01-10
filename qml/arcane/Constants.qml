import QtQuick 2.0

Item {
    id: root
    FontLoader { id: arcaneFont; source: "fonts/Mage Script.otf" }
    readonly property alias arcaneFont: arcaneFont

    FontLoader { id: demonicFont; source: "fonts/Daedra.otf" }
    readonly property alias demonicFont: demonicFont

    function randomLetter() {
        var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        return letters.substr(Math.random() * letters.length, 1);
    }

}
