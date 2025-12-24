/*
 * This file is part of harbour-opal.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2023 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
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
                title: "Informed choices"
            }

            S.SectionHeader {
                text: "Simple usage"
            }

            I.InfoCombo {
                width: parent.width
                label: "Soup preference"

                menu: S.ContextMenu {
                    I.InfoMenuItem {
                        text: "Surprise me"
                        info: "We will provide you with a soup of our choice. " +
                              "It will be the one that is taken the least."
                    }
                    I.InfoMenuItem {
                        text: "Stew"
                        info: "It is up to you to decide whether " +
                              "stew counts as soup."
                    }
                    I.InfoMenuItem {
                        text: "Noodles"
                        info: "You cannot go wrong with a simple noodle soup."
                    }
                }
            }

            S.SectionHeader {
                text: "Almost as simple usage"
            }

            I.InfoCombo {
                width: parent.width
                label: "Food preference"

                I.InfoComboSection {
                    placeAtTop: true
                    title: "Food types"
                    text: "We provide different kinds of food."
                }

                menu: S.ContextMenu {
                    S.MenuItem {
                        text: "Vegetarian"
                        property string info: "Vegetarian food does not have any meat."
                    }
                    S.MenuItem {
                        text: "Vegan"
                        property string info: "Vegan food is completely plant-based."
                    }
                }

                I.InfoComboSection {
                    placeAtTop: false
                    title: "What about meat?"
                    text: "We don't provide any meat."
                }
            }

            S.SectionHeader {
                text: "Many options"
            }

            I.InfoCombo {
                width: parent.width
                label: "Choices"
                description: "This box allows you to choose from many options. Which " +
                             "one will you take?"

                I.InfoComboSection {
                    title: "Why is this page empty?"
                    text: "Even though there are many options, none of them has an " +
                          "info property defined. If it weren't for this text, this " +
                          "page would be empty. In this case, a basic ComboBox would " +
                          "have been the better choice."
                }

                menu: S.ContextMenu {
                    Repeater {
                        model: 30

                        S.MenuItem {
                            text: "Choice No. " + (modelData + 1)
                        }
                    }
                }
            }
        }
    }
}
