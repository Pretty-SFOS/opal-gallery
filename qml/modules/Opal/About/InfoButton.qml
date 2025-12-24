//@ This file is part of opal-about.
//@ https://github.com/Pretty-SFOS/opal-about
//@ SPDX-FileCopyrightText: 2021 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0

/*!
    \qmltype InfoButton
    \inqmlmodule Opal.About
    \inherits QtObject
    \brief Defines a button for an info section.

    Info sections (defined through the \l AboutPageBase::extraSections property)
    can show one or multiple buttons below their text.

    \qml
    extraSections: InfoSection {
        title: qsTr("Data")
        text: qsTr("Lorem ipsum dolor sit amet et cetera ad libitum plurum sid alum.")
        buttons: InfoButton {
            text: qsTr("Terms of Use")
            onClicked: page.openOrCopyUrl("https://example.org")
        }
    }
    \endqml

    \sa InfoSection, AboutPageBase::extraSections, AboutPageBase::openOrCopyUrl
*/
QtObject {
    /*!
      This property holds the text shown on the button.

      Buttons without text will be hidden.

      \required
    */
    property string text: ""

    /*!
      This property holds whether the button is enabled.

      Disabled buttons will be hidden.
    */
    property bool enabled: true

    /*!
      This signal is emitted when the button is clicked.

      The corresponding handler is \c onClicked.

      \sa AboutPageBase::openOrCopyUrl, Qt::openUrlExternally
    */
    signal clicked
}
