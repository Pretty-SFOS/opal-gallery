//@ This file is part of opal-delegates.
//@ https://github.com/Pretty-SFOS/opal-delegates
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Sailfish.Silica 1.0

/*!
    \qmltype DelegateIconItem
    \inqmlmodule Opal.Delegates
    \inherits Sailfish.Silica.HighlightImage

    \brief Item for adding an icon to a delegate.

    This item can be used to add an icon as a delegate's
    \l {PaddedDelegate::leftItem} or \l {PaddedDelegate::rightItem}.

    The default size is \c {Theme.iconSizeMedium}. Change the
    size by changing the \c width property. The height is
    set to be the same as the width.

    Example:

    \qml
    OneLineDelegate {
        text: "My favourite"
        interactive: false

        leftItem: DelegateIconItem {
            source: "image://theme/icon-m-favorite"
        }
    }
    \endqml

    \sa PaddedDelegate, DelegateInfoItem
*/
HighlightImage {
    width: Theme.iconSizeMedium
    height: width
    fillMode: Image.PreserveAspectFit
    color: Theme.primaryColor
    highlighted: parent.highlighted
}
