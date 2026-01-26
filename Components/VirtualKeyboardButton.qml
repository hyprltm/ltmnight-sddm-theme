// Copyright (C) 2026 Djalel Oukid
// Distributed under the AGPL-3.0 License https://www.gnu.org/licenses/agpl-3.0.html

import QtQuick
import QtQuick.Controls

Button {
    id: virtualKeyboardButton

    visible: virtualKeyboard.status == Loader.Ready && config.HideVirtualKeyboard == "false"
    checkable: true
    flat: true
    
    onCheckedChanged: {
        if (virtualKeyboard.item) {
            virtualKeyboard.item.manualToggle = checked
        }
    }

    contentItem: Row {
        spacing: root.font.pointSize * 0.5
        
        Button {
            id: keyboardIcon
            width: root.font.pointSize * 2
            height: root.font.pointSize * 2
            anchors.verticalCenter: parent.verticalCenter
            flat: true
            padding: 0
            enabled: false
            
            icon.source: virtualKeyboardButton.checked 
                ? Qt.resolvedUrl("../Assets/keyboard-hide.svg") 
                : Qt.resolvedUrl("../Assets/keyboard-show.svg")
            icon.width: root.font.pointSize * 1.125
            icon.height: root.font.pointSize * 1.125
            icon.color: virtualKeyboardButton.hovered || virtualKeyboardButton.visualFocus 
                ? config.HoverVirtualKeyboardButtonTextColor 
                : config.VirtualKeyboardButtonTextColor
            
            background: Item {}
        }
        
        Text {
            id: virtualKeyboardButtonText
            anchors.verticalCenter: parent.verticalCenter

            text: virtualKeyboardButton.checked 
                ? (config.TranslateVirtualKeyboardButtonOn || qsTr("Hide Virtual Keyboard"))
                : (config.TranslateVirtualKeyboardButtonOff || qsTr("Show Virtual Keyboard"))
            font.pointSize: root.font.pointSize * 0.8
            font.family: root.font.family
            color: virtualKeyboardButton.hovered || virtualKeyboardButton.visualFocus 
                ? config.HoverVirtualKeyboardButtonTextColor 
                : config.VirtualKeyboardButtonTextColor
        }
    }

    background: Item {}
}