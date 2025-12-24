//@ This file is part of opal-infocombo.
//@ https://github.com/Pretty-SFOS/opal-infocombo
//@ SPDX-FileCopyrightText: 2023 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0

/*!
    \qmltype InfoComboSection
    \inqmlmodule Opal.InfoCombo
    \inherits QtObject
    \brief Provides an extra section on the info page.

    Use this component to include extra sections on a
    \l InfoCombo info page. The \l placeAtTop property
    declares where the section will be placed.

    \sa InfoCombo
*/
QtObject {
    /*!
      This property holds the title of the info section.

      There will be some vertical space if this is left empty.
    */
    property string title

    /*!
      This property holds the contents of the info section.

      \required
    */
    property string text

    /*!
      This property defines where the section will be placed.

      If set to \c true, the section will be placed at the top of
      the info page before any option descriptions. Otherwise
      it will be placed at the end of the page after all options.
    */
    property bool placeAtTop: true

    /*!
      This property marks this component as a info combo section.
      \internal
    */
    readonly property int __is_info_combo_section: 0
}
