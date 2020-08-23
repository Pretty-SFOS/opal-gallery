import QtQuick 2.0
import Sailfish.Silica 1.0
import Opal.About 1.0

AboutPageBase {
    id: page
    allowedOrientations: Orientation.All
    appName: "Opal Gallery"
    iconSource: Qt.resolvedUrl("../images/harbour-opal.png")
    versionNumber: app.versionNumber
    description: qsTr("Opal is a collection of pretty QML components " +
                      "for SailfishOS, building on top of Sailfish's Silica components.")
    author: "ichthyosaurus"
    licenses: License { spdxId: "GPL-3.0-or-later" }
    sourcesUrl: "https://github.com/Pretty-SFOS/opal"
}
