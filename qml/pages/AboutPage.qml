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
                        "Dan",
                        "Максим Горпиніч"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Turkish")
                    entries: [
                        "Burak Hüseyin Ekseli"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Tamil")
                    entries: [
                        "தமிழ்நேரம்"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Swedish")
                    entries: [
                        "bittin1ddc447d824349b2",
                        "Åke Engelbrektson"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Spanish")
                    entries: [
                        "Carmen F. B.",
                        "Francisco Serrador",
                        "Jaime Marquínez Ferrándiz",
                        "Kamborio",
                        "Mirian Margiani",
                        "gallegonovato",
                        "iloky_67"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Slovak")
                    entries: [
                        "Milan Šalka"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Russian")
                    entries: [
                        "Lilia Savciuc",
                        "Marat Ismailov",
                        "Nikolai Sinyov",
                        "Romeostar",
                        "RoundedRectangle",
                        "Victor K",
                        "gfbdrgng",
                        "vanapro1"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Romanian")
                    entries: [
                        "Alex Zander",
                        "GREEN MONSTER"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Polish")
                    entries: [
                        "Eryk Michalak",
                        "J3Extreme"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Norwegian Bokmål")
                    entries: [
                        "Mirian Margiani"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Italian")
                    entries: [
                        "RoundedRectangle",
                        "luca rastelli"
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
                        "Adi",
                        "David D.",
                        "J. Lavoie",
                        "Laurent FAVOLE",
                        "Mirian Margiani"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Finnish")
                    entries: [
                        "Elmeri Länsiharju",
                        "Lassi Määttä"
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
                    title: qsTr("Czech")
                    entries: [
                        "Jiří Vírava",
                        "Michal Čihař"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Chinese")
                    entries: [
                        "JiaJia",
                        "Larm Kai Xian",
                        "yangyangdaji",
                        "复予"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Brazilian Portuguese")
                    entries: [
                        "Mateus Liberale Gomes",
                        "Thiago Carmona"
                    ]
                }
            ]
        }
        //<<< GENERATED LIST OF TRANSLATION CREDITS
    ]
}
