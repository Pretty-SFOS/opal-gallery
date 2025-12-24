//@ This file is part of opal-delegates.
//@ https://github.com/Pretty-SFOS/opal-delegates
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Sailfish.Silica 1.0

/*!
    \qmltype DelegateColumn
    \inqmlmodule Opal.Delegates
    \inherits Sailfish.Silica.ListItem

    \brief Item for showing a list of delegates inline.

    When showing multiple lists of delegates on the same
    page, it is often cumbersome to use \c SilicaListView.

    Instead, you can usually use \l {Sailfish::Silica::ColumnView}.

    However, Silica's \c ColumnView breaks when delegates
    have dynamic sizes. In that case, you can use this component.

    \section2 Example

    \qml
    import QtQuick 2.0
    import Sailfish.Silica 1.0
    import Opal.Delegates 1.0

    DelegateColumn {
        model: ListModel {
            ListElement { post: "Hello there" }
            ListElement { post: "Goodbye again" }
        }
        delegate: D.OneLineDelegate {
            text: post
        }
    }
    \endqml

    \section2 Considerations

    If your delegates are guaranteed to be the same
    sized when rendered, you should preferably use Silica's
    \c ColumnView instead.

    \c ColumnView has better performance for
    long lists, but it cuts your view off at the bottom if
    your delegates have different sizes.

    \sa Repeater, {Sailfish.Silica.ColumnView}
*/
Column {
    id: root
    width: parent.width

    /*!
      This property holds the model containing your data.

      See the documentation of \l Repeater for details on
      how the model can be defined.

      \sa Repeater
    */
    property alias model: repeater.model

    /*!
      This property holds the delegate to be used.

      \sa Repeater
    */
    property alias delegate: repeater.delegate

    Repeater {
        id: repeater
    }
}
