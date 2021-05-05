/*
 * This file is part of harbour-opal.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2021 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaListView {
        id: view
        anchors.fill: parent
        VerticalScrollDecorator {}

        PullDownMenu {
            MenuItem {
                text: qsTr("About Opal")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutOpalPage.qml"))
            }
        }

        header: PageHeader {
            title: qsTr("Opal Gallery")
            description: qsTr("for form and function")
        }

        model: app.modules

        delegate: ListItem {
            id: listItem
            contentHeight: Math.max(Theme.itemSizeExtraLarge,
                                    contents.height+2*Theme.paddingMedium)
            menu: contextMenu
            onClicked: openMenu()

            // translations must be prepared with QT_TRANSLATE_NOOP
            property string translatedDescription: qsTranslate("ModuleDescriptions", modelData.description)

            Column {
                id: contents
                width: parent.width - 2*Theme.horizontalPageMargin
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top; topMargin: Theme.paddingSmall
                }

                Label {
                    text: modelData.title
                    wrapMode: Text.Wrap
                    width: parent.width
                }

                Label {
                    text: listItem.translatedDescription
                    font.pixelSize: Theme.fontSizeSmall
                    color: highlighted ? Theme.secondaryHighlightColor
                                       : Theme.secondaryColor
                    wrapMode: Text.Wrap
                    textFormat: Text.StyledText
                    width: parent.width
                }
            }

            Component {
                id: contextMenu
                ContextMenu {
                    MenuItem {
                        text: qsTr("Preview and Examples")
                        onClicked: pageStack.push(Qt.resolvedUrl("../module-pages/"+modelData.examplePage))
                    }
                    MenuItem {
                        text: qsTr("About")
                        onClicked: pageStack.push(Qt.resolvedUrl("AboutModulePageBase.qml"), {
                                                      appName: modelData.title,
                                                      description: listItem.translatedDescription,
                                                      mainAttributions: modelData.mainAttributions,
                                                      versionNumber: modelData.versionNumber,
                                                      mainLicenseSpdx: modelData.mainLicenseSpdx,
                                                      sourcesUrl: modelData.sourcesUrl
                                                  })
                    }
                }
            }
        }
    }
}
