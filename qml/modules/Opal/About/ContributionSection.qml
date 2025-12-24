//@ This file is part of opal-about.
//@ https://github.com/Pretty-SFOS/opal-about
//@ SPDX-FileCopyrightText: 2020-2021 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0

/*!
    \qmltype ContributionSection
    \inqmlmodule Opal.About
    \inherits QtObject
    \brief Provides the definition of a section of groups of contributors.

    Contribution sections hold groups of contributors to be shown
    on the contributors page.

    Empty sections will be hidden.

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

    \sa AboutPageBase::contributionSections
*/
QtObject {
    /*!
      This property holds the title of the section.

      This property is not strictly required but it is recommended
      to set a title.

      If the title of the very first contribution section is
      "Development" (may be translated), it will be merged with
      the automatically created group of main contributors.

      \required
      \sa AboutPageBase::mainAttributions
    */
    property string title

    /*!
      This property holds the entries of this section.

      \sa ContributionGroup
    */
    property list<ContributionGroup> groups
}
