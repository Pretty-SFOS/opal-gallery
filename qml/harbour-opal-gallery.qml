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
    //
    // Example:
    //    develJumpToModule: "Opal.SupportMe"
    property string develJumpToModule: ""

    property var moduleDetails: ({
        //>>> GENERATED LIST OF MODULE DETAILS
        "opal-about": {
            appName: "Opal.About",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides <i>AboutPageBase</i> for building customizable application information pages."),
            appVersion: "2.3.2",
            mainAttributions: ['2018-2024 Mirian Margiani'],
            maintainers: ['Mirian Margiani'],
            contributors: [],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-about"
        },
        "opal-supportme": {
            appName: "Opal.SupportMe",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "A dialog asking for contributions that is shown when a user has used your app for some time."),
            appVersion: "1.2.1",
            mainAttributions: ['2024 Mirian Margiani'],
            maintainers: ['Mirian Margiani'],
            contributors: [],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-supportme"
        },
        "opal-delegates": {
            appName: "Opal.Delegates",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides list items for views, so you can concentrate on handling the data, not formatting the presentation."),
            appVersion: "3.2.0",
            mainAttributions: ['2023 Peter G. (nephros)','2024 Mirian Margiani (ichthyosaurus)'],
            maintainers: ['Mirian Margiani'],
            contributors: ['Peter G.'],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-delegates"
        },
        "opal-dragdrop": {
            appName: "Opal.DragDrop",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module enables ordering lists by drag-and-drop with just a few lines of code."),
            appVersion: "1.0.1",
            mainAttributions: ['2024 Mirian Margiani'],
            maintainers: ['Mirian Margiani'],
            contributors: [],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-dragdrop"
        },
        "opal-smartscrollbar": {
            appName: "Opal.SmartScrollbar",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a Harbour-compatible smart scroll bar for long lists."),
            appVersion: "1.0.0",
            mainAttributions: ['2024 Mirian Margiani'],
            maintainers: ['Mirian Margiani'],
            contributors: [],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-smartscrollbar"
        },
        "opal-infocombo": {
            appName: "Opal.InfoCombo",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a combo box that can show details for each selectable option."),
            appVersion: "2.2.1",
            mainAttributions: ['2023-2024 Mirian Margiani'],
            maintainers: ['Mirian Margiani'],
            contributors: [],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-infocombo"
        },
        "opal-combodata": {
            appName: "Opal.ComboData",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides an extension for combo boxes to access the current value instead of the label."),
            appVersion: "2.1.1",
            mainAttributions: ['2023-2024 Mirian Margiani'],
            maintainers: ['Mirian Margiani'],
            contributors: [],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-combodata"
        },
        "opal-menuswitch": {
            appName: "Opal.MenuSwitch",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a toggle button to be used in Sailfish-style menus."),
            appVersion: "1.0.0",
            mainAttributions: ['2024 Mirian Margiani'],
            maintainers: ['Mirian Margiani'],
            contributors: [],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-menuswitch"
        },
        "opal-linkhandler": {
            appName: "Opal.LinkHandler",
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a link handler to open or copy external links."),
            appVersion: "2.1.1",
            mainAttributions: ['2020-2024 Mirian Margiani'],
            maintainers: ['Mirian Margiani'],
            contributors: [],
            mainLicenseSpdx: "GPL-3.0-or-later",
            sourcesUrl: "https://github.com/Pretty-SFOS/opal-linkhandler"
        }
        //<<< GENERATED LIST OF MODULE DETAILS
    })

    property ListModel modules: ListModel {
        //>>> GENERATED LIST OF MODULES
        ListElement {
            key: "opal-about"
            title: "Opal.About"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides <i>AboutPageBase</i> for building customizable application information pages.")
            mainLicenseSpdx: "GPL-3.0-or-later"
            examplePage: "opal-about/gallery.qml"
            section: "released"
        }
        ListElement {
            key: "opal-supportme"
            title: "Opal.SupportMe"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "A dialog asking for contributions that is shown when a user has used your app for some time.")
            mainLicenseSpdx: "GPL-3.0-or-later"
            examplePage: "opal-supportme/gallery.qml"
            section: "released"
        }
        ListElement {
            key: "opal-delegates"
            title: "Opal.Delegates"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides list items for views, so you can concentrate on handling the data, not formatting the presentation.")
            mainLicenseSpdx: "GPL-3.0-or-later"
            examplePage: "opal-delegates/gallery.qml"
            section: "released"
        }
        ListElement {
            key: "opal-dragdrop"
            title: "Opal.DragDrop"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module enables ordering lists by drag-and-drop with just a few lines of code.")
            mainLicenseSpdx: "GPL-3.0-or-later"
            examplePage: "opal-dragdrop/gallery.qml"
            section: "released"
        }
        ListElement {
            key: "opal-smartscrollbar"
            title: "Opal.SmartScrollbar"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a Harbour-compatible smart scroll bar for long lists.")
            mainLicenseSpdx: "GPL-3.0-or-later"
            examplePage: "opal-smartscrollbar/gallery.qml"
            section: "released"
        }
        ListElement {
            key: "opal-infocombo"
            title: "Opal.InfoCombo"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a combo box that can show details for each selectable option.")
            mainLicenseSpdx: "GPL-3.0-or-later"
            examplePage: "opal-infocombo/gallery.qml"
            section: "released"
        }
        ListElement {
            key: "opal-combodata"
            title: "Opal.ComboData"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides an extension for combo boxes to access the current value instead of the label.")
            mainLicenseSpdx: "GPL-3.0-or-later"
            examplePage: "opal-combodata/gallery.qml"
            section: "released"
        }
        ListElement {
            key: "opal-menuswitch"
            title: "Opal.MenuSwitch"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a toggle button to be used in Sailfish-style menus.")
            mainLicenseSpdx: "GPL-3.0-or-later"
            examplePage: "opal-menuswitch/gallery.qml"
            section: "released"
        }
        ListElement {
            key: "opal-linkhandler"
            title: "Opal.LinkHandler"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a link handler to open or copy external links.")
            mainLicenseSpdx: "GPL-3.0-or-later"
            examplePage: "opal-linkhandler/gallery.qml"
            section: "released"
        }
        //<<< GENERATED LIST OF MODULES


        // Modules in development
        // Code is included in the gallery app but does not live in separate
        // repositories yet.

        // section: "development"

        // ListElement {
        //     key: "opal-dragdrop"
        //     title: "Opal.DragDrop"
        //     description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module enables ordering lists by drag-and-drop with just a few lines of code.")
        //     mainLicenseSpdx: "GPL-3.0-or-later"
        //     examplePage: "opal-dragdrop/gallery.qml"
        //     section: "development"
        // }


        // Upcoming modules
        // Code exists but is not yet imported from other projects into Opal.

        ListElement {
            // Code:
            // - https://gitlab.com/cy8aer/podqast/-/tree/master/qml/components/hints
            // - https://gitlab.com/cy8aer/podqast/-/tree/master/qml/lib/hints
            // - https://github.com/Pretty-SFOS/opal/issues/8

            key: "opal-hints"
            title: "Opal.Hints"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides easy to use interaction hints for app tutorials.")
            mainLicenseSpdx: "GPL-3.0-or-later"
            // examplePage: "opal-hints/gallery.qml"
            section: "upcoming"
        }
        ListElement {
            // Code:
            // - https://github.com/ichthyosaurus/harbour-file-browser/blob/main/libs/SortFilterProxyModel.patch
            // - https://github.com/oKcerG/SortFilterProxyModel/

            key: "opal-sfpm"
            title: "Opal.SortFilterProxyModel"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a up-to-date and patched version of SortFilterProxyModel for QML.")
            mainLicenseSpdx: "MIT"
            // examplePage: "opal-sfpm/gallery.qml"
            section: "upcoming"
        }
        ListElement {
            // Code:
            // - https://github.com/ichthyosaurus/harbour-file-browser/blob/main/qml/components/GroupedDrawer.qml
            // - https://github.com/Pretty-SFOS/opal-about/blob/main/Opal/About/private/LicenseListPart.qml
            // - https://github.com/Pretty-SFOS/opal-supportme/blob/main/Opal/SupportMe/DetailsDrawer.qml
            // - https://github.com/Pretty-SFOS/opal-supportme/blob/main/Opal/SupportMe/DetailsParagraph.qml

            key: "opal-drawer"
            title: "Opal.Drawer"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a drawer that allows splitting long lists into accessible groups.")
            mainLicenseSpdx: "GPL-3.0-or-later"
            // examplePage: "opal-drawer/gallery.qml"
            section: "upcoming"
        }
        ListElement {
            // Code:
            // - https://web.archive.org/web/20180611014447/https://github.com/jwintz/qchart.js
            // - https://github.com/direc85/qchart.js
            // - https://github.com/ichthyosaurus/harbour-meteoswiss/tree/master/qml/qchart
            // - https://github.com/ichthyosaurus/harbour-meteoswiss/blob/master/qml/pages/components/ForecastGraphItem.qml

            key: "opal-charts"
            title: "Opal.Charts"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module allows drawing beautiful charts through QCharts.js.")
            mainLicenseSpdx: "MIT"
            // examplePage: "opal-charts/gallery.qml"
            section: "upcoming"
        }
        ListElement {
            // Code:
            // - https://github.com/ichthyosaurus/sf-docked-tab-bar

            key: "opal-tabbar"
            title: "Opal.TabBar"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a tab bar with icons and automatic alignment.")
            mainLicenseSpdx: "GPL-3.0-or-later"
            // examplePage: "opal-tabbar/gallery.qml"
            section: "upcoming"
        }


        // Planned modules
        // Code does not exist yet, or is in very early stages of development.

        ListElement {
            // Code:
            // - https://github.com/ichthyosaurus/sailfish-public-patch-sources/
            // - https://gitlab.com/whisperfish/whisperfish/-/blob/main/qml/js/emoji.js?ref_type=heads
            // - https://gitlab.com/whisperfish/whisperfish/-/blob/main/qml/components/Emojify.qml?ref_type=heads
            // - https://gitlab.com/whisperfish/whisperfish/-/blob/main/qml/components/LinkedEmojiLabel.qml?ref_type=heads
            // - notes: must support emojis, linking, custom link schemas, spoilers, markdown

            key: "opal-advancedlabel"
            title: "Opal.AdvancedLabel"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a text field and input area with support for emojis, styled text, and custom links.")
            mainLicenseSpdx: "GPL-3.0-or-later"
            // examplePage: "opal-advancedlabel/gallery.qml"
            section: "planned"
        }
        ListElement {
            // Code:
            // - https://github.com/ichthyosaurus/harbour-file-browser/blob/main/qml/components/FileActions.qml
            // - https://github.com/ichthyosaurus/harbour-captains-log/blob/main/qml/components/MoodMenu.qml
            // - Whisperfish

            key: "opal-iconmenu"
            title: "Opal.IconMenu"
            description: QT_TRANSLATE_NOOP("ModuleDescriptions", "This module provides a context menu with support for icons instead of text entries.")
            mainLicenseSpdx: "GPL-3.0-or-later"
            // examplePage: "opal-iconmenu/gallery.qml"
            section: "planned"
        }
    }

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

        develJumpToModule = develJumpToModule.replace(/^(opal-|Opal.)/, "")
        console.log("opening module:", develJumpToModule)

        for (var i = 0; i < modules.count; i++) {
            var mod = modules.get(i)

            if (mod.title.replace(/^(opal-|Opal.)/, "") === develJumpToModule ||
                    mod.key.replace(/^(opal-|Opal.)/, "") === develJumpToModule) {
                if (mod.section === "released") {
                    pageStack.push(Qt.resolvedUrl(
                        "module-pages/" + mod.examplePage))
                } else if (mod.section === "development") {
                    pageStack.push(Qt.resolvedUrl(
                        "modules-devel/" + mod.examplePage))
                } else {
                    console.error("cannot show example page for module in " +
                                  "unknown section “%1”".arg(mod.section))
                }

                break
            }
        }
    }
}
