/*
 * This file is part of harbour-opal-gallery.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2021 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import Opal.About 1.0 as A

A.AboutPageBase {
    id: page
    allowedOrientations: S.Orientation.All
    appIcon: Qt.resolvedUrl("../images/harbour-opal-gallery.png")
    licenses: A.License { spdxId: mainLicenseSpdx }
    autoAddOpalAttributions: false

    // from module
    appName: ""
    appVersion: ""
    appRelease: ""
    description: ""
    mainAttributions: []
    property string mainLicenseSpdx: ""
    sourcesUrl: ""

    property var maintainers: []
    property var contributors: []

    contributionSections: A.ContributionSection {
        groups: [
            A.ContributionGroup {
                title: qsTr("Maintainers")
                entries: maintainers
            },
            A.ContributionGroup {
                title: qsTr("Contributors")
                entries: contributors
            }
        ]
    }
}
