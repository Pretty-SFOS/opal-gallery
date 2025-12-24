//@ This file is part of opal-combodata.
//@ https://github.com/Pretty-SFOS/opal-combodata
//@ SPDX-FileCopyrightText: 2023-2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Sailfish.Silica 1.0

/*!
    \qmltype ComboData
    \inqmlmodule Opal.ComboData
    \inherits Item
    \brief Provides an extension for accessing combo box values.

    Sailfish Silica's \c ComboBox combo boxes expose three values: current index,
    current item, and value. The \c value property actually holds the current
    item's \c text value.

    An item's label and actual value are often not the same, though. This extension
    allows to define a custom property that is exposed as \l currentData.

    The helper function \l indexOfData determines the index of a given data
    value. This can then be used to change the combo box's current index.

    \section2 Exposing current data

    If you want to access the current data from outside of the combo box, you
    have to expose the property. Simply declare a new property \c currentData in
    your \c ComboBox. \c ComboData will now make sure that this property is
    bound to the data property of the currently selected menu item.

    Example: the \c value property of the currently selected item can be
    accessed through \c currentData property of the \c ComboBox, which is
    automatically bound by \l ComboData to \l currentData.

    \qml
    import QtQuick 2.0
    import Sailfish.Silica 1.0
    import Opal.ComboData 1.0

    ComboBox {
        label: qsTr("Fruit")

        property string currentData  // expose ComboData.currentData - remove if not needed
        property var indexOfData  // expose ComboData.indexOfData - remove if not needed
        ComboData { dataRole: "value" }

        menu: ContextMenu {
            MenuItem {
                property string value: "fruit-1"
                text: qsTr("Banana")
            }
            MenuItem {
                property string value: "fruit-2"
                text: qsTr("Kiwi")
            }
            MenuItem {
                property string value: "fruit-3"
                text: qsTr("Pear")
            }
        }
    }
    \endqml

    The \c indexOfData property of the \c ComboBox is automatically set by
    \l ComboData to the helper function \l indexOfData. Calling this function
    like \c {indexOfData("fruit-2")} will return \c 1, the index of the
    corresponding combo box entry.

    Use \l indexOfData to change the current index, e.g. after reading the value
    from a configuration file:

    \qml
    ComboBox {
        // ...

        Component.onCompleted: {
            currentIndex = indexOfData(myConfigValue)
        }
    }
    \endqml

    \section2 Without exposing properties

    Sometimes values are only used inside of the \c ComboBox. In that case, it
    is unnecessary to expose \l currentData and \l indexOfData. Instead, create
    a property \c cdata. This property is then automatically bound to the
    \c ComboData instance of your \c ComboBox.

    Example: the currently selected fruit is loaded from and written to
    \c myConfig.

    \qml
    import QtQuick 2.0
    import Sailfish.Silica 1.0
    import Nemo.Configuration 1.0
    import Opal.ComboData 1.0

    Page {
        id: root

        ConfigurationValue {
            id: myConfig
            key: "/apps/my-app/my-key"
            defaultValue: "fruit-2"
        }

        ComboBox {
            label: qsTr("Fruit")
            property ComboData cdata
            ComboData { dataRole: "value" }
            onValueChanged: myConfig.activeFruit = cdata.currentData
            Component.onCompleted: cdata.reset(myConfig.activeFruit)

            menu: ContextMenu {
                MenuItem {
                    property string value: "fruit-1"
                    text: qsTr("Banana")
                }
                MenuItem {
                    property string value: "fruit-2"
                    text: qsTr("Kiwi")
                }
                MenuItem {
                    property string value: "fruit-3"
                    text: qsTr("Pear")
                }
            }
        }
    }
    \endqml
*/

Item {
    id: root

    /*!
      This property holds the associated \c ComboBox.

      By default, it is automatically set to the parent of the combo data instance.
      You can manually define any \c ComboBox or derived type to associate the
      \l ComboData instance with that \c ComboBox.
    */
    property var comboBox: !!parent && !!parent.parent ?
        parent.parent : null  // grandparent because Silica::ComboBox puts
                              // its children in a container

    /*!
      This property holds the name of the exposed data property.

      Set this to a custom property that is available on all menu items.

      If unchanged, the default value \c "text" exposes the same value as the
      \c value property of a \c ComboBox.
    */
    property string dataRole: "text"

    /*!
      This property exposes the currently selected item's value.

      It is bound to the \c currentItem property of the \l comboBox. The value
      is \c null if no item is selected.
    */
    readonly property var currentData: !!_currentItem ?
        _currentItem[dataRole] : null

    /*!
      This function returns the index of the first menu item matching \a data.

      It returns \c -1 if no matching item was found.
    */
    function indexOfData(data) {
        if (!_menu) {
            return -1
        }

        var children = _menu._contentColumn.children
        var menuIndex = -1

        for (var i in children) {
            var child = children[i]

            if (!!child && child.hasOwnProperty("__silica_menuitem")) {
                menuIndex += 1

                if (child[dataRole] === data) {
                    return menuIndex
                }
            }
        }

        return -1
    }

    /*!
      This function is a shorthand helper to reset the current index.

      The current index is set to the first menu item matching \a data, or \c -1
      if not matching item was found. You can use this function without exposing
      \c indexOfData.
    */
    function reset(data) {
        if (!_menu || !comboBox) {
            console.error('[Opal.ComboData] Cannot reset current index because ' +
                          'no menu or ComboBox is available.')
            return
        }

        comboBox.currentIndex = indexOfData(data)
    }

    readonly property var _menu: !!comboBox ? comboBox.menu : null
    readonly property var _currentItem: !!comboBox &&
        !!comboBox.currentItem ? comboBox.currentItem : null

    function _checkCombo() {
        if (!comboBox || !comboBox.hasOwnProperty('menu') ||
                !comboBox.hasOwnProperty('currentItem')) {
            console.error(
                        '[Opal.ComboData] ComboData must be a direct child ' +
                        'of a ComboBox (or derived type), or you must set the ' +
                        '“comboBox” property to a valid value.')
            console.log(comboBox, comboBox.parent.parent)
            return
        }

        if (comboBox.hasOwnProperty('currentData')) {
            comboBox.currentData = Qt.binding(function() {
                return currentData
            })
        }

        if (comboBox.hasOwnProperty('indexOfData')) {
            comboBox.indexOfData = Qt.binding(function() {
                return indexOfData
            })
        }

        if (comboBox.hasOwnProperty('cdata')) {
            comboBox.cdata = root
        }
    }

    onComboBoxChanged: _checkCombo()
    onParentChanged: _checkCombo()
    Component.onCompleted: _checkCombo()
}
