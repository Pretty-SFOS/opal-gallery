import QtQuick 2.0
import Sailfish.Silica 1.0
import Opal.About 1.0

AboutPageBase {
    id: page
    allowedOrientations: Orientation.All
    iconSource: Qt.resolvedUrl("../images/harbour-opal.png")
    versionNumber: app.versionNumber
    licenses: License { spdxId: mainLicenseSpdx }

    // from module
    appName: ""
    description: ""
    author: ""
    property string mainLicenseSpdx: ""
    sourcesUrl: ""
}
