// Copyright (C) 2026 Djalel Oukid
// Distributed under the AGPL-3.0 License https://www.gnu.org/licenses/agpl-3.0.html

import QtQuick
import QtQuick.VirtualKeyboard

InputPanel {
    id: virtualKeyboard

    property bool manualActive: false
    state: manualActive || (active && config.VirtualKeyboardAutoShow === "true") ? "visible" : "hidden"

    onActiveChanged: {
        if (!active) {
            manualActive = false
        }
    }

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
