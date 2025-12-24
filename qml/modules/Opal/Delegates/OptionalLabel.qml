//@ This file is part of opal-delegates.
//@ https://github.com/Pretty-SFOS/opal-delegates
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.5
import Sailfish.Silica 1.0


/*!
    \qmltype OptionalLabel
    \inqmlmodule Opal.Delegates
    \inherits Sailfish.Silica.Label

    \brief A label that hides itself when empty.

    This text label takes up no space when its \c text
    property is empty.

    The label can toggle between a styled one-line view
    that fades overflowing text, and a multi-line view
    that grows in height to fit all text.

    \note eliding will be disabled if the text contains linebreaks (\c {\\n}).

    \sa PaddedDelegate, OneLineDelegate, TwoLineDelegate, ThreeLineDelegate,
        DelegateIconItem, DelegateInfoItem, DelegateColumn
*/
Label {
    id: root

    /*!
      This property defines whether the text is wrapped.

      If this is enabled, the label will grow to fit all text.
      Otherwise, overflowing text will fade out at the end.

      \defaultValue false
    */
    property bool wrapped: false

    Binding on height {
        when: text == ''
        value: 0
    }

    height: implicitHeight
    wrapMode: Text.NoWrap
    truncationMode: TruncationMode.Fade

    states: [
        State {
            name: "wrapped"
            when: root.wrapped || text.indexOf('\n') > -1

            PropertyChanges {
                target: root
                wrapMode: Text.Wrap
                elide: Text.ElideNone
                truncationMode: TruncationMode.None
            }
        }
    ]
}
