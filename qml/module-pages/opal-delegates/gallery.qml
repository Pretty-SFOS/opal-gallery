//@ This file is part of opal-delegates.
//@ https://github.com/Pretty-SFOS/opal-delegates
//@ SPDX-FileCopyrightText: 2023 Peter G. (nephros)
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Opal.Gallery 1.0
import Sailfish.Silica 1.0 as S
import Opal.Delegates 1.0 as D

S.Page {
    id: root
    allowedOrientations: S.Orientation.All

    GalleryFruitModel { id: fruitModel }
    GalleryChatModel { id: chatModel }

    Component {
        id: dummyMenu

        S.ContextMenu {
            S.MenuItem {
                text: qsTranslate("Opal.Delegates", "Example action", "as in: “take an action”, " +
                           "this is just a dummy placeholder")
                onClicked: pageStack.push("EmptyDummyPage.qml")
            }
        }
    }

    S.SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: column.height + S.Theme.horizontalPageMargin

        S.VerticalScrollDecorator {
            flickable: flick
        }

        Column {
            id: column
            width: parent.width
            spacing: S.Theme.paddingLarge

            S.PageHeader {
                title: "Opal.Delegates"
            }

            S.SectionHeader {
                text: qsTranslate("Opal.Delegates", "Anatomy")
            }

            GalleryLabel {
                text: qsTranslate("Opal.Delegates", "Delegates are based on the “PaddedDelegate” component. " +
                           "It provides outer padding on all sides, as well as three " +
                           "optional content parts: left, center, and right.")
            }

            D.PaddedDelegate {
                property int index: 2
                showOddEven: emphasizeRows.checked

                padding.topBottom: S.Theme.paddingLarge
                spacing: S.Theme.paddingMedium

                Rectangle {
                    anchors.fill: parent
                    color: S.Theme.rgba(S.Theme.secondaryHighlightColor, 0.5)
                }

                S.Label {
                    anchors.centerIn: parent
                    text: "contentItem"
                    font.pixelSize: S.Theme.fontSizeTiny
                }

                leftItem: Item {
                    width: S.Theme.itemSizeMedium
                    height: width

                    Rectangle {
                        anchors.fill: parent
                        color: S.Theme.rgba(S.Theme.secondaryHighlightColor, 0.5)
                    }

                    S.Label {
                        anchors.centerIn: parent
                        text: "leftItem"
                        font.pixelSize: S.Theme.fontSizeTiny
                    }
                }

                rightItem: Item {
                    width: S.Theme.itemSizeMedium
                    height: width

                    Rectangle {
                        anchors.fill: parent
                        color: S.Theme.rgba(S.Theme.secondaryHighlightColor, 0.5)
                    }

                    S.Label {
                        anchors.centerIn: parent
                        text: "rightItem"
                        font.pixelSize: S.Theme.fontSizeTiny
                    }
                }
            }

            GalleryLabel {
                text: qsTranslate("Opal.Delegates", "Rows can be highlighted alternatingly to make them " +
                           "more distinct.")
            }

            S.TextSwitch {
                id: emphasizeRows
                text: qsTranslate("Opal.Delegates", "Emphasize rows")
                checked: false
            }

            S.SectionHeader {
                text: "OneLineDelegate"
            }

            GalleryLabel {
                text: qsTranslate("Opal.Delegates", "This component has only one content line. Left " +
                           "and right contents can be customized.")
            }

            D.DelegateColumn {
                model: chatModel
                delegate: D.OneLineDelegate {
                    text: post
                    showOddEven: emphasizeRows.checked
                    interactive: false
                    textLabel.wrapped: true

                    leftItem: D.DelegateInfoItem {
                        title: nick
                        description: when

                        titleLabel.palette {
                            primaryColor: normalColor
                            highlightColor: highlightColor
                        }
                        titleLabel.anchors {
                            right: titleLabel.parent.right
                            horizontalCenter: undefined
                        }
                        descriptionLabel.anchors {
                            right: descriptionLabel.parent.right
                            horizontalCenter: undefined
                        }

                        property color normalColor: Qt.tint(baseColor, S.Theme.rgba(S.Theme.highlightColor, 0.5))
                        property color highlightColor: normalColor
                        property color baseColor: chatModel.statusColor(statusType)
                    }
                }
            }

            S.SectionHeader {
                text: "TwoLineDelegate"
            }

            GalleryLabel {
                text: qsTranslate("Opal.Delegates", "This component has two content lines. The " +
                           "left and right items use “DelegateIconItem” and " +
                           "“DelegateInfoItem” respectively.")
            }

            D.DelegateColumn {
                model: fruitModel
                delegate: D.TwoLineDelegate {
                    text: name
                    description: desc

                    showOddEven: emphasizeRows.checked
                    menu: dummyMenu

                    leftItem: D.DelegateIconItem {
                        source: "image://theme/icon-m-favorite"
                    }
                    rightItem: D.DelegateInfoItem {
                        text: price
                        description: qsTranslate("Opal.Delegates", "per kg")
                        alignment: Qt.AlignRight
                    }

                    onClicked: {
                        toggleWrappedText(descriptionLabel)
                    }
                }
            }

            S.SectionHeader {
                text: "ThreeLineDelegate"
            }

            GalleryLabel {
                text: qsTranslate("Opal.Delegates", "This component has three content lines. All lines " +
                           "are optional and will be hidden if they are empty.")
            }

            D.DelegateColumn {
                model: fruitModel
                delegate: D.ThreeLineDelegate {
                    title: sale
                    text: name
                    description: desc

                    showOddEven: emphasizeRows.checked
                    menu: dummyMenu

                    onClicked: {
                        toggleWrappedText(descriptionLabel)
                    }
                }
            }

            S.SectionHeader {
                text: qsTranslate("Opal.Delegates", "Drag and drop")
            }

            GalleryLabel {
                text: qsTranslate("Opal.Delegates", "This module natively supports the drag-and-drop " +
                                  "action for manually sorting lists via the Opal.DragDrop module. " +
                                  "See the example page of Opal.DragDrop for details.")
            }

            S.SectionHeader {
                text: qsTranslate("Opal.Delegates", "Complex customizations")
            }

            GalleryLabel {
                text: qsTranslate("Opal.Delegates", "All contents can be customized. Complex content items are " +
                           "possible.")
            }

            D.DelegateColumn {
                model: chatModel
                delegate: D.ThreeLineDelegate {
                    id: delegate
                    title: nick
                    text: post
                    description: when
                    showOddEven: emphasizeRows.checked
                    menu: dummyMenu

                    leftItem: D.DelegateIconItem {
                        source: "image://theme/icon-m-outline-chat"
                    }

                    Row {
                        spacing: S.Theme.paddingMedium
                        anchors {
                            bottom: parent.bottom
                            bottomMargin: S.Theme.paddingSmall
                            right: parent.right
                        }

                        D.OptionalLabel {
                            id: statusLabel
                            text: status
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: S.Theme.fontSizeSmall

                            palette {
                                primaryColor: statusMark.highlightColor
                                highlightColor: S.Theme.secondaryHighlightColor
                            }
                        }

                        Rectangle {
                            id: statusMark
                            width: S.Theme.iconSizeExtraSmall * 2
                            height: S.Theme.iconSizeExtraSmall * 0.3
                            anchors.bottom: statusLabel.baseline
                            radius: height
                            color: highlighted ? highlightColor : baseColor

                            property color highlightColor: Qt.tint(baseColor, S.Theme.rgba(S.Theme.highlightColor, 0.5))
                            property color baseColor: chatModel.statusColor(statusType)
                        }
                    }
                }
            }

            S.SectionHeader {
                text: qsTranslate("Opal.Delegates", "Side elements")
            }

            GalleryLabel {
                text: qsTranslate("Opal.Delegates", "All examples use components as side elements that are " +
                                  "part of Opal.Delegates. Below is an example that shows how the " +
                                  "“DelegateIconButton” component can be used.")
            }

            D.DelegateColumn {
                model: chatModel

                delegate: D.OneLineDelegate {
                    text: nick
                    showOddEven: emphasizeRows.checked
                    interactive: false
                    padding.topBottom: 0  // makes a small delegate more compact

                    // This is the relevant part of this example.
                    rightItem: D.DelegateIconButton {
                        iconSource: "image://theme/icon-s-setting"
                        iconSize: S.Theme.iconSizeSmall

                        // Text is optional.
                        // text: qsTranslate("Opal.Delegates", "Settings")

                        // A fixed width can be set to align side items
                        // if they differ in width.
                        // width: S.Theme.itemSizeSmall

                        onClicked: pageStack.push("EmptyDummyPage.qml")
                    }

                    // This code is just for illustration.
                    leftItem: S.TextSwitch {
                        checked: false
                        down: false
                        width: S.Theme.iconSizeSmall
                        height: width
                        leftMargin: 0
                        rightMargin: 0
                        palette.primaryColor: chatModel.statusColor(statusType)

                        Binding {
                            // This is a hack and may break at any time.
                            // It overrides the fixed height of the indicator
                            // item that would otherwise force the item to be
                            // very large.
                            target: _indicator().parent
                            property: "height"
                            value: height
                        }
                    }
                }
            }
        }
    }
}
