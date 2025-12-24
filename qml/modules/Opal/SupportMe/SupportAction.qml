//@ This file is part of opal-supportme.
//@ https://github.com/Pretty-SFOS/opal-supportme
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../LinkHandler" as L

/*!
    \qmltype SupportAction
    \inqmlmodule Opal.SupportMe
    \inherits QtObject
    \brief Describe a way to support you.

    This item is used to show a way to support you
    or your project.

    Example:

    \qml
    SupportAction {
        icon: SupportIcon.Liberapay
        title: qsTr("Donate on Liberapay")
        description: qsTr("Pay the amount of a cup of coffee, a slice " +
                          "of pizza, or a ticket to the theater.")
        link: "https://liberapay.com/ichthyosaurus"
    }
    \endqml

    Some common icons are provided in the \l SupportIcon enum.
    You can also use custom icons (size: 112x112px).

    \sa AskForSupport, SupportDialog, DetailsDrawer
*/
BackgroundItem {
    id: root
    width: parent.width
    height: _body.height + 2*Theme.paddingMedium

    /*!
      Url of the icon for this action.

      Some common icons are provided in the \l SupportIcon
      enum. Custom icons must be 112x112px in size.
    */
    property url icon

    /*!
      This property holds the title.

      The title should be in active voice and be a call to
      action. For example "Donate on MyService", instead of
      simply "Donations".
    */
    property string title

    /*!
      This property holds a description of the action.

      Describe in a few words how users can contribute using
      this method. What tasks can be tackled? How much money
      do you need? etc.
    */
    property string description

    /*!
      This property holds an optional link to a website.

      The item will be clickable if you provide a link.
      Users can then follow the link for details or to
      contribute directly.

      If no link is provided, the item will appear as a
      paragraph with appropriate non-interactive styling.
    */
    property url link

    readonly property Item bodyItem: _body
    readonly property HighlightImage iconItem: _iconItem
    readonly property Label titleLabel: _titleLabel
    readonly property Label descriptionLabel: _descriptionLabel

    readonly property bool __isLink: link != ""

    Binding on palette.primaryColor {
        when: !__isLink
        value: palette.highlightColor
    }

    Binding on highlightedColor {
        when: !__isLink
        value: "transparent"
    }

    onClicked: {
        if (__isLink) {
            L.LinkHandler.openOrCopyUrl(link)
        }
    }

    Item {
        id: _body
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        height: childrenRect.height
        anchors.verticalCenter: parent.verticalCenter

        HighlightImage {
            id: _iconItem
            anchors {
                left: parent.left
                top: parent.top
            }

            Binding on highlighted {
                when: !__isLink
                value: false
            }

            source: root.icon
            width: 112
            height: width
        }

        Label {
            id: _titleLabel
            anchors {
                left: iconItem.right
                leftMargin: Theme.paddingLarge
                right: parent.right
                top: parent.top
            }
            font.pixelSize: Theme.fontSizeLarge
            wrapMode: Text.Wrap
            text: root.title
        }

        Label {
            id: _descriptionLabel
            anchors {
                left: _titleLabel.left
                right: _titleLabel.right
                top: _titleLabel.bottom
                topMargin: Theme.paddingSmall
            }
            font.pixelSize: Theme.fontSizeExtraSmall
            wrapMode: Text.Wrap
            text: root.description
        }
    }
}
