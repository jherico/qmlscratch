import QtQuick 2.0

import ".."

Rectangle {
    Constants { id: vr }

    id: root
    color: vr.windows.colors.background
    border.width: vr.styles.borderWidth
    border.color: vr.controls.colors.background

    implicitHeight: 600
    implicitWidth: 800

    radius: vr.styles.borderRadius
    opacity: 0
    visible: false
    enabled: false

    // The offscreen UI will enable an object, rather than manipulating it's
    // visibility, so that we can do animations in both directions.  Because
    // visibility and enabled are boolean flags, they cannot be animated.  So when
    // enabled is change, we modify a property that can be animated, like scale or
    // opacity, and then when the target animation value is reached, we can
    // modify the visibility
    onEnabledChanged: {
        opacity = enabled ? 1.0 : 0.0
        // If the dialog is initially invisible, setting opacity doesn't
        // trigger making it visible.
        if (enabled) { visible = true; }
    }

    // Once we're transparent, disable the dialog's visibility
    onOpacityChanged: {
        visible = (opacity != 0.0);
    }

    // The actual animator
    Behavior on opacity {
        NumberAnimation {
            duration: vr.effects.fadeInDuration
            easing.type: Easing.OutCubic
        }
    }
}


