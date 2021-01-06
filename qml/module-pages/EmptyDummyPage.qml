/*
 * This file is part of harbour-opal.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2021 Mirian Margiani
 */

import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        ViewPlaceholder {
            enabled: true
            text: qsTr("Empty page")
            hintText: qsTr("This page is intentionally left blank " +
                           "for demonstrational purposes.")
        }
    }
}
