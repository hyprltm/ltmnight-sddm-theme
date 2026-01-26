// Copyright (C) 2026 Djalel Oukid
// Distributed under the AGPL-3.0 License https://www.gnu.org/licenses/agpl-3.0.html

import QtQuick
import QtQuick.Controls

Item {
    id: sessionButton

    implicitHeight: root.font.pointSize * 2
    implicitWidth: root.font.pointSize * 20
    
    property var selectedSession: selectSession.currentIndex
    property string textConstantSession
    property int loginButtonWidth

    ComboBox {
        id: selectSession

        height: parent.height
        anchors.centerIn: parent

        hoverEnabled: true
        model: sessionModel
        currentIndex: model.lastIndex
        textRole: "name"
        
        Keys.onPressed: function(event) {
            if ((event.key == Qt.Key_Left || event.key == Qt.Key_Right) && !popup.opened) {
                popup.open();
            }
        }

        delegate: ItemDelegate {
            width: popupHandler.width - 20
            anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
            
            contentItem: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                text: model.name
                font.pointSize: root.font.pointSize * 0.8
                font.family: root.font.family
                color: selectSession.highlightedIndex === index 
                    ? (config.DropdownSelectedTextColor || config.DropdownTextColor)
                    : config.DropdownTextColor
            }
            
            background: Rectangle {
                color: selectSession.highlightedIndex === index ? config.DropdownSelectedBackgroundColor : "transparent"
            }
        }

        indicator {
            visible: false
        }

        contentItem: Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: root.font.pointSize * 0.5
            
            Button {
                id: sessionIcon
                anchors.verticalCenter: parent.verticalCenter
                width: root.font.pointSize * 2
                height: root.font.pointSize * 2
                padding: 0
                flat: true
                enabled: false
                
                icon.source: Qt.resolvedUrl("../Assets/Session.svg")
                icon.width: root.font.pointSize * 1.125
                icon.height: root.font.pointSize * 1.125
                icon.color: selectSession.hovered || selectSession.visualFocus 
                    ? config.HoverSessionButtonTextColor 
                    : config.SessionButtonTextColor
                
                background: Item {}
            }

            Text {
                id: displayedItem
                anchors.verticalCenter: parent.verticalCenter
                
                text: (config.TranslateSessionSelection || qsTr("Session")) + " (" + selectSession.currentText + ")"
                
                color: selectSession.hovered || selectSession.visualFocus 
                    ? config.HoverSessionButtonTextColor 
                    : config.SessionButtonTextColor
                font.pointSize: root.font.pointSize * 0.8
                font.family: root.font.family
            }
            
            Keys.onReleased: selectSession.popup.open()
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
            width: Math.max(250, sessionButton.width)
            y: -popupHandler.height + 5
            x: (selectSession.width - popupHandler.width) / 2
            padding: 10

            contentItem: ListView {
                implicitHeight: contentHeight + 20

                clip: true
                model: selectSession.popup.visible ? selectSession.delegateModel : null
                currentIndex: selectSession.highlightedIndex
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
                when: selectSession.down || selectSession.popup.visible
                PropertyChanges {
                    target: displayedItem
                    color: config.HoverSessionButtonTextColor
                }
                PropertyChanges {
                    target: sessionIcon
                    icon.color: config.HoverSessionButtonTextColor
                }
            },
            State {
                name: "hovered"
                when: selectSession.hovered
                PropertyChanges {
                    target: displayedItem
                    color: config.HoverSessionButtonTextColor
                }
                PropertyChanges {
                    target: sessionIcon
                    icon.color: config.HoverSessionButtonTextColor
                }
            },
            State {
                name: "focused"
                when: selectSession.visualFocus
                PropertyChanges {
                    target: displayedItem
                    color: config.HoverSessionButtonTextColor
                }
                PropertyChanges {
                    target: sessionIcon
                    icon.color: config.HoverSessionButtonTextColor
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
}
