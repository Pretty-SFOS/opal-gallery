/*
 * This file is part of harbour-opal.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2024 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0 as S

S.Page {
    id: root
    allowedOrientations: S.Orientation.All

    // TODO
    // - handle overflowing text gracefully: the toggle indicator
    //   should never become covered by text
    // - write documentation

    S.SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: column.height + S.Theme.horizontalPageMargin

        S.VerticalScrollDecorator { flickable: flick }

        S.PullDownMenu {
            flickable: flick

            MenuSwitch {
                text: qsTr("Enable a setting")
            }

            MenuSwitch {
                text: qsTr("Enable another setting")
            }
        }

        Column {
            id: column
            width: parent.width
            spacing: S.Theme.paddingMedium

            S.PageHeader {
                title: qsTr("Menus")
            }

            S.SectionHeader {
                text: qsTr("Context menus")
            }

            S.ComboBox {
                id: fruitCombo
                label: qsTr("Click here to open a menu")
                currentIndex: -1

                onPressAndHold: clicked(mouse)
                onCurrentIndexChanged: {
                    if (currentIndex >= 0) {
                        currentIndex = -1
                    }
                }

                menu: S.ContextMenu {
                    MenuSwitch {
                        text: qsTr("Option 1")
                        checked: true
                    }
                    MenuSwitch {
                        text: qsTr("Option 2")
                    }
                    MenuSwitch {
                        text: qsTr("Option 3")
                    }
                }
            }

            S.SectionHeader {
                text: qsTr("Top/bottom menus")
            }

            S.Label {
                x: S.Theme.horizontalPageMargin
                width: parent.width - 2*x
                wrapMode: Text.Wrap
                text: qsTr("Pull down to open the top menu containing " +
                           "more switches.")
                color: S.Theme.secondaryHighlightColor
            }
        }
    }
}
