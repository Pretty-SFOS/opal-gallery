/*
 * This file is part of harbour-opal-gallery.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2024 Mirian Margiani
 * SPDX-FileCopyrightText: 2023 Peter G. (nephros)
 */

import QtQuick 2.0
import Sailfish.Silica 1.0 as S

ListModel {
    function statusColor(statusType) {
        if (statusType === "online") return "green"
        else if (statusType === "busy") return "orange"
        else if (statusType === "away") return "red"
        else return S.Theme.secondaryColor
    }

    ListElement {
        nick: qsTr("Jane")
        status: qsTr("online")
        when: qsTr("yesterday")
        post: qsTr("@John: are there any taters left?")
        statusType: "online"
    }
    ListElement {
        nick: qsTr("John")
        status: qsTr("busy")
        when: qsTr("2h ago")
        post: qsTr("Sorry @Jane, I ate them all. I'll make new ones on Saturday, though.")
        statusType: "busy"
    }
    ListElement {
        nick: qsTr("Lisa")
        status: qsTr("away")
        when: qsTr("32m ago")
        post: qsTr("@Jane, come over, I have some ready right now!")
        statusType: "away"
    }
}
