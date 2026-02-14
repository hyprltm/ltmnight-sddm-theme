// Copyright (C) 2026 Djalel Oukid
// Distributed under the AGPL-3.0 License https://www.gnu.org/licenses/agpl-3.0.html

import QtQuick
import QtQuick.Layouts

RowLayout {
    id: topBar

    spacing: root.font.pointSize

    VirtualKeyboardButton {
        id: virtualKeyboardButton
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        visible: virtualKeyboard.active
    }

    Item {
        Layout.fillWidth: true
    }

    Kblayout {
        id: kblayout
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
    }
}
