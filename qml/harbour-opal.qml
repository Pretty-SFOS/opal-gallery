/*
 * This file is part of harbour-opal.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2021 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow
{
    id: app
    property ListModel modules: ListModel {
        //>>> GENERATED LIST OF MODULES
        ListElement {
            title: "Opal.About"
            description: qsTranslate("ModuleDescriptions", "This module provides <i>AboutPageBase</i> for building customizable application information pages.")
            author: "ichthyosaurus"
            mainLicenseSpdx: "GPL-3.0-or-later"
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-about"
            examplePage: "opal-about/About.qml"
        }
        //<<< GENERATED LIST OF MODULES
    }

    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
