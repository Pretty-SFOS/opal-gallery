/*
 * This file is part of harbour-opal-gallery.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2021 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

import Opal.About 1.0 as A

ApplicationWindow
{
    id: app
    property var modules: [
        //>>> GENERATED LIST OF MODULES
        {
            title: "Opal.About",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides <i>AboutPageBase</i> for building customizable application information pages."),
            appVersion: "2.1.0",
            mainAttributions: ['2018-2023 Mirian Margiani'],
            maintainers: ['ichthyosaurus'],
            contributors: [],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-about",
            examplePage: "opal-about/About.qml"
        },
        {
            title: "Opal.InfoCombo",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a combo box that can show details for each selectable option."),
            appVersion: "1.0.0",
            mainAttributions: ['2023 Mirian Margiani'],
            maintainers: ['ichthyosaurus'],
            contributors: [],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-infocombo",
            examplePage: "opal-infocombo/InfoCombo.qml"
        }
        //<<< GENERATED LIST OF MODULES
    ]

    A.ChangelogNews {
        changelogList: Qt.resolvedUrl("Changelog.qml")
    }

    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
