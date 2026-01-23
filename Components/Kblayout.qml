// Copyright (C) 2026 Djalel Oukid
// Distributed under the AGPL-3.0 License https://www.gnu.org/licenses/agpl-3.0.html

import QtQuick
import QtQuick.Controls

ComboBox {
    id: layoutButton

    // Implicit sizing for Qt 6 Layout compatibility
    implicitHeight: root.font.pointSize * 2
    implicitWidth: root.font.pointSize * 10

    hoverEnabled: true
    
    // Safety check for keyboard model
    model: keyboard.layouts
    
    Component.onCompleted: {
        console.log("Keyboard Layouts Available:", keyboard.layouts ? keyboard.layouts.length : "Undefined")
    }

    currentIndex: keyboard.currentLayout
    textRole: "longName" 
    
    onActivated: {
        keyboard.currentLayout = index
    }
    
    Keys.onPressed: function(event) {
        if ((event.key == Qt.Key_Left || event.key == Qt.Key_Right) && !popup.opened) {
            popup.open();
        }
    }

    delegate: ItemDelegate {
        width: popupHandler.width - 20
        anchors.horizontalCenter: popupHandler.horizontalCenter
        
        contentItem: Text {
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            // Safety: Access properties carefully or fallback
            text: modelData.longName ? modelData.longName : modelData.shortName ? modelData.shortName : "Unknown"
            font.pointSize: root.font.pointSize * 0.8
            font.family: root.font.family
            color: layoutButton.highlightedIndex === index 
                ? (config.DropdownSelectedTextColor || config.DropdownTextColor)
                : config.DropdownTextColor
        }
        
        background: Rectangle {
            color: layoutButton.highlightedIndex === index ? config.DropdownSelectedBackgroundColor : "transparent"
        }
    }

    indicator {
        visible: false
    }

    contentItem: Row {
        spacing: root.font.pointSize * 0.5
        
        Button {
            id: globeIcon
            width: root.font.pointSize * 2
            height: root.font.pointSize * 2
            anchors.verticalCenter: parent.verticalCenter
            flat: true
            enabled: false
            
            icon.source: Qt.resolvedUrl("../Assets/Globe.svg")
            icon.width: root.font.pointSize * 1.5
            icon.height: root.font.pointSize * 1.5
            icon.color: layoutButton.hovered || layoutButton.visualFocus 
                ? config.HoverSessionButtonTextColor 
                : config.SessionButtonTextColor
            
            background: Item {}
        }
        
        Text {
            id: displayedItem
            anchors.verticalCenter: parent.verticalCenter
            
            // Use shortName for compact display (e.g., "EN" instead of "English")
            property string layoutCode: {
                var layouts = keyboard.layouts
                var idx = keyboard.currentLayout
                if (layouts && layouts[idx] && layouts[idx].shortName) {
                    return layouts[idx].shortName.toUpperCase()
                }
                return "EN"
            }
            
            text: qsTr("Layout") + " (" + layoutCode + ")"
            
            // Prevent overflow
            elide: Text.ElideRight
            maximumLineCount: 1
            
            color: layoutButton.hovered || layoutButton.visualFocus 
                ? config.HoverSessionButtonTextColor 
                : config.SessionButtonTextColor
            font.pointSize: root.font.pointSize * 0.8
            font.family: root.font.family
        }
        
        Keys.onReleased: layoutButton.popup.open()
    }

    background: Rectangle {
        height: parent.visualFocus ? 2 : 0
        width: displayedItem.implicitWidth
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
    }

    popup: Popup {
        id: popupHandler

        implicitHeight: contentItem.implicitHeight
        width: layoutButton.width
        // Open BELOW the button (since we're at top of screen)
        y: parent.height
        x: 0
        padding: 10

        contentItem: ListView {
            implicitHeight: contentHeight + 20

            clip: true
            model: layoutButton.popup.visible ? layoutButton.delegateModel : null
            currentIndex: layoutButton.highlightedIndex
            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            radius: config.RoundCorners / 2
            color: config.DropdownBackgroundColor
            layer.enabled: true
        }

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1 }
        }
    }

    states: [
        State {
            name: "pressed"
            when: layoutButton.down
            PropertyChanges {
                target: displayedItem
                color: config.HoverSessionButtonTextColor
            }
        },
        State {
            name: "hovered"
            when: layoutButton.hovered
            PropertyChanges {
                target: displayedItem
                color: config.HoverSessionButtonTextColor
            }
        },
        State {
            name: "focused"
            when: layoutButton.visualFocus
            PropertyChanges {
                target: displayedItem
                color: config.HoverSessionButtonTextColor
            }
        }
    ]
    transitions: [
        Transition {
            PropertyAnimation {
                properties: "color"
                duration: 150
            }
        }
    ]
}
