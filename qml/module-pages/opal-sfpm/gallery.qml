//@ This file is part of Opal.SortFilterProxyModel for use in harbour-opal-gallery.
//@ https://github.com/Pretty-SFOS/opal-sfpm
//@ SPDX-License-Identifier: GPL-3.0-or-later
//@ SPDX-FileCopyrightText: 2023-2025 Mirian Margiani

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import Opal.SortFilterProxyModel 1.0 as M

import Opal.Gallery 1.0 as G

S.Page {
    id: root
    allowedOrientations: S.Orientation.All

    M.SortFilterProxyModel {
        id: proxy
        sourceModel: G.GalleryFruitModel {}

        sorters: [
            M.RoleSorter {
                enabled: sortByCombo.isByName
                ascendingOrder: directionCombo.isAscending
                roleName: "name"
            },
            M.RoleSorter {
                enabled: !sortByCombo.isByName
                ascendingOrder: directionCombo.isAscending
                roleName: "numericPrice"
            }
        ]

        proxyRoles: M.ExpressionRole {
            name: "numericPrice"
            expression: Number(model.price)
        }
    }

    S.SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: column.height + S.Theme.horizontalPageMargin

        S.VerticalScrollDecorator { flickable: flick }

        Column {
            id: column
            width: parent.width
            spacing: S.Theme.paddingMedium

            S.PageHeader {
                title: "Opal.SortFilterProxyModel"
            }

            S.SectionHeader {
                text: qsTranslate("Opal.SortFilterProxyModel", "Settings")
            }

            S.ComboBox {
                id: sortByCombo
                property bool isByName: currentIndex === 0

                width: parent.width
                label: qsTranslate("Opal.SortFilterProxyModel", "Sort by")

                menu: S.ContextMenu {
                    S.MenuItem {
                        text: qsTranslate("Opal.SortFilterProxyModel", "Name")
                    }
                    S.MenuItem {
                        text: qsTranslate("Opal.SortFilterProxyModel", "Price")
                    }
                }
            }

            S.ComboBox {
                id: directionCombo
                property bool isAscending: currentIndex === 0

                width: parent.width
                label: qsTranslate("Opal.SortFilterProxyModel", "Direction")

                menu: S.ContextMenu {
                    S.MenuItem {
                        text: "A-Z"
                    }
                    S.MenuItem {
                        text: "Z-A"
                    }
                }
            }

            S.SectionHeader {
                text: qsTranslate("Opal.SortFilterProxyModel", "Result")
            }

            S.ColumnView {
                model: proxy
                width: parent.width
                itemHeight: S.Theme.itemSizeSmall

                // Hint: use Opal.Delegates for more beautiful delegates with less code
                delegate: S.ListItem {
                    width: root.width
                    enabled: false

                    S.DetailItem {
                        label: model.name
                        value: model.price
                    }
                }
            }
        }
    }
}
