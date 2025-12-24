//@ This file is part of Opal.Tabs for use in harbour-opal-gallery.
//@ https://github.com/Pretty-SFOS/opal-tabs
//@ SPDX-License-Identifier: GPL-3.0-or-later
//@ SPDX-FileCopyrightText: 2023-2024 Mirian Margiani

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import Opal.Tabs 1.0 as T

T.TabItem {
    id: root
    flickable: flick

    S.SilicaFlickable {
        id: flick
        anchors.fill: parent

        S.ViewPlaceholder {
            enabled: true
            text: qsTranslate("EmptyDummyPage", "Dummy page")
            hintText: qsTranslate("EmptyDummyPage", "Other contents could be included at this place.")
        }
    }
}
