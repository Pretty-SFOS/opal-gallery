/*
 * This file is part of harbour-opal-gallery.
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

        section {
            criteria: ViewSection.FullString
            property: "section"
            labelPositioning: ViewSection.InlineLabels
            delegate: Component {
                Column {
                    x: Theme.horizontalPageMargin
                    height: Math.max(Theme.itemSizeSmall, childrenRect.height
                                     + Theme.paddingMedium)
                    width: (parent ? parent.width : Screen.width) - x*2
                    spacing: Theme.paddingSmall

                    Label {
                        width: parent.width
                        topPadding: Theme.paddingMedium
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: Theme.fontSizeSmall
                        truncationMode: TruncationMode.Fade
                        color: palette.highlightColor

                        text: {
                            if (section == "released") {
                                qsTr("Released modules")
                            } else if (section == "development") {
                                qsTr("In development")
                            } else {
                                section
                            }
                        }
                    }

                    Label {
                        width: parent.width
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: Theme.fontSizeSmall
                        wrapMode: Text.Wrap
                        color: palette.secondaryHighlightColor

                        text: {
                            if (section == "released") {
                                qsTr("These modules are finished and are ready to " +
                                     "be used in your apps. They are fully documented " +
                                     "in the Sailfish IDE.")
                            } else if (section == "development") {
                                qsTr("These are development previews of new " +
                                     "and unfinished modules. Documentation is " +
                                     "missing and APIs may change.")
                            }
                        }
                    }
                }
            }
        }

        delegate: ListItem {
            id: listItem
            contentHeight: Math.max(Theme.itemSizeExtraLarge,
                                    contents.height+2*Theme.paddingMedium)
            menu: contextMenu
            onClicked: openMenu()

            property string key: model.key
            property string title: model.title
            property string description: model.description
            property string mainLicenseSpdx: model.mainLicenseSpdx
            property string examplePage: model.examplePage
            property string section: model.section

            // translations must be prepared with QT_TRANSLATE_NOOP
            property string translatedDescription: qsTranslate("ModuleDescriptions", description)

            function showAboutPage() {
                pageStack.push(Qt.resolvedUrl("AboutModulePageBase.qml"), app.moduleDetails[key])
            }

            function showExamplePage() {
                pageStack.push(Qt.resolvedUrl("../module-pages/" + examplePage))
            }

            Column {
                id: contents
                width: parent.width - 2*Theme.horizontalPageMargin
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top; topMargin: Theme.paddingSmall
                }

                Label {
                    text: title
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
                        onClicked: listItem.showExamplePage()
                    }
                    MenuItem {
                        text: qsTr("About")
                        onClicked: listItem.showAboutPage()
                    }
                }
            }
        }
    }
}
