/*
 * This file is part of harbour-opal-gallery.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2023 Mirian Margiani
 */

/*
 * Translators:
 * Please add yourself to the list of contributors below. If your language is already
 * in the list, add your name to the 'entries' field. If you added a new translation,
 * create a new section at the top of the list.
 *
 * Other contributors:
 * Please add yourself to the relevant list of contributors.
 *
 * <...>
 *  ContributionGroup {
 *      title: qsTr("Your language")
 *      entries: ["Existing contributor", "YOUR NAME HERE"]
 *  },
 * <...>
 *
 */

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import Opal.About 1.0 as A
import "../modules/Opal/Attributions"

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
    mainAttributions: "2020-2023 Mirian Margiani"

    attributions: [
        //>>> GENERATED LIST OF ATTRIBUTIONS
        OpalAboutAttribution {},
        OpalInfoComboAttribution {},
        OpalComboDataAttribution {},
        OpalLinkHandlerAttribution {}
        //<<< GENERATED LIST OF ATTRIBUTIONS
    ]

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
        A.ContributionSection {
            title: qsTr("Translations")
            groups: [
                A.ContributionGroup {
                    title: qsTr("English")
                    entries: ["Mirian Margiani"]
                },
                A.ContributionGroup {
                    title: qsTr("German")
                    entries: ["Mirian Margiani", "J. Lavoie"]
                },
                A.ContributionGroup {
                    title: qsTr("French")
                    entries: ["J. Lavoie"]
                },
                A.ContributionGroup {
                    title: qsTr("Indonesian")
                    entries: ["Reza Almanda"]
                }
            ]
        }
    ]
}
