/*
 * This file is part of harbour-opal-gallery.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2021 Mirian Margiani
 */

import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: root
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        ViewPlaceholder {
            enabled: true
            text: qsTr("Dummy page")
            hintText: qsTr("Other contents could be included at this place.")
        }
    }
}
