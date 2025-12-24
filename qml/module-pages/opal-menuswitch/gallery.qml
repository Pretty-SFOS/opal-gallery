/*
 * This file is part of harbour-opal.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2024 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import Opal.MenuSwitch 1.0

S.Page {
    id: root
    allowedOrientations: S.Orientation.All

    S.SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: column.height + S.Theme.horizontalPageMargin

        S.VerticalScrollDecorator { flickable: flick }

        S.PullDownMenu {
            flickable: flick

            MenuSwitch {
                text: qsTranslate("Opal.MenuSwitch.Gallery", "Enable a setting")
            }

            MenuSwitch {
                text: qsTranslate("Opal.MenuSwitch.Gallery", "Enable another setting")
            }
        }

        Column {
            id: column
            width: parent.width
            spacing: S.Theme.paddingMedium

            S.PageHeader {
                title: qsTranslate("Opal.MenuSwitch.Gallery", "Menus")
            }

            S.SectionHeader {
                text: qsTranslate("Opal.MenuSwitch.Gallery", "Context menus")
            }

            S.ComboBox {
                id: fruitCombo
                label: qsTranslate("Opal.MenuSwitch.Gallery", "Click here to open a menu")
                currentIndex: -1

                onPressAndHold: clicked(mouse)
                onCurrentIndexChanged: {
                    if (currentIndex >= 0) {
                        currentIndex = -1
                    }
                }

                menu: S.ContextMenu {
                    S.MenuItem {
                        text: qsTranslate("Opal.MenuSwitch.Gallery", "Regular option")
                    }
                    MenuSwitch {
                        text: qsTranslate("Opal.MenuSwitch.Gallery", "Activatable option")
                        checked: true
                    }
                    MenuSwitch {
                        text: qsTranslate("Opal.MenuSwitch.Gallery", "Third option with more text")
                    }
                }
            }

            S.SectionHeader {
                text: qsTranslate("Opal.MenuSwitch.Gallery", "Top/bottom menus")
            }

            S.Label {
                x: S.Theme.horizontalPageMargin
                width: parent.width - 2*x
                wrapMode: Text.Wrap
                text: qsTranslate("Opal.MenuSwitch.Gallery", "Pull down to open the top menu containing " +
                           "more switches.")
                color: S.Theme.secondaryHighlightColor
            }
        }
    }
}
