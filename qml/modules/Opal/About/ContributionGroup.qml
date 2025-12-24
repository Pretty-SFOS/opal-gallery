//@ This file is part of opal-about.
//@ https://github.com/Pretty-SFOS/opal-about
//@ SPDX-FileCopyrightText: 2020-2021 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import "private/functions.js" as Func

/*!
    \qmltype ContributionGroup
    \inqmlmodule Opal.About
    \inherits QtObject
    \brief Provides the definition of a group of contributors.

    Contribution groups are used as part of contribution sections
    (\l ContributionSection) and will be shown on the contributors page.

    Empty groups will be hidden.

    \qml
       ContributionSection {
           title: qsTr("Translations")
           groups: [
               ContributionGroup {
                   title: qsTr("English")
                   entries: "Some Body"
               },
               ContributionGroup {
                   title: qsTr("German")
                   entries: "Max Mustermann"
               }
           ]
       }
    \endqml

    \sa ContributionSection, AboutPageBase::contributionSections
*/
QtObject {
    /*!
      This property holds the title of the group.

      The title is treated as a sub-title below the section title.
      This property is not strictly required but it is recommended
      to set a title.
    */
    property string title

    /*!
      This property holds the entries of this group.

      This should be a list of the names of people who contributed
      in this group.

      It is possible to assign a single string value instead of a list
      to this property.
    */
    property var entries: []

    /*!
      This property holds a cleaned list of entries.
      \internal
    */
    property var __effectiveEntries: Func.makeStringList(entries)
}
