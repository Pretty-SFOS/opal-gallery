//@ This file is part of opal-smartscrollbar.
//@ https://github.com/Pretty-SFOS/opal-smartscrollbar
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.6
import Sailfish.Silica 1.0

/*!
    \qmltype SmartScrollbar
    \inqmlmodule Opal.SmartScrollbar
    \inherits QtObject
    \brief TODO

    TODO

    \section2 Accessing list elements

    Use this code to show the current index and data of the current
    list element in your scrollbar:

    \qml
    SmartScrollbar {
        flickable: myFlickable

        readonly property var scrollItem: !!flickable ?
            flickable.itemAt(flickable.contentX, flickable.contentY) : null
        readonly property int scrollIndex: !!flickable ?
            flickable.indexAt(flickable.contentX, flickable.contentY) : -1

        text: "%1 / %2".arg(scrollIndex + 2).arg(flickable.count)
        description: !!scrollItem ? scrollItem.myProperty : ""
    }
    \endqml

    However, remember that the \c scrollItem and \c scrollIndex
    properties incur a performance cost that can make scrolling feel
    slow, sluggish or erratic. This depends on your list.

    \section2 Example

    \qml
    TODO
    \endqml
*/
QtObject {
    id: root

    property Flickable flickable: null
    property string text
    property string description

    property bool smartWhen: true
    property bool quickScrollWhen: true

    readonly property bool usingFallback: _fallback.visible

    function reload() {
        try {
            _scrollbar = Qt.createQmlObject("
                import QtQuick 2.0
                import %1 1.0 as Private
                Private.Scrollbar {
                    visible: root.smartWhen
                    enabled: visible
                    text: root.text
                    description: root.description
                    headerHeight: root._headerHeight
                }".arg("Sailfish.Silica.private"), flickable, 'SmartScrollbar')
        } catch (e) {
            if (!_scrollbar) {
                console.warn(e)
                console.warn('[BUG] failed to load smart scrollbar')
                console.warn('[BUG] this probably means the private API has changed')
            }
        }
    }

    property int _headerHeight: !!flickable && flickable.headerItem ?
                                    flickable.headerItem.height : 0

    property VerticalScrollDecorator _fallback: VerticalScrollDecorator {
        parent: root.flickable
        flickable: root.flickable
        visible: !root._scrollbar || !root.smartWhen
    }

    property Item _scrollbar: null

    property Binding __quickScroll: Binding {
        target: flickable
        property: "quickScroll"
        value: false
        when: !quickScrollWhen
    }

    Component.onCompleted: {
        reload()
    }
}
