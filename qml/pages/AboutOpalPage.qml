/*
 * This file is part of harbour-opal.
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
    iconSource: Qt.resolvedUrl("../images/harbour-opal.png")
    versionNumber: APP_VERSION
    releaseNumber: APP_RELEASE
    description: qsTr("Opal is a collection of pretty QML components " +
                      "for SailfishOS, building on top of Sailfish's Silica components.")
    authors: "ichthyosaurus"
    licenses: A.License { spdxId: "GPL-3.0-or-later" }
    sourcesUrl: "https://github.com/Pretty-SFOS/opal"
}
