//@ This file is part of opal-dragdrop.
//@ https://github.com/Pretty-SFOS/opal-dragdrop
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import Opal.Gallery 1.0
import Opal.Delegates 1.0 as D
import Opal.MenuSwitch 1.0 as M
import Opal.DragDrop 1.0

S.Page {
    id: root
    allowedOrientations: S.Orientation.All

    property bool dragMode: true

    S.SilicaListView {
        id: view
        anchors.fill: parent
        model: GalleryLongFruitModel {}

        S.VerticalScrollDecorator {
            flickable: view
        }

        header: S.PageHeader {
            title: "Opal.DragDrop"
        }

        footer: Item {
            width: parent.width
            height: S.Theme.horizontalPageMargin
        }

        S.PullDownMenu {
            M.MenuSwitch {
                text: qsTranslate("Opal.DragDrop.FullPageView.Gallery", "Enable drag and drop")
                checked: dragMode
                automaticCheck: false
                onClicked: dragMode = !dragMode
            }
        }

        // Create a drag handler for the SilicaListView.
        ViewDragHandler {
            id: viewDragHandler
            listView: parent
            active: dragMode

            // Setting the flickable explicitly is not necessary here,
            // because the SilicaListView itself is the main flickable on
            // this page.
            // --- flickable: view

            onItemMoved: S.Notices.show("moving %1 to %2".
                arg(fromIndex).arg(toIndex), 2000, S.Notice.Top)
        }

        delegate: D.TwoLineDelegate {
            text: name
            description: qsTranslate("Opal.DragDrop.FullPageView.Gallery", "Current index: %1").arg(index)

            // Register the drag handler in the delegate.
            dragHandler: viewDragHandler

            leftItem: D.DelegateIconItem {
                source: "image://theme/icon-m-favorite"
            }
            rightItem: D.DelegateInfoItem {
                text: price
                description: qsTranslate("Opal.DragDrop.FullPageView.Gallery", "per kg")
                alignment: Qt.AlignRight
            }

            onClicked: S.Notices.show(name, 2000, S.Notice.Top)
        }
    }
}
