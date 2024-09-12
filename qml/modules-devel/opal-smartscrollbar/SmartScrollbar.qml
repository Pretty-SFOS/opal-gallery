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
    \brief A configurable scroll bar for random access in long list views.

    This module can be used instead of Silica's \c VerticalScrollDecorator.
    It provides an interface for Silica's private scrollbar and falls back
    to the standard \c VerticalScrollDecorator if the private API is not
    available.

    The scrollbar can show two lines of information, and most importantly,
    it allows scrolling to any position in the list view. The
    default \c VerticalScrollDecorator only allows scrolling quickly to
    the top or the bottom.

    \section2 Example

    \qml
    import QtQuick 2.0
    import Sailfish.Silica 1.0
    import Opal.SmartScrollbar 1.0

    Page {
        id: root
        allowedOrientations: Orientation.All

        SilicaListView {
            id: flick
            anchors.fill: parent

            SmartScrollbar {
                flickable: flick
                text: "..."
            }

            model: [1, 2, 3]

            delegate: ListItem {
                contentHeight: Theme.itemSizeSmall

                Label {
                    width: parent.width - 2*x
                    x: Theme.horizontalPageMargin
                    text: modelData
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
    \endqml

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
*/
QtObject {
    id: root

    /*!
      This property holds the flickable associated with the scrollbar.

      Set this to the \c SilicaListView or \c SilicaFlickable that
      should be scrolled.

      \required
    */
    property Flickable flickable: null

    /*!
      This property holds the first line of text.

      The scrollbar can optionally show up to two lines of
      text. You can use this to show detailed info about the
      current scrolling position.

      See \l {Accessing list elements} for how to access the
      current index and element properties of a list view.

      \sa description
    */
    property string text

    /*!
      This property holds the second line of text.

      The scrollbar can optionally show up to two lines of
      text. You can use this to show detailed info about the
      current scrolling position.

      See \l {Accessing list elements} for how to access the
      current index and element properties of a list view.

      \sa text
    */
    property string description

    /*!
      This property defines when the smart scrollbar is enabled.

      If this is set to \c false, the standard \c VerticalScrollDecorator
      will be enabled instead of the smart scrollbar. This can be
      useful in shorter lists where it is not necessary to have random
      access.

      \defaultValue true
    */
    property bool smartWhen: true

    /*!
      This property defines when quick scrolling is enabled.

      If this is set to \c false, the standard quick scrolling
      helper that allows to quickly jump to the beginning or end
      of a list view is disabled.

      This can be useful in shorter lists where it is annoying
      to always have the quick scrolling helper show up, even
      though it would be easy to flick to the view to the bottom.

      \defaultValue true
    */
    property bool quickScrollWhen: true

    /*!
      This property indicates whether the smart scrollbar is enabled.

      This value will be \c true when the smart scrollbar is unavailable,
      or when \l smartWhen is set to \c false.
    */
    readonly property bool usingFallback: _fallback.visible

    /*!
      This function reloads the smart scrollbar component.

      It is usually not necessary to call this function manually.
    */
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
