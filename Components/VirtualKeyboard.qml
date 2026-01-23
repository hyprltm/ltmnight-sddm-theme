// Copyright (C) 2026 Djalel Oukid
// Distributed under the AGPL-3.0 License https://www.gnu.org/licenses/agpl-3.0.html

import QtQuick
import QtQuick.VirtualKeyboard

InputPanel {
    id: virtualKeyboard

    property bool manualToggle: false
    property bool autoShowEnabled: config.VirtualKeyboardAutoShow == "true"

    // Show if: manually toggled OR (auto-show enabled AND focus triggered)
    y: (manualToggle || (autoShowEnabled && active)) ? parent.height - height : parent.height
    visible: y < parent.height

    Behavior on y {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutQuad
        }
    }
}
