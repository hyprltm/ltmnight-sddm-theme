// Copyright (C) 2026 Djalel Oukid
// Distributed under the AGPL-3.0 License https://www.gnu.org/licenses/agpl-3.0.html

import QtQuick
import QtQuick.VirtualKeyboard

InputPanel {
    id: virtualKeyboard

    property bool manualToggle: false
    property bool autoShowEnabled: config.VirtualKeyboardAutoShow == "true"

    y: parent.height

    state: (manualToggle || (autoShowEnabled && active)) ? "visible" : "hidden"

    states: [
        State {
            name: "visible"
            PropertyChanges { target: virtualKeyboard; y: parent.height - height }
        },
        State {
            name: "hidden"
            PropertyChanges { target: virtualKeyboard; y: parent.height }
        }
    ]

    transitions: Transition {
        NumberAnimation {
            properties: "y"
            duration: 150
            easing.type: Easing.OutQuad
        }
    }
    
    visible: y < parent.height
}
