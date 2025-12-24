//@ This file is part of Opal.DragDrop for use in harbour-opal-gallery.
//@ https://github.com/Pretty-SFOS/opal-dragdrop
//@ SPDX-License-Identifier: GPL-3.0-or-later
//@ SPDX-FileCopyrightText: 2023-2024 Mirian Margiani

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import Opal.Gallery 1.0
import Opal.Delegates 1.0 as D
import Opal.MenuSwitch 1.0 as M
import Opal.DragDrop 1.0
import "gallery"

S.Page {
    id: root
    allowedOrientations: S.Orientation.All

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
                title: "Opal.DragDrop"
            }

            S.TextSwitch {
                id: dragMode
                text: qsTranslate("Opal.DragDrop", "Enable drag and drop")
                description: qsTranslate("Opal.DragDrop", "Toggle this switch to see " +
                                         "how components react.")
                checked: true
            }

            S.Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: S.Theme.buttonWidthLarge
                text: qsTranslate("Opal.DragDrop", "Full page view")
                onClicked: pageStack.push(Qt.resolvedUrl("gallery/FullPageView.qml"))
            }

            S.SectionHeader {
                text: qsTranslate("Opal.DragDrop", "Views using “Opal.Delegates”")
            }

            GalleryLabel {
                text: qsTranslate("Opal.DragDrop", "The Opal.Delegates module supports drag and drop " +
                           "using the Opal.DragDrop module without further configuration.")
            }

            S.SilicaListView {
                model: GalleryFruitModel {}
                width: parent.width
                contentHeight: model.count * S.Theme.itemSizeSmall
                height: contentHeight

                // Create a drag handler for the SilicaListView.
                ViewDragHandler {
                    id: viewDragHandler1
                    listView: parent
                    active: dragMode.checked

                    // Setting the flickable explicitly is only necessary when
                    // the list view itself is not the main flickable of a page.
                    // Usually, a page in a Sailfish app has either a column or
                    // a list view at its root. In this case, setting the flickable
                    // explicitly is not required.
                    flickable: flick
                }

                delegate: D.OneLineDelegate {
                    text: name
                    interactive: false

                    // Register the drag handler in the delegate.
                    dragHandler: viewDragHandler1

                    leftItem: D.DelegateIconItem {
                        source: "image://theme/icon-m-favorite"
                    }
                    rightItem: D.DelegateInfoItem {
                        text: price
                        description: qsTranslate("Opal.DragDrop", "per kg")
                        alignment: Qt.AlignRight
                    }
                }
            }

            S.SectionHeader {
                text: qsTranslate("Opal.DragDrop", "Custom views")
            }

            GalleryLabel {
                text: qsTranslate("Opal.DragDrop", "It only takes a few lines more code to enable drag and drop" +
                           "in custom views that do not use the Opal.Delegates module.")
            }

            S.SilicaListView {
                model: GalleryChatModel {}
                width: parent.width
                contentHeight: model.count * S.Theme.itemSizeSmall
                height: contentHeight

                // Create a drag handler for the SilicaListView.
                ViewDragHandler {
                    id: viewDragHandler2
                    listView: parent
                    active: dragMode.checked

                    // see comment on viewDragHandler1 for why this is necessary
                    flickable: flick
                }

                delegate: S.ListItem {
                    id: delegate
                    contentHeight: S.Theme.itemSizeSmall

                    S.Label {
                        text: nick
                        truncationMode: S.TruncationMode.Fade
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: S.Theme.horizontalPageMargin
                            right: handle.left
                            rightMargin: S.Theme.paddingMedium
                        }
                    }

                    // Create a visual handle to grab the item, and connect
                    // it to the drag handler of the view and the drag handler
                    // of the delegate.
                    //
                    // This part is already taken care of when using Opal.Delegates.
                    DragHandle {
                        id: handle

                        anchors {
                            right: parent.right
                            rightMargin: S.Theme.horizontalPageMargin
                        }

                        // The delegate needs its own drag handler that is
                        // connected to the outer drag handler of the view.
                        // The delegate drag handler must know the index
                        // of the delegate.
                        moveHandler: DelegateDragHandler {
                            viewHandler: viewDragHandler2
                            handledItem: delegate
                            modelIndex: index
                        }
                    }
                }
            }

            S.SectionHeader {
                text: qsTranslate("Opal.DragDrop", "Long views")
            }

            GalleryLabel {
                text: qsTranslate("Opal.DragDrop", "In long lists, dragging below the bottom end or above " +
                           "the top end of the visible area will scroll the view " +
                           "accordingly.")
            }

            S.SilicaListView {
                model: GalleryLongFruitModel {}
                width: parent.width
                contentHeight: model.count * S.Theme.itemSizeSmall
                height: contentHeight

                // Create a drag handler for the SilicaListView.
                ViewDragHandler {
                    id: viewDragHandler3
                    listView: parent
                    active: dragMode.checked

                    // Setting the flickable explicitly is only necessary when
                    // the list view itself is not the main flickable of a page.
                    // Usually, a page in a Sailfish app has either a column or
                    // a list view at its root. In this case, setting the flickable
                    // explicitly is not required.
                    flickable: flick
                }

                delegate: D.OneLineDelegate {
                    text: name
                    interactive: false

                    // Register the drag handler in the delegate.
                    dragHandler: viewDragHandler3

                    leftItem: D.DelegateIconItem {
                        source: "image://theme/icon-m-favorite"
                    }
                    rightItem: D.DelegateInfoItem {
                        text: price
                        description: qsTranslate("Opal.DragDrop", "per kg")
                        alignment: Qt.AlignRight
                    }
                }
            }
        }
    }
}
