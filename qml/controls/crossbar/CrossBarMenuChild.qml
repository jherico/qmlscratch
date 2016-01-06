import QtQuick 2.5
import QtQuick.Controls 1.4

import ".."
import "../../../js/utils.js" as Utils

CrossBarChild {
    id: root
    property var model;
    property var modelStack: []

    delegate: Component {
        id: component
        ListMenu {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            model: root.model

            onTriggered: switch (menu.type) {
                case MenuItemType.Menu:
                    modelStack.push(root.model);
                    root.model = Utils.menuItemsToListModel(root, menu.items);
                    currentIndex = 0
                    break;

                case MenuItemType.Item:
                    if (menu.exclusiveGroup && menu.checked) {
                        console.log("Can't trigger an already selected radio item");
                        return;
                    }
                    menu.trigger();
                    closeChild();
                    Utils.closeDialog(root);
                    break;

                case MenuItemType.Separator:
                case MenuItemType.ScrollIndicator:
                default:
                    break;
            }

            // Allow back navigation through the menu stack
            Keys.onPressed: {
                if (event.key === Qt.Key_Left && modelStack.length) {
                    root.model = modelStack.pop();
                    event.accepted = true
                }
            }
        }
    }

}
