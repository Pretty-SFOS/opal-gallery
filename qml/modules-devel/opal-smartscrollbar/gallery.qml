/*
 * This file is part of harbour-opal.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2024 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0 as S

S.Page {
    id: root
    allowedOrientations: S.Orientation.All

    S.SilicaListView {
        id: flick
        anchors.fill: parent

        SmartScrollbar {
            id: scrollbar
            flickable: flick

            readonly property int scrollIndex: !!flickable ?
                flickable.indexAt(flickable.contentX, flickable.contentY) : -1

            text: scrollIndex < 0 ? "" : "%1 / %2".arg(scrollIndex + 2).arg(flick.count)
            description: "Group #%1".arg(flick.currentSection)

            // both are enabled by default
            quickScrollWhen: true
            smartWhen: true
        }

        header: S.PageHeader {
            title: "SmartScrollbar"
            description: "smart: %1 | quick: %2".
                arg(scrollbar.smartWhen ? "true" : "false").
                arg(scrollbar.quickScrollWhen ? "true" : "false")
        }

        S.PullDownMenu {
            S.MenuItem {
                text: qsTr("Toggle smart scrollbar")
                onClicked: scrollbar.smartWhen = !scrollbar.smartWhen
            }
            S.MenuItem {
                text: qsTr("Toggle quick scrolling")
                onClicked: scrollbar.quickScrollWhen = !scrollbar.quickScrollWhen
            }
        }

        footer: Item {
            width: parent.width
            height: S.Theme.horizontalPageMargin
        }

        section {
            property: "group"
            delegate: S.SectionHeader {
                text: "Group #%1".arg(flick.currentSection)
            }
        }

        model: listModel

        delegate: S.ListItem {
            contentHeight: S.Theme.itemSizeSmall

            S.Label {
                width: parent.width - 2*x
                x: S.Theme.horizontalPageMargin
                text: "Item #%1".arg(entry)
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    ListModel {
        id: listModel

        ListElement { property int group: 1; property int entry: 1 }
        ListElement { property int group: 1; property int entry: 2 }
        ListElement { property int group: 1; property int entry: 3 }
        ListElement { property int group: 1; property int entry: 4 }
        ListElement { property int group: 1; property int entry: 5 }
        ListElement { property int group: 1; property int entry: 6 }
        ListElement { property int group: 1; property int entry: 7 }
        ListElement { property int group: 1; property int entry: 8 }
        ListElement { property int group: 1; property int entry: 9 }
        ListElement { property int group: 1; property int entry: 10 }
        ListElement { property int group: 2; property int entry: 1 }
        ListElement { property int group: 2; property int entry: 2 }
        ListElement { property int group: 2; property int entry: 3 }
        ListElement { property int group: 2; property int entry: 4 }
        ListElement { property int group: 2; property int entry: 5 }
        ListElement { property int group: 2; property int entry: 6 }
        ListElement { property int group: 2; property int entry: 7 }
        ListElement { property int group: 2; property int entry: 8 }
        ListElement { property int group: 2; property int entry: 9 }
        ListElement { property int group: 2; property int entry: 10 }
        ListElement { property int group: 3; property int entry: 1 }
        ListElement { property int group: 3; property int entry: 2 }
        ListElement { property int group: 3; property int entry: 3 }
        ListElement { property int group: 3; property int entry: 4 }
        ListElement { property int group: 3; property int entry: 5 }
        ListElement { property int group: 3; property int entry: 6 }
        ListElement { property int group: 3; property int entry: 7 }
        ListElement { property int group: 3; property int entry: 8 }
        ListElement { property int group: 3; property int entry: 9 }
        ListElement { property int group: 3; property int entry: 10 }
        ListElement { property int group: 4; property int entry: 1 }
        ListElement { property int group: 4; property int entry: 2 }
        ListElement { property int group: 4; property int entry: 3 }
        ListElement { property int group: 4; property int entry: 4 }
        ListElement { property int group: 4; property int entry: 5 }
        ListElement { property int group: 4; property int entry: 6 }
        ListElement { property int group: 4; property int entry: 7 }
        ListElement { property int group: 4; property int entry: 8 }
        ListElement { property int group: 4; property int entry: 9 }
        ListElement { property int group: 4; property int entry: 10 }
        ListElement { property int group: 5; property int entry: 1 }
        ListElement { property int group: 5; property int entry: 2 }
        ListElement { property int group: 5; property int entry: 3 }
        ListElement { property int group: 5; property int entry: 4 }
        ListElement { property int group: 5; property int entry: 5 }
        ListElement { property int group: 5; property int entry: 6 }
        ListElement { property int group: 5; property int entry: 7 }
        ListElement { property int group: 5; property int entry: 8 }
        ListElement { property int group: 5; property int entry: 9 }
        ListElement { property int group: 5; property int entry: 10 }
        ListElement { property int group: 6; property int entry: 1 }
        ListElement { property int group: 6; property int entry: 2 }
        ListElement { property int group: 6; property int entry: 3 }
        ListElement { property int group: 6; property int entry: 4 }
        ListElement { property int group: 6; property int entry: 5 }
        ListElement { property int group: 6; property int entry: 6 }
        ListElement { property int group: 6; property int entry: 7 }
        ListElement { property int group: 6; property int entry: 8 }
        ListElement { property int group: 6; property int entry: 9 }
        ListElement { property int group: 6; property int entry: 10 }
        ListElement { property int group: 7; property int entry: 1 }
        ListElement { property int group: 7; property int entry: 2 }
        ListElement { property int group: 7; property int entry: 3 }
        ListElement { property int group: 7; property int entry: 4 }
        ListElement { property int group: 7; property int entry: 5 }
        ListElement { property int group: 7; property int entry: 6 }
        ListElement { property int group: 7; property int entry: 7 }
        ListElement { property int group: 7; property int entry: 8 }
        ListElement { property int group: 7; property int entry: 9 }
        ListElement { property int group: 7; property int entry: 10 }
        ListElement { property int group: 8; property int entry: 1 }
        ListElement { property int group: 8; property int entry: 2 }
        ListElement { property int group: 8; property int entry: 3 }
        ListElement { property int group: 8; property int entry: 4 }
        ListElement { property int group: 8; property int entry: 5 }
        ListElement { property int group: 8; property int entry: 6 }
        ListElement { property int group: 8; property int entry: 7 }
        ListElement { property int group: 8; property int entry: 8 }
        ListElement { property int group: 8; property int entry: 9 }
        ListElement { property int group: 8; property int entry: 10 }
        ListElement { property int group: 9; property int entry: 1 }
        ListElement { property int group: 9; property int entry: 2 }
        ListElement { property int group: 9; property int entry: 3 }
        ListElement { property int group: 9; property int entry: 4 }
        ListElement { property int group: 9; property int entry: 5 }
        ListElement { property int group: 9; property int entry: 6 }
        ListElement { property int group: 9; property int entry: 7 }
        ListElement { property int group: 9; property int entry: 8 }
        ListElement { property int group: 9; property int entry: 9 }
        ListElement { property int group: 9; property int entry: 10 }
        ListElement { property int group: 10; property int entry: 1 }
        ListElement { property int group: 10; property int entry: 2 }
        ListElement { property int group: 10; property int entry: 3 }
        ListElement { property int group: 10; property int entry: 4 }
        ListElement { property int group: 10; property int entry: 5 }
        ListElement { property int group: 10; property int entry: 6 }
        ListElement { property int group: 10; property int entry: 7 }
        ListElement { property int group: 10; property int entry: 8 }
        ListElement { property int group: 10; property int entry: 9 }
        ListElement { property int group: 10; property int entry: 10 }
        ListElement { property int group: 11; property int entry: 1 }
        ListElement { property int group: 11; property int entry: 2 }
        ListElement { property int group: 11; property int entry: 3 }
        ListElement { property int group: 11; property int entry: 4 }
        ListElement { property int group: 11; property int entry: 5 }
        ListElement { property int group: 11; property int entry: 6 }
        ListElement { property int group: 11; property int entry: 7 }
        ListElement { property int group: 11; property int entry: 8 }
        ListElement { property int group: 11; property int entry: 9 }
        ListElement { property int group: 11; property int entry: 10 }
        ListElement { property int group: 12; property int entry: 1 }
        ListElement { property int group: 12; property int entry: 2 }
        ListElement { property int group: 12; property int entry: 3 }
        ListElement { property int group: 12; property int entry: 4 }
        ListElement { property int group: 12; property int entry: 5 }
        ListElement { property int group: 12; property int entry: 6 }
        ListElement { property int group: 12; property int entry: 7 }
        ListElement { property int group: 12; property int entry: 8 }
        ListElement { property int group: 12; property int entry: 9 }
        ListElement { property int group: 12; property int entry: 10 }
        ListElement { property int group: 13; property int entry: 1 }
        ListElement { property int group: 13; property int entry: 2 }
        ListElement { property int group: 13; property int entry: 3 }
        ListElement { property int group: 13; property int entry: 4 }
        ListElement { property int group: 13; property int entry: 5 }
        ListElement { property int group: 13; property int entry: 6 }
        ListElement { property int group: 13; property int entry: 7 }
        ListElement { property int group: 13; property int entry: 8 }
        ListElement { property int group: 13; property int entry: 9 }
        ListElement { property int group: 13; property int entry: 10 }
        ListElement { property int group: 14; property int entry: 1 }
        ListElement { property int group: 14; property int entry: 2 }
        ListElement { property int group: 14; property int entry: 3 }
        ListElement { property int group: 14; property int entry: 4 }
        ListElement { property int group: 14; property int entry: 5 }
        ListElement { property int group: 14; property int entry: 6 }
        ListElement { property int group: 14; property int entry: 7 }
        ListElement { property int group: 14; property int entry: 8 }
        ListElement { property int group: 14; property int entry: 9 }
        ListElement { property int group: 14; property int entry: 10 }
        ListElement { property int group: 15; property int entry: 1 }
        ListElement { property int group: 15; property int entry: 2 }
        ListElement { property int group: 15; property int entry: 3 }
        ListElement { property int group: 15; property int entry: 4 }
        ListElement { property int group: 15; property int entry: 5 }
        ListElement { property int group: 15; property int entry: 6 }
        ListElement { property int group: 15; property int entry: 7 }
        ListElement { property int group: 15; property int entry: 8 }
        ListElement { property int group: 15; property int entry: 9 }
        ListElement { property int group: 15; property int entry: 10 }
    }
}
