//@ This file is part of Opal.Tabs for use in harbour-opal-gallery.
//@ https://github.com/Pretty-SFOS/opal-tabs
//@ SPDX-License-Identifier: GPL-3.0-or-later
//@ SPDX-FileCopyrightText: 2023-2024 Mirian Margiani

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import Opal.Tabs 1.0 as T
import "gallery"

S.Page {
    id: root
    allowedOrientations: S.Orientation.All

    property bool enableIcons: false
    property bool enableDescriptions: false
    property alias tabBarPosition: tabs.tabBarPosition
    property alias tabBarVisible: tabs.tabBarVisible

    T.TabView {
        id: tabs
        anchors.fill: parent
        currentIndex: 1
        tabBarPosition: Qt.AlignTop

        T.Tab {
            title: qsTranslate("Opal.Tabs", "Chats")
            icon: enableIcons ? "image://theme/icon-m-repeat" : ""
            description: enableDescriptions ?
                qsTranslate("Opal.Tabs", "7 unread") : ""

            Component { DummyTab {} }
        }

        T.Tab {
            title: qsTranslate("Opal.Tabs", "Overview")
            icon: enableIcons ? "image://theme/icon-m-acknowledge" : ""
            description: enableDescriptions ?
                qsTranslate("Opal.Tabs", "Nothing to do") : ""

            Component {
                OptionsTab {
                    page: root
                }
            }
        }

        T.Tab {
            title: qsTranslate("Opal.Tabs", "Tasks")
            icon: enableIcons ? "image://theme/icon-m-company" : ""
            description: enableDescriptions ?
                qsTranslate("Opal.Tabs", "59 open") : ""

            Component { DummyTab {} }
        }
    }
}
