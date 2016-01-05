import QtQuick 2.5

import "../crossbar"
import "../../js/utils.js" as Utils

CrossBarMenuChild {
    id: root
    property var path: ["View", "Camera Mode"];
    property var menu: Utils.findInRootMenu(root, root.path);
    model: Utils.menuItemsToListModel(root, root.menu.items);
}


