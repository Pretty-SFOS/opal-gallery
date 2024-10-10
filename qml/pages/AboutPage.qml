/*
 * This file is part of harbour-opal-gallery.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2023 Mirian Margiani
 */

/*
 * Translators:
 * Please add yourself to the list of translators in TRANSLATORS.json.
 * If your language is already in the list, add your name to the 'entries'
 * field. If you added a new translation, create a new section in the 'extra' list.
 *
 * Other contributors:
 * Please add yourself to the relevant list of contributors below.
 *
*/

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import Opal.About 1.0 as A

A.AboutPageBase {
    id: root

    appName: qsTr("Opal Gallery")
    appIcon: Qt.resolvedUrl("../images/%1.png".arg(Qt.application.name))
    appVersion: APP_VERSION
    appRelease: APP_RELEASE

    allowDownloadingLicenses: false
    sourcesUrl: "https://github.com/Pretty-SFOS/opal"
    homepageUrl: "https://forum.sailfishos.org/t/opal-qml-components-for-app-development/15801"
    translationsUrl: "https://hosted.weblate.org/projects/opal"
    changelogList: Qt.resolvedUrl("../Changelog.qml")
    licenses: A.License { spdxId: "GPL-3.0-or-later" }

    donations.text: donations.defaultTextCoffee
    donations.services: [
        A.DonationService {
            name: "Liberapay"
            url: "https://liberapay.com/ichthyosaurus"
        }
    ]

    description: qsTr("Opal is a collection of pretty QML components " +
                      "for SailfishOS, building on top of Sailfish's Silica components.")
    mainAttributions: "2020-%1 Mirian Margiani".arg((new Date()).getFullYear())
    autoAddOpalAttributions: true

    contributionSections: [
        /* A.ContributionSection {
            title: qsTr("Development")
            groups: [
                A.ContributionGroup {
                    title: qsTr("Programming")
                    entries: ["Mirian Margiani"]
                },
                A.ContributionGroup {
                    title: qsTr("Icon Design")
                    entries: ["Sailfish (Jolla)", "Mirian Margiani"]
                }
            ]
        }, */

        //>>> GENERATED LIST OF TRANSLATION CREDITS
        A.ContributionSection {
            title: qsTr("Translations")
            groups: [
                A.ContributionGroup {
                    title: qsTr("Ukrainian")
                    entries: [
                        "Bohdan Kolesnyk",
                        "Dan"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Swedish")
                    entries: [
                        "Åke Engelbrektson"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Spanish")
                    entries: [
                        "Jaime Marquínez Ferrándiz",
                        "Mirian Margiani",
                        "gallegonovato"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Russian")
                    entries: [
                        "Lilia Savciuc",
                        "Marat Ismailov",
                        "Nikolai Sinyov"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Polish")
                    entries: [
                        "Eryk Michalak"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Norwegian Bokmål")
                    entries: [
                        "Mirian Margiani"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Moldavian")
                    entries: [
                        "Lilia Savciuc"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Italian")
                    entries: [
                        "RoundedRectangle"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Indonesian")
                    entries: [
                        "Reza Almanda"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("German")
                    entries: [
                        "J. Lavoie",
                        "Mirian Margiani"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("French")
                    entries: [
                        "J. Lavoie",
                        "Mirian Margiani"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Estonian")
                    entries: [
                        "Priit Jõerüüt"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("English")
                    entries: [
                        "Mirian Margiani"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Chinese")
                    entries: [
                        "JiaJia",
                        "yangyangdaji",
                        "复予"
                    ]
                }
            ]
        }
        //<<< GENERATED LIST OF TRANSLATION CREDITS
    ]
}
