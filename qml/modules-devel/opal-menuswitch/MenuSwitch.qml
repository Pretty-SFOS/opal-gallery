/*
 * This file is part of harbour-opal.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2024 Mirian Margiani
 */

import QtQuick 2.6
import Sailfish.Silica 1.0 as S

S.MenuItem {
    property alias automaticCheck: toggle.automaticCheck
    property alias checked: toggle.checked
    property alias busy: toggle.busy
    property alias switchItem: toggle

    S.TextSwitch {
        id: toggle
        checked: false
        automaticCheck: true
        text: " "
        highlighted: parent.highlighted
        height: S.Theme.itemSizeSmall
        width: height
        anchors.verticalCenter: parent.verticalCenter
    }

    text: ""
    onClicked: {
        toggle.clicked(null)
    }
}
