// Copyright (C) 2026 Djalel Oukid
// Distributed under the AGPL-3.0 License https://www.gnu.org/licenses/agpl-3.0.html

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

RowLayout {

    spacing: root.font.pointSize

    property var shutdown: ["Shutdown", config.TranslateShutdown || textConstants.shutdown, sddm.canPowerOff]
    property var reboot: ["Reboot", config.TranslateReboot || textConstants.reboot, sddm.canReboot]
    property var suspend: ["Suspend", config.TranslateSuspend || qsTr("Suspend"), sddm.canSuspend]
    property var hibernate: ["Hibernate", config.TranslateHibernate || qsTr("Hibernate"), sddm.canHibernate]

    Repeater {
        id: systemButtons
        
        model: [shutdown, reboot, suspend, hibernate]

        RoundButton {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.topMargin: root.font.pointSize * 6.5

            text: modelData[1]
            font.pointSize: root.font.pointSize * 0.8
            icon.source: modelData ? Qt.resolvedUrl("../Assets/" + modelData[0] + ".svg") : ""
            icon.height: 2 * Math.round((root.font.pointSize * 3) / 2)
            icon.width: 2 * Math.round((root.font.pointSize * 3) / 2)
            icon.color: config.SystemButtonsIconsColor
            palette.buttonText: config.SystemButtonsIconsColor
            display: AbstractButton.TextUnderIcon
            visible: config.HideSystemButtons != "true" && (config.BypassSystemButtonsChecks == "true" ? 1 : modelData[2])
            hoverEnabled: true
            
            background: Rectangle {
                height: 2
                width: parent.width

                color: "transparent"
            }

            Keys.onReturnPressed: clicked()
            onClicked: {
                parent.forceActiveFocus()
                index == 0 ? sddm.powerOff() : index == 1 ? sddm.reboot() : index == 2 ? sddm.suspend() : sddm.hibernate()
            }
            KeyNavigation.left: index > 0 ? parent.children[index-1] : null
            
            states: [
                State {
                    name: "pressed"
                    when: parent.children[index].down
                    PropertyChanges {
                        target: parent.children[index]
                        icon.color: config.HoverSystemButtonsIconsColor
                        palette.buttonText: config.HoverSystemButtonsIconsColor
                    }
                },
                State {
                    name: "hovered"
                    when: parent.children[index].hovered
                    PropertyChanges {
                        target: parent.children[index]
                        icon.color: config.HoverSystemButtonsIconsColor
                        palette.buttonText: config.HoverSystemButtonsIconsColor
                    }
                },
                State {
                    name: "focused"
                    when: parent.children[index].activeFocus
                    PropertyChanges {
                        target: parent.children[index]
                        icon.color: config.HoverSystemButtonsIconsColor
                        palette.buttonText: config.HoverSystemButtonsIconsColor
                    }
                }
            ]
            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "palette.buttonText, border.color"
                        duration: 150
                    }
                }
            ]

        }

    }

}