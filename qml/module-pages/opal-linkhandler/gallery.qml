/*
 * This file is part of harbour-opal.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2023-2025 Mirian Margiani
 */

import QtQuick 2.2
import Sailfish.Silica 1.0 as S
import Opal.Gallery 1.0 as G
import Opal.InfoCombo 1.0 as I
import Opal.ComboData 1.0

import Opal.LinkHandler 1.0 as L

S.Page {
    id: root
    allowedOrientations: S.Orientation.All

    property int linkPreviewMode: L.LinkPreviewMode.auto

    S.SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        S.VerticalScrollDecorator {}

        Column {
            id: column
            width: parent.width
            spacing: S.Theme.paddingMedium

            S.PageHeader {
                title: qsTranslate("Opal.LinkHandler", "External links")
            }

            S.SectionHeader {
                text: qsTranslate("Opal.LinkHandler", "Basic usage")
            }

            G.GalleryLabel {
                text: qsTranslate("Opal.LinkHandler", "This module lets users decide what to do when " +
                           "they click on a link.")
            }

            S.Label {
                // Example usage with a simple label
                x: S.Theme.horizontalPageMargin
                width: root.width - 2*x
                wrapMode: Text.Wrap
                text: qsTranslate("Opal.LinkHandler", "This label contains an " +
                      '<a href="https://example.org">external link</a> that you can activate. ' +
                      "Once clicked, a new page will prompt you to either open " +
                      "or copy the URL.")
                color: S.Theme.highlightColor
                linkColor: S.Theme.primaryColor
                onLinkActivated: L.LinkHandler.openOrCopyUrl(link, "", linkPreviewMode)
            }

            S.SectionHeader {
                text: qsTranslate("Opal.LinkHandler", "Advanced usage")
            }

            G.GalleryLabel {
                text: qsTranslate("Opal.LinkHandler", "The link handler can optionally allow users " +
                           "to quickly preview a link by swiping left, without " +
                           "having to open the browser.")
            }

            G.GalleryLabel {
                text: qsTranslate("Opal.LinkHandler", "No network connections will be made without " +
                           "explicit user interaction.")
            }

            I.InfoCombo {
                label: qsTranslate("Opal.LinkHandler", "Mode")
                linkHandler: function(link) { L.LinkHandler.openOrCopyUrl(link) }

                property ComboData cdata
                ComboData { dataRole: "value" }
                onValueChanged: linkPreviewMode = cdata.currentData
                Component.onCompleted: cdata.reset(linkPreviewMode)

                I.InfoComboSection {
                    text: qsTranslate("Opal.LinkHandler", "The URL scheme is checked and must be valid " +
                               "in all modes.")
                    placeAtTop: true
                }

                menu: S.ContextMenu {
                    I.InfoMenuItem {
                        text: qsTranslate("Opal.LinkHandler", "automatic")
                        info: qsTranslate("Opal.LinkHandler", "This mode enables the preview if any network connection " +
                                   "is available.")
                        property int value: L.LinkPreviewMode.auto
                    }
                    I.InfoMenuItem {
                        text: qsTranslate("Opal.LinkHandler", "no mobile data")
                        info: qsTranslate("Opal.LinkHandler", "This mode only enables the preview if connected " +
                                   "via Wifi. The preview is disabled when using mobile " +
                                   "data.")
                        property int value: L.LinkPreviewMode.disabledIfMobile
                    }
                    I.InfoMenuItem {
                        text: qsTranslate("Opal.LinkHandler", "enabled")
                        info: qsTranslate("Opal.LinkHandler", "This mode enables the preview without checking for " +
                                   "network access. Use this e.g. for links on <i>localhost</i>.")
                        property int value: L.LinkPreviewMode.enabled
                    }
                    I.InfoMenuItem {
                        text: qsTranslate("Opal.LinkHandler", "disabled")
                        info: qsTranslate("Opal.LinkHandler", "This mode disables the preview.") + " " +
                              qsTranslate("Opal.LinkHandler", "This is the default setting.")
                        property int value: L.LinkPreviewMode.disabled
                    }
                }
            }

            G.GalleryLabel {
                text: qsTranslate("Opal.LinkHandler", "There can be different kinds of links in a label and " +
                           "they can be handled individually.")
            }

            S.Label {
                x: S.Theme.horizontalPageMargin
                width: root.width - 2*x
                wrapMode: Text.Wrap
                text: qsTranslate("Opal.LinkHandler",  "This is " +
                      '<a href="tel:+4100000000">a phone number</a> while this is ' +
                      '<a href="https://example.org">a website</a>.')
                color: S.Theme.highlightColor
                linkColor: S.Theme.primaryColor

                onLinkActivated: {
                    if (/^tel:/.test(link)) {
                        L.LinkHandler.openOrCopyUrl(link, qsTranslate("Opal.LinkHandler", "Call me"), linkPreviewMode)
                    } else {
                        L.LinkHandler.openOrCopyUrl(link, qsTranslate("Opal.LinkHandler", "Website"), linkPreviewMode)
                    }
                }
            }

            S.SectionHeader {
                text: qsTranslate("Opal.LinkHandler", "Silica tools")
            }

            G.GalleryLabel {
                text: qsTranslate("Opal.LinkHandler", "Silica provides the “LinkedLabel” item that automatically " +
                           "finds links and phone numbers in its text and makes them " +
                           "clickable. Also note how the long URL is shortened.")
            }

            S.LinkedLabel {
                x: S.Theme.horizontalPageMargin
                width: root.width - 2*x
                shortenUrl: true
                plainText: qsTranslate("Opal.LinkHandler", "This number +4100000000 and " +
                           "this URL https://example.org/very-long?extra-long-data-" +
                           "which-will-be-shortened-automatically are automatically " +
                           "formatted as links.")

                defaultLinkActions: false
                onLinkActivated: L.LinkHandler.openOrCopyUrl(link, "", linkPreviewMode)
            }
        }
    }
}
