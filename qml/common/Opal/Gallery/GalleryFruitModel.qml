/*
 * This file is part of harbour-opal-gallery.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2024 Mirian Margiani
 * SPDX-FileCopyrightText: 2023 Peter G. (nephros)
 */

import QtQuick 2.0
import Sailfish.Silica 1.0 as S

ListModel {
    ListElement {
        name: qsTr("Apple")
        price: "2.95"
        desc: qsTr("A juicy fruit with a sour note. Perfect for fruit salads.")
        sale: qsTr("Best against doctors!",
                   "example text, as in: “an apple a day keeps the doctor away”")
    }
    ListElement {
        name: qsTr("Banana")
        price: "1.05"
        desc: qsTr("A yellow fruit preferred by monkeys and humans alike.")
        sale: qsTr("Only today: two for one!")
    }
    ListElement {
        name: qsTr("A basket full of exotic fruits")
        price: "15.99"
        desc: ""
        sale: qsTr("Special gift!")
    }
    ListElement {
        name: qsTr("Peanut butter")
        price: "0.99"
        desc: ""
        sale: ""
    }
}
