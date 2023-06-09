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
    appName: qsTr("Opal Gallery")
    appIcon: Qt.resolvedUrl("../images/harbour-opal-gallery.png")
    appVersion: APP_VERSION
    appRelease: APP_RELEASE
    description: qsTr("Opal is a collection of pretty QML components " +
                      "for SailfishOS, building on top of Sailfish's Silica components.")
    authors: "2020-2021 Mirian Margiani"
    licenses: A.License { spdxId: "GPL-3.0-or-later" }
    attributions: A.OpalAboutAttribution {}
    sourcesUrl: "https://github.com/Pretty-SFOS/opal"
    changelogList: Qt.resolvedUrl("../Changelog.qml")
}
