var Interfaces = function(){
    if (typeof Account === 'undefined') {
        return {
            Account: {
                isLoggedIn: function() { return true; },
                getUsername: function() { return "Jherico"; }
            }
        }
    } else {
        var result = {};
        result['Account'] = Account;
        return result;
    }
}();

var Desktop = (function(){
    return {
        OFFSCREEN_ROOT_OBJECT_NAME: "desktopRoot",
        OFFSCREEN_DIALOG_OBJECT_NAME: "topLevelWindow",

        findChild: function(item, name) {
            for (var i = 0; i < item.children.length; ++i) {
                if (item.children[i].objectName === name) {
                    return item.children[i];
                }
            }
            return null;
        },

        findParent: function(item, name) {
            while (item) {
                if (item.objectName === name) {
                    return item;
                }
                item = item.parent;
            }
            return null;
        },

        findDialog: function(item) {
            item = findParent(item, OFFSCREEN_DIALOG_OBJECT_NAME);
            return item;
        },

        closeDialog: function(item) {
            item = findDialog(item);
            if (item) {
                item.enabled = false
            } else {
                console.warn("Could not find top level dialog")
            }
        },

        findMenuChild: function(menu, childName) {
            if (!menu) {
                return null;
            }

            if (menu.type !== 2) {
                console.warn("Tried to find child of a non-menu");
                return null;
            }

            var items = menu.items;
            var count = items.length;
            for (var i = 0; i < count; ++i) {
                var child = items[i];
                var name;
                switch (child.type) {
                    case 2:
                        name = child.title;
                        break;
                    case 1:
                        name = child.text;
                        break;
                    default:
                        break;
                }

                if (name && name === childName) {
                    return child;
                }
            }
        }
    };
}());


var Menu = (function(){
    return {}
}());

