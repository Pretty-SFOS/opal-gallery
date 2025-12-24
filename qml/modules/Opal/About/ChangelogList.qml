//@ This file is part of opal-about.
//@ https://github.com/Pretty-SFOS/opal-about
//@ SPDX-FileCopyrightText: 2023 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0

/*!
    \qmltype ChangelogList
    \inqmlmodule Opal.About
    \inherits QtObject
    \brief Provides a container to store a changelog in a separate file.

    Simply define \l ChangelogItem items in chronologically descending order
    (most recent at the top) as children of this component, like so:

    \qml
    import QtQuick 2.0
    import Opal.About 1.0

    ChangelogList {
        ChangelogItem {
            version: "2.0.0-1"
            date: "2023-02-01"
            paragraphs: [
                "...", "..."
            ]
        }
        ChangelogItem {
            version: "1.0.0-1"
            date: "2023-01-01"
            paragraphs: "..."
        }
    }
    \endqml

    \sa ChangelogItem, AboutPageBase::changelogItems, AboutPageBase::changelogList
*/
QtObject {
    id: root

    /*!
      Changelog items are automatically stored in this property.

      It is not necessary to access this property manually.
    */
    default property alias content: root.changelogItems

    /*!
      Changelog items are automatically stored in this property.

      It is not necessary to access this property manually.
    */
    property list<ChangelogItem> changelogItems

    /*!
      This property marks this component as a changelog list.
      \internal
    */
    readonly property int __is_opal_about_changelog_list: 0
}
