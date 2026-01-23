// Copyright (C) 2026 Djalel Oukid
// Distributed under the AGPL-3.0 License https://www.gnu.org/licenses/agpl-3.0.html

import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Column {
    id: clock

    width: parent.width / 2
    spacing: 0

    Label {
        id:headerTextLabel

        anchors.horizontalCenter: parent.horizontalCenter

        font.family: root.font.family
        font.pointSize: root.font.pointSize * 1.5
        font.bold: true
        color: config.HeaderTextColor
        renderType: Text.QtRendering
        text: {
            var template = config.HeaderText || qsTr("> [ HOSTNAME ] READY_")
            return template.replace("HOSTNAME", (sddm.hostName ? sddm.hostName.toUpperCase() : "LOCALHOST"))
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: config.UserIconColor
            shadowBlur: 0.8
            shadowVerticalOffset: 0
            shadowHorizontalOffset: 0
        }
    }

    Label {
        id: timeLabel

        anchors.horizontalCenter: parent.horizontalCenter

        font.family: root.font.family
        font.pointSize: root.font.pointSize * 7
        font.bold: true
        color: config.TimeTextColor
        renderType: Text.QtRendering

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: config.HeaderTextColor
            shadowBlur: 0.8
            shadowVerticalOffset: 0
            shadowHorizontalOffset: 0
        }

        function updateTime() {
            var locale = config.Locale ? Qt.locale(config.Locale) : Qt.locale()
            text = new Date().toLocaleTimeString(locale, config.HourFormat == "long" ? Locale.LongFormat : config.HourFormat !== "" ? config.HourFormat : Locale.ShortFormat)
        }
    }

    Label {
        id: dateLabel

        anchors.horizontalCenter: parent.horizontalCenter
        
        color: config.DateTextColor
        font.family: root.font.family
        font.pointSize: root.font.pointSize * 2
        font.bold: true
        renderType: Text.QtRendering

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: config.HeaderTextColor
            shadowBlur: 0.8
            shadowVerticalOffset: 0
            shadowHorizontalOffset: 0
        }

        function updateTime() {
            var locale = config.Locale ? Qt.locale(config.Locale) : Qt.locale()
            text = new Date().toLocaleDateString(locale, config.DateFormat == "short" ? Locale.ShortFormat : config.DateFormat !== "" ? config.DateFormat : Locale.LongFormat)
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            dateLabel.updateTime()
            timeLabel.updateTime()
        }
    }

    Component.onCompleted: {
        dateLabel.updateTime()
        timeLabel.updateTime()
    }
}
