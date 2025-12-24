/*
 * This file is part of harbour-opal.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2025 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import Opal.About 1.0 as A

A.AboutPageBase {
    id: root

    appName: "Opal.About Example"
    appIcon: Qt.resolvedUrl("../../images/harbour-opal-gallery.png")
    appVersion: APP_VERSION
    appRelease: APP_RELEASE
    description: qsTranslate("Opal.About", "This is a short description of the app. It can use styled " +
                      "and rich text or <a href='https://example.org'>links</a>.")

    // note: don't use qsTranslate("Opal.About", ) for names in real applications
    authors: [qsTranslate("Opal.About", "the app's maintainer"), qsTranslate("Opal.About", "another important person")]
    mainAttributions: [qsTranslate("Opal.About", "additional name")]
    sourcesUrl: "https://git.example.org/myapp"
    translationsUrl: "https://hosted.weblate.org/projects/example"
    homepageUrl: "https://example.org/my/forum"

    // changelogList: Qt.resolvedUrl("Changelog.qml")

    changelogItems: [
        // add new entries at the top
        A.ChangelogItem {
            version: "3.0.0-1"
            date: "2023-03-01"
            paragraphs: "This version introduces an important clarification: " +
                        "this changelog is just an example, and it does not " +
                        "refer to the Opal Gallery app."
        },
        A.ChangelogItem {
            version: "2.0.0-1"
            date: "2023-02-01"
            // author: "Jane Doe" -- the author field is optional
            paragraphs: [
                "A lot has changed since the last version. Unicorns learned " +
                "to fly and penguins grew horns.",
                "We decided to increase the version number to celebrate " +
                "these achievements of nature."
            ]
        },
        A.ChangelogItem {
            version: "1.0.0-1"
            date: "2023-01-01"
            author: "Jane Doe"
            paragraphs: "This is the first version. Everything is new and " +
                        "shiny, so be sure to check every page of this brand new " +
                        "app."
        }
    ]

    licenses: A.License {
        spdxId: "GPL-3.0-or-later"
        // -- automatically provided:
        // customShortText: "This is free software: you are welcome to redistribute it under certain conditions. " +
        //                  "There is NO WARRANTY, to the extent permitted by law."
    }
    attributions: [
        // Note: attribution for Opal modules is added automatically. See the
        // "autoAddOpalAttributions" property for details.

        A.Attribution {
            name: "My.Extra.Component"
            entries: ["2020-2022 John Doe", "2022 Jane Doe"]
            licenses: A.License { spdxId: "CC0-1.0" }
        },
        A.Attribution {
            name: "The Other Library"
            licenses: [ A.License { spdxId: "MIT" }, A.License { spdxId: "MPL-2.0" } ]
        },
        A.Attribution {
            name: "Yet Another Lib"
            entries: "1984 Jane Doe"
            licenses: A.License { spdxId: "GPL-3.0-or-later" }
            homepage: "https://example.org/homepage"
            sources: "https://example.org/sources"
        },
        A.Attribution {
            name: "Other Imaginary Components"
            entries: "2000 Components Community"
            licenses: A.License { spdxId: "MIT" }
            homepage: "https://example.org/component"
        },
        A.Attribution {
            // no entries and no licenses: adds a "thank you!"
            // entry on the contributors page
            name: "Some person"
            homepage: "https://example.org"
        },
        A.Attribution {
            // no entries and no licenses: adds a "thank you!"
            // entry on the contributors page
            name: "Some other person"
            homepage: "https://example.org"
            sources: "https://source.example.org"
        }
    ]

    donations.text: donations.defaultTextCoffee
    donations.services: [
        A.DonationService {
            name: "Liberapay"
            url: "https://liberapay.com/example"
        },
        A.DonationService {
            name: "Other Service"
            url: "https://support.example.org/myapp"
        }
    ]

    extraSections: [
        A.InfoSection {
            // Extra buttons can be added to the main list (source code, homepage, translations)
            // by defining them in the first custom info section. Set no title.
            buttons: [
                A.InfoButton {
                    text: qsTranslate("Opal.About", "Forum")
                    onClicked: root.openOrCopyUrl("https://example.org/forum")
                }
            ]
        },
        A.InfoSection {
            title: qsTranslate("Opal.About", "Data")
            text: qsTranslate("Opal.About", "Lorem ipsum dolor sit amet et cetera ad libitum plurum sid alum.")
            buttons: [
                A.InfoButton {
                    text: qsTranslate("Opal.About", "Data License")
                    onClicked: root.openOrCopyUrl("https://example.org")
                }
            ]
        },
        A.InfoSection {
            title: qsTranslate("Opal.About", "Extra info")
            text: qsTranslate("Opal.About", "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. " +
                       "Aenean commodo ligula eget dolorus.")
        }
    ]

    contributionSections: [
        A.ContributionSection {
            title: qsTranslate("Opal.About", "Development")
            groups: [
                A.ContributionGroup {
                    title: qsTranslate("Opal.About", "Programming")
                    entries: ["Jane Doe", "Joanne Doe", "Jim Doe"]
                },
                A.ContributionGroup {
                    title: qsTranslate("Opal.About", "Icon Design")
                    entries: ["John Doe"]
                }
            ]
        },
        A.ContributionSection {
            title: qsTranslate("Opal.About", "Translations")
            groups: [
                A.ContributionGroup {
                    title: qsTranslate("Opal.About", "English")
                    entries: ["Jake Doe"]
                },
                A.ContributionGroup {
                    title: qsTranslate("Opal.About", "German")
                    entries: [] // an empty section will be invisible
                }
            ]
        }
    ]

    S.PullDownMenu {
        parent: root.flickable
        S.MenuItem {
            text: qsTranslate("Opal.About", "Open another page")
            onClicked: pageStack.push(Qt.resolvedUrl("EmptyDummyPage.qml"))
        }
    }
}
