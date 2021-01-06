/*
 * This file is part of harbour-opal.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2021 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import Opal.About 1.0

AboutPageBase {
    id: page
    allowedOrientations: Orientation.All

    appName: "Opal.About Example"
    iconSource: Qt.resolvedUrl("../images/harbour-opal.png")
    versionNumber: APP_VERSION
    releaseNumber: APP_RELEASE
    description: qsTr("This is a short description of the app which can use <i>styled</i> " +
                      "<i><b>and</b></i> <u>rich</u> text or " +
                      "<a href='https://example.org'>links</a>.")

    // note: don't use qsTr() for names in real applications
    author: qsTr("the main author or maintainer")
    licenses: [
        License {
            spdxId: "GPL-3.0-or-later"
            customShortText: "This is free software: you are free to change and redistribute it. " +
                             "There is NO WARRANTY, to the extent permitted by law."
            forComponents: ["Opal.About"]
        },
        License {
            spdxId: "WTFPL"
            forComponents: ["My.Extra.Component", "The Other Library", "Yet Another Lib"]
        },
        License {
            spdxId: "MIT"
            forComponents: ["Other Imaginary Components"]
        }
    ]

    sourcesUrl: "https://github.com/Pretty-SFOS/opal-about"
    extraSections: [
        InfoSection {
            title: qsTr("Data")
            text: qsTr("Lorem ipsum dolor sit amet et cetera ad libitum plurum sid alum.")
            button.text: qsTr("Data License")
            button.onClicked: Qt.openUrlExternally("https://example.org")
        },
        InfoSection {
            title: qsTr("Extra info")
            text: qsTr("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. " +
                       "Aenean commodo ligula eget dolorus.")
        }
    ]

    contributionSections: [
        ContributionSection {
            title: qsTr("Development")
            groups: [
                ContributionGroup {
                    title: qsTr("Programming")
                    entries: ["ichthyosaurus", "At Lanta", "Jane Doe"]
                },
                ContributionGroup {
                    title: qsTr("Icon Design")
                    entries: ["Sailfish", "Jolla", "John Doe"]
                }
            ]
        },
        ContributionSection {
            title: qsTr("Translations")
            groups: [
                ContributionGroup {
                    title: qsTr("English")
                    entries: ["Some Body", "Bodhi Sam", "Sam B. Dy"]
                },
                ContributionGroup {
                    title: qsTr("German")
                    entries: [] // an empty section will be invisible
                }
            ]
        },
        ContributionSection {
            title: qsTr("Third-party libraries")
            groups: [
                ContributionGroup {
                    title: qsTr("Some Software")
                    entries: ["Someone", "The original author", "Maintainer and tame aimer"]
                },
                ContributionGroup {
                    title: qsTr("Other Library")
                    entries: ["Sailfish", "Fish sail"]
                }
            ]
        }
    ]

    PullDownMenu {
        parent: page.flickable
        MenuItem {
            text: qsTr("Open another page")
            onClicked: pageStack.push(Qt.resolvedUrl("EmptyDummyPage.qml"))
        }
    }
}
