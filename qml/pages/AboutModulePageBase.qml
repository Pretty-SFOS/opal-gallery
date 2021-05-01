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
    iconSource: Qt.resolvedUrl("../images/harbour-opal.png")
    versionNumber: APP_VERSION
    releaseNumber: APP_RELEASE
    licenses: A.License { spdxId: mainLicenseSpdx }

    // from module
    appName: ""
    description: ""
    maintainer: ""
    property string mainLicenseSpdx: ""
    sourcesUrl: ""
}
