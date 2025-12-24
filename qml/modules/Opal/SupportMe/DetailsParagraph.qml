//@ This file is part of opal-supportme.
//@ https://github.com/Pretty-SFOS/opal-supportme
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../LinkHandler" as L

/*!
    \qmltype DetailsParagraph
    \inqmlmodule Opal.SupportMe
    \inherits QtObject
    \brief Show a paragraph in a \l DetailsDrawer.

    Use this component to show a paragraph in a \l DetailsDrawer
    instead of using a plain \c Label.

    This component handles spacing and colors correctly.
    It also allows users to open or copy links in the text.
*/
Label {
    width: parent.width
    color: palette.highlightColor
    wrapMode: Text.Wrap
    linkColor: Theme.secondaryColor
    onLinkActivated: L.LinkHandler.openOrCopyUrl(link)

    /*!
      Your content.

      Use multiple instances for separate paragraphs
      instead of using "\n" for linebreaks.
    */
    text: ""
}
