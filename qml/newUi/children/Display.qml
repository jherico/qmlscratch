import QtQuick 2.5

import "../../controls/crossbar"

CrossBarMenuChild {
    id: root
    property string path: "Display";
    property var menu: Utils.findInRootMenu(root, root.path);
    model: Utils.menuItemsToListModel(root, root.menu.items);
    name: "Display"
}
