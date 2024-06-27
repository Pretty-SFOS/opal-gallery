/*
 * This file is part of harbour-opal-gallery.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2021 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

import Opal.About 1.0 as A
import Opal.SupportMe 1.0 as M

ApplicationWindow
{
    id: app

    // During module development:
    // Set this property to a module name. Its example
    // page will be shown automatically when the app is
    // ready. This is useful when developing using QmlLive.
    property string develJumpToModule: ""

    property var modules: [
        //>>> GENERATED LIST OF MODULES
        {
            title: "Opal.About",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides <i>AboutPageBase</i> for building customizable application information pages."),
            appVersion: "2.2.0",
            mainAttributions: ['2018-2023 Mirian Margiani'],
            maintainers: ['ichthyosaurus'],
            contributors: [],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-about",
            examplePage: "opal-about/About.qml"
        },
        {
            title: "Opal.SupportMe",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "A dialog asking for contributions that is shown when a user has used your app for some time."),
            appVersion: "1.1.0",
            mainAttributions: ['2024 Mirian Margiani'],
            maintainers: ['ichthyosaurus'],
            contributors: [],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-supportme",
            examplePage: "opal-supportme/SupportMe.qml"
        },
        {
            title: "Opal.Delegates",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides <i>Delegates</i> for use in QML views."),
            appVersion: "1.0.0",
            mainAttributions: ['2023 Peter G (nephros)'],
            maintainers: ['ichthyosaurus;nephros'],
            contributors: [],
            mainLicenseSpdx: "Apache-2.0",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-delegates",
            examplePage: "opal-delegates/Delegates.qml"
        },
        {
            title: "Opal.InfoCombo",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a combo box that can show details for each selectable option."),
            appVersion: "2.1.0",
            mainAttributions: ['2023-2024 Mirian Margiani'],
            maintainers: ['ichthyosaurus'],
            contributors: [],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-infocombo",
            examplePage: "opal-infocombo/InfoCombo.qml"
        },
        {
            title: "Opal.ComboData",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides an extension for combo boxes to access the current value instead of the label."),
            appVersion: "2.1.0",
            mainAttributions: ['2023-2024 Mirian Margiani'],
            maintainers: ['ichthyosaurus'],
            contributors: [],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-combodata",
            examplePage: "opal-combodata/ComboData.qml"
        },
        {
            title: "Opal.LinkHandler",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a link handler to open or copy external links."),
            appVersion: "2.0.0",
            mainAttributions: ['2020-2023 Mirian Margiani'],
            maintainers: ['ichthyosaurus'],
            contributors: [],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-linkhandler",
            examplePage: "opal-linkhandler/LinkHandler.qml"
        }
        //<<< GENERATED LIST OF MODULES
    ]

    A.ChangelogNews {
        changelogList: Qt.resolvedUrl("Changelog.qml")
    }

    M.AskForSupport {
        contents: Component {
            MySupportDialog {}
        }
    }

    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted: {
        if (develJumpToModule === "") return

        for (var i in modules) {
            if (modules[i].title === develJumpToModule) {
                pageStack.push(Qt.resolvedUrl(
                    "module-pages/" + modules[i].examplePage))
                break
            }
        }
    }
}
