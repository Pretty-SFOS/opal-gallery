//@ This file is part of opal-menuswitch.
//@ https://github.com/Pretty-SFOS/opal-menuswitch
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.6
import Sailfish.Silica 1.0 as S

/*!
    \qmltype MenuSwitch
    \inqmlmodule Opal.MenuSwitch
    \inherits Sailfish.Silica::MenuItem, Sailfish.Silica::TextSwitch
    \brief Provides a toggle button to be used in menus.

    This menu item combines Silica's \l Sailfish.Silica::MenuItem
    with \l Sailfish.Silica::TextSwitch to show a toggleable
    option in a menu.

    Example:

    \qml
    ContextMenu {
        MenuSwitch {
            text: "Option 1"
            checked: true
        }
        MenuSwitch {
            text: "Option 2"
        }
    }
    \endqml
*/
S.MenuItem {
    id: root

    /*!
      From Silica's \c TextSwitch documentation:

      \quotation
      If \c true, the \c TextSwitch is automatically toggled between the checked
      and unchecked states when clicked. The default value is \c true.

      If \l automaticCheck is \c false, the user must handle the \c clicked()
      signal and set the value of \l checked appropriately. This is primarily
      useful when the switch is connected to an external state that cannot be
      simply bound to the \l checked property.
      \endquotation

      \sa checked
    */
    property alias automaticCheck: toggle.automaticCheck

    /*!
      From Silica's \c TextSwitch documentation:

      \quotation
      This property holds whether the \c TextSwitch is checked.
      If \l automaticCheck is \c true, clicking on the switch toggles checked between
      \c true and \c false.
      \endquotation

      \sa automaticCheck
    */
    property alias checked: toggle.checked

    /*!
      From Silica's \c TextSwitch documentation:

      \quotation
      This property holds whether the \c TextSwitch is in a busy state. When busy the
      indicator will flash and the \c TextSwitch will be disabled. The busy state is
      useful when applying a change to a setting does not happen instantaneously.
      \endquotation
    */
    property alias busy: toggle.busy

    /*!
      This property gives direct access to the underlying \c TextSwitch.

      It is usually not necessary to access this property.
    */
    readonly property alias switchItem: toggle

    Binding on enabled {
        when: busy
        value: false
    }

    Binding on color {
        when: busy
        value: _enabledColor
    }

    S.TextSwitch {
        id: toggle
        checked: false
        automaticCheck: true
        text: ""
        highlighted: parent.highlighted
        height: S.Theme.itemSizeSmall
        width: S.Theme.iconSizeMedium + S.Theme.paddingSmall
        anchors.verticalCenter: parent.verticalCenter
    }

    TextMetrics {
        id: metrics
        font: root.font
        text: root.text
    }

    text: ""

    property int __marginsWidth: (root.width - metrics.width) / 2
    leftPadding: __marginsWidth >= toggle.width ? 0 :
          toggle.width
        + S.Theme.paddingLarge
        - (Math.max(root.width - metrics.width,
                    1.5*S.Theme.paddingLarge) / 2)
    onClicked: {
        toggle.clicked(null)
    }
}
