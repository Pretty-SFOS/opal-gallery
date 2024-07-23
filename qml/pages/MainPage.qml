/*
 * This file is part of harbour-opal-gallery.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2021 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import Opal.Delegates 1.0 as D

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

        footer: Item {
            width: parent.width
            height: Theme.horizontalPageMargin
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

        delegate: D.ThreeLineDelegate {
            id: listItem
            property string _key: model.key
            property string _title: model.title
            property string _description: model.description
            property string _mainLicenseSpdx: model.mainLicenseSpdx
            property string _examplePage: model.examplePage
            property string _section: model.section

            // translations must be prepared with QT_TRANSLATE_NOOP
            property string _translatedDescription: qsTranslate("ModuleDescriptions", _description)

            function showAboutPage() {
                pageStack.push(Qt.resolvedUrl("AboutModulePageBase.qml"), app.moduleDetails[_key])
            }

            function showExamplePage() {
                pageStack.push(Qt.resolvedUrl("../module-pages/" + _examplePage))
            }

            title: _title
            text: _translatedDescription
            description: _mainLicenseSpdx

            menu: contextMenu
            onClicked: openMenu()

            titleLabel {
                wrapped: true
                font.pixelSize: Theme.fontSizeMedium

                palette {
                    primaryColor: Theme.primaryColor
                    highlightColor: Theme.highlightColor
                }
            }

            textLabel {
                wrapped: true
                font.pixelSize: Theme.fontSizeExtraSmall

                palette {
                    primaryColor: Theme.secondaryColor
                    highlightColor: Theme.secondaryHighlightColor
                }
            }

            descriptionLabel {
                font.pixelSize: Theme.fontSizeExtraSmall
                opacity: Theme.opacityHigh

                palette {
                    primaryColor: Theme.secondaryColor
                    highlightColor: Theme.secondaryHighlightColor
                }
            }

            leftItem: D.DelegateIconItem {
                source: "../images/icon-m-opal.png"
                opacity: {
                    if (highlighted) 0.9
                    else if (section === "released") Math.max(0.5, 1.0 - index * 0.05)
                    else if (section === "development") Math.max(0.3, 0.5 - index * 0.01)
                    else Math.max(0.5, 0.8 - index * 0.01)
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
                        visible: !!app.moduleDetails[_key]
                        text: qsTr("About")
                        onClicked: listItem.showAboutPage()
                    }
                }
            }
        }
    }
}
