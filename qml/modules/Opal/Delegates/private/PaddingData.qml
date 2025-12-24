//@ This file is part of opal-delegates.
//@ https://github.com/Pretty-SFOS/opal-delegates
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0

/*!
    \qmltype PaddingData
    \inqmlmodule Opal.Delegates
    \inherits QtObject

    \brief Item for defining delegate padding.

    This group defines the padding for \l PaddedDelegate
    delgates.

    \section2 Anatomy

    \code
    +----------------------------------------------------------+
    |                        top padding                       |
    |         +--------------------------------------+         |
    | left    |               delegate               | right   |
    | padding |               contents               | padding |
    |         +--------------------------------------+         |
    |                      bottom padding                      |
    +----------------------------------------------------------+
    \endcode

    \section2 Priorities

    Note that more specific values have higher priority than less
    specific values. In other words: by defining \l all and \l top
    you can set left, right, and bottom to the value of \l all, while
    top gets the value of \l top.

    The same goes for \l leftRight and \l rightLeft, which have higher
    priority than \l all but lower priority than the four sides.

    \sa PaddedDelegate, OneLineDelegate, TwoLineDelegate, ThreeLineDelegate,
        DelegateIconItem, DelegateInfoItem, DelegateColumn
*/
QtObject {
    /*!
      This property defines the value that is interpreted as “unset”.

      It appears that Qt is converting Infinity to a valid integer, and
      NaN to 0, so those values cannot be used directly as special values.
      It is safe to assume that this number is never used as a valid value,
      however.

      \internal
    */
    property int _undefinedValue: -9999

    /*!
      This property sets values for all four sides.

      Priority: lowest

      \defaultValue 0
    */
    property int all: _undefinedValue

    /*!
      This property sets values for left and right.

      Priority: medium

      \defaultValue Theme.horizontalPageMargin
    */
    property int leftRight: _undefinedValue  // default value is assigned in PaddedDelegate

    /*!
      This property sets values for top and bottom.

      Priority: medium

      \defaultValue Theme.paddingSmall
    */
    property int topBottom: _undefinedValue  // default value is assigned in PaddedDelegate

    /*!
      This property sets the top padding.

      Priority: highest

      \defaultValue 0
    */
    property int top: _undefinedValue

    /*!
      This property sets the bottom padding.

      Priority: highest

      \defaultValue 0
    */
    property int bottom: _undefinedValue

    /*!
      This property sets the left padding.

      Priority: highest

      \defaultValue 0
    */
    property int left: _undefinedValue

    /*!
      This property sets the right padding.

      Priority: highest

      \defaultValue 0
    */
    property int right: _undefinedValue

    /*!
      This property shows the effective top padding.

      This takes the values of \l all and \l topBottom in account.
    */
    readonly property int effectiveTop: top !== _undefinedValue ? top : _topBottom

    /*!
      This property shows the effective bottom padding.

      This takes the values of \l all and \l topBottom in account.
    */
    readonly property int effectiveBottom: bottom !== _undefinedValue ? bottom : _topBottom

    /*!
      This property shows the effective left padding.

      This takes the values of \l all and \l leftRight in account.
    */
    readonly property int effectiveLeft: left !== _undefinedValue ? left : _leftRight

    /*!
      This property shows the effective left padding.

      This takes the values of \l all and \l leftRight in account.
    */
    readonly property int effectiveRight: right !== _undefinedValue ? right : _leftRight

    // internal
    readonly property int _all: all !== _undefinedValue ? all : 0

    // internal
    readonly property int _topBottom: topBottom !== _undefinedValue ? topBottom : _all

    // internal
    readonly property int _leftRight: leftRight !== _undefinedValue ? leftRight : _all
}
