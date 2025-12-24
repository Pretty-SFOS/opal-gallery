//@ This file is part of opal-about.
//@ https://github.com/Pretty-SFOS/opal-about
//@ SPDX-FileCopyrightText: 2021-2022 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import "private/functions.js" as Func

/*!
    \qmltype Attribution
    \inqmlmodule Opal.About
    \inherits QtObject
    \brief Provides the definition of an attribution.

    \note if neither licenses nor entries are defined through
    \l licenses and \l entries, a "thank you!" entry will be
    shown on the contributors page using the \l name property.

    \sa AboutPageBase::attributions, AboutPageBase::contributionSections, AboutPageBase::authors
*/
QtObject {
    /*!
      This property holds the name of the attributed entity.

      If this attribution is for a third-party library, this should
      be the library's name.

      \required
    */
    property string name

    /*!
      This property holds a list of texts linked to this attribution.

      \b Example: if this is an attribution for a third-party library,
      this list should contain the copyright holders as required
      by the library's license.

      It is possible to assign a single string value instead of a list
      to this property.

      \qml
        entries: "2021 Jane Doe"
        // or:
        entries: ["2021 Jane Doe", "2020 John Doe"]
      \endqml
    */
    property var entries: []

    /*!
      This property holds a list of licenses relevant to this attribution.

      \sa License
    */
    property list<License> licenses

    /*!
      This property may hold an additional description of the attribution.

      When attributing a third-party library, it may be desired to explain how
      exactly the library is used.

      When publishing a derived project, simply adding the name of the "parent"
      project is not enough. A short explanation is polite and will help users
      understand the origins of the new project.

      \note this description is only included on the license page. Sometimes,
      a \c InfoSection is better suited to display acknowledgments on the main
      page instead of / in addition to the license page.

      \sa InfoSection, InfoButton, InfoSection::smallPrint, AboutPageBase::openOrCopyUrl
    */
    property string description

    /*!
      This property may hold an URL to a relevant homepage.

      When attributing a third-party library, it is common courtesy to provide
      the link to its homepage. Some licenses may require it.
    */
    property string homepage

    /*!
      This property may hold an URL to relevant source code.

      When attributing a third-party library, it may be helpful for end users
      when a link to its source code is provided. Some licenses may require it.
    */
    property string sources

    property var __effectiveEntries: Func.makeStringList(entries, false)
    property var _spdxList: null

    function _getSpdxList(force) {
        var upd = Func.updateSpdxList(licenses, _spdxList, force)
        if (upd !== null) {
            _spdxList = upd.spdx
        }
        return _spdxList
    }

    function _getSpdxString(append, force) {
        var str = _getSpdxList(force).join(', ')
        if (str !== '' && append) str = str + ' ' + append
        return str
    }
}
