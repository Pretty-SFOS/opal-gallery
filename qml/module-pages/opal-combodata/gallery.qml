/*
 * This file is part of harbour-opal.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2023-2024 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import Opal.ComboData 1.0 as C

import Opal.InfoCombo 1.0 as I

S.Page {
    id: root
    allowedOrientations: S.Orientation.All

    S.SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        S.VerticalScrollDecorator {}

        Column {
            id: column
            width: parent.width
            spacing: S.Theme.paddingMedium

            S.PageHeader {
                title: "Values and labels"
            }

            S.SectionHeader {
                text: "Simple usage"
            }

            S.ComboBox {
                id: fruitCombo
                label: qsTranslate("Opal.ComboData", "Fruit")

                property string currentData  // expose ComboData.currentData - remove if not needed
                // property var indexOfData  // we don't need indexOfData in this example
                C.ComboData { dataRole: "value" }

                menu: S.ContextMenu {
                    S.MenuItem {
                        property string value: "fruit-1"
                        text: qsTranslate("Opal.ComboData", "Banana")
                    }
                    S.MenuItem {
                        property string value: "fruit-2"
                        text: qsTranslate("Opal.ComboData", "Kiwi")
                    }
                    S.MenuItem {
                        property string value: "fruit-3"
                        text: qsTranslate("Opal.ComboData", "Pear")
                    }
                }
            }

            S.ValueButton {
                width: parent.width
                label: qsTranslate("Opal.ComboData", "Selected")
                value: !!fruitCombo.currentData ? fruitCombo.currentData : qsTranslate("Opal.ComboData", "nothing")
            }

            S.SectionHeader {
                text: "Using custom combo boxes"
            }

            I.InfoCombo {
                id: foodCombo
                width: parent.width
                label: "Food preference"

                property string currentData
                property var indexOfData
                C.ComboData { dataRole: "info" }

                I.InfoComboSection {
                    placeAtTop: true
                    title: "Food types"
                    text: "We provide different kinds of food."
                }

                menu: S.ContextMenu {
                    I.InfoMenuItem {
                        text: "Vegetarian"
                        info: "Vegetarian food does not have any meat."
                    }
                    I.InfoMenuItem {
                        text: "Vegan"
                        info: "Vegan food is completely plant-based."
                    }
                }

                I.InfoComboSection {
                    placeAtTop: false
                    title: "What about meat?"
                    text: "We don't provide any meat."
                }
            }

            S.ValueButton {
                width: parent.width
                label: qsTranslate("Opal.ComboData", "Details")
                value: !!foodCombo.currentData ? foodCombo.currentData : qsTranslate("Opal.ComboData", "no details available")
            }

            S.ValueButton {
                width: parent.width
                label: qsTranslate("Opal.ComboData", "Index by value")
                value: foodCombo.indexOfData(foodCombo.currentData)
            }
        }
    }
}
