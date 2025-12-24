//@ This file is part of Opal.LocalStorage for use in harbour-opal-gallery.
//@ https://github.com/Pretty-SFOS/opal-localstorage
//@ SPDX-License-Identifier: GPL-3.0-or-later
//@ SPDX-FileCopyrightText: 2023-2024 Mirian Margiani

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import Opal.LocalStorage 1.0 as M

S.Page {
    id: root
    allowedOrientations: S.Orientation.All

    S.SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: column.height + S.Theme.horizontalPageMargin

        S.VerticalScrollDecorator { flickable: flick }

        Column {
            id: column
            width: parent.width
            spacing: S.Theme.paddingMedium

            S.PageHeader {
                title: qsTranslate("Opal.LocalStorage", "Example Page")
            }

            S.SectionHeader {
                text: qsTranslate("Opal.LocalStorage", "Basic usage")
            }

            S.Label {
                x: S.Theme.horizontalPageMargin
                width: root.width - 2*x
                wrapMode: Text.Wrap
                text: qsTranslate("Opal.LocalStorage", "This is how to use the new component.")
                color: S.Theme.highlightColor
            }

            S.SectionHeader {
                text: qsTranslate("Opal.LocalStorage", "Advanced usage")
            }

            S.Label {
                x: S.Theme.horizontalPageMargin
                width: root.width - 2*x
                wrapMode: Text.Wrap
                text: qsTranslate("Opal.LocalStorage", "This is a more complex scenario.")
                color: S.Theme.highlightColor
            }
        }
    }
}
