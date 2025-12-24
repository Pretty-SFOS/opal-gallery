//@ This file is part of opal-infocombo.
//@ https://github.com/Pretty-SFOS/opal-infocombo
//@ SPDX-FileCopyrightText: 2023-2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.2
import Sailfish.Silica 1.0

/*!
    \qmltype InfoCombo
    \inqmlmodule Opal.InfoCombo
    \inherits ComboBox
    \brief Provides a combo box that can show detailed descriptions of all menu items.

    Use this component when you have to give users extensive
    descriptions of the choices in a combo box or if you need more
    space for the description of a combo box's function.

    \section2 Usage

    Define the combo box like any other \l ComboBox, then add a “info”
    string property on the menu items that should have descriptions.

    Use \l InfoComboSection items to add further sections that do not
    belong to a specific menu item.

    You can use the \l InfoMenuItem shorthand if you do not want to
    add the “info” property manually.

    \section2 Example

    \qml
    InfoCombo {
        width: parent.width
        label: "Food preference"

        InfoComboSection {
            placeAtTop: true
            title: "Food types"
            text: "We provide different kinds of food."
        }

        menu: ContextMenu {
            MenuItem {
                text: "Vegetarian"
                property string info: "Vegetarian food does not have any meat."
            }
            MenuItem {
                text: "Vegan"
                property string info: "Vegan food is completely plant-based."
            }
        }

        InfoComboSection {
            placeAtTop: false
            title: "What about meat?"
            text: "We don't provide any meat."
        }
    }
    \endqml
*/
ComboBox {
    id: root

    /*!
      Disable this to forbid changing the current index from the info page.

      This setting is enabled by default, unless \c enabled is set to \c false.
    */
    property bool allowChanges: true
    readonly property bool _proxyChangesAllowed: allowChanges && enabled

    /*!
      This property defines a function that will be called when a link is activated.

      Links in the form of \c {<a href="example.org">Example</a>} will be opened
      externally by default, using \c {Qt.openUrlExternally}.

      \note Links are only supported in custom sections. Entry descriptions
      cannot contain links.

      The handler function takes the URL to be opened as its only argument (\a link).
    */
    property var linkHandler: function(link) {
        Qt.openUrlExternally(link)
    }

    /*!
      This property holds a reference to the info button.

      It is possible to customize the icon or other properties
      of the info button through this property.
    */
    readonly property IconButton infoButton: button

    /*!
      This signal is emitted when a link in a text is clicked.

      Links are handled by \l linkHandler, which opens them
      externally by default. This behavior can be changed by
      assigning \c null to \l linkHandler, or by implementing
      a custom handler.

      \note Links are only supported in custom sections. Entry descriptions
      cannot contain links.

      \sa linkHandler
    */
    signal linkActivated(var link)

    rightMargin: Theme.horizontalPageMargin + Theme.iconSizeMedium
    onLinkActivated: !!linkHandler && linkHandler(link)

    IconButton {
        id: button
        enabled: root.enabled
        anchors.right: parent.right
        icon.source: "image://theme/icon-m-about"

        Binding on highlighted {
            when: root.highlighted
            value: true
        }

        onClicked: {
            var top = []
            var bottom = []
            var items = []

            for (var i in root.children) {
                var sec = root.children[i]

                if (sec.hasOwnProperty('__is_info_combo_section')) {
                    if (sec.placeAtTop) {
                        top.push(sec)
                    } else {
                        bottom.push(sec)
                    }
                }
            }

            if (root.menu) {
                for (var j in menu._contentColumn.children) {
                    var item = menu._contentColumn.children[j]

                    if (item && item.visible &&
                            item.hasOwnProperty("__silica_menuitem") &&
                            item.hasOwnProperty("info")) {
                        items.push({
                            title: item.text,
                            text: item.info,
                            isOption: true
                        })
                    }
                }
            }

            var page = pageStack.push(Qt.resolvedUrl("private/InfoComboPage.qml"), {
                title: root.label,
                topNotes: top, bottomNotes: bottom, items: items,
                allowChanges: _proxyChangesAllowed,
                comboBox: root
            })
            page.linkActivated.connect(linkActivated)
        }
    }
}
