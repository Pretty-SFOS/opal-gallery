/*
 * This file is part of harbour-opal-gallery.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2023 Mirian Margiani
 */

import Opal.About 1.0

ChangelogList {
    ChangelogItem {
        version: "1.8.1-1"
        date: "2026-01-09"
        paragraphs: [
            "- Added translations: Vietnamese<br>" +
            "- Updated translations: Czech, Dutch, Estonian, French, Indonesian, Norwegian Bokmål, Spanish, Swedish<br>" +
            "- Updated modules: LinkHandler with improved preview support, SortFilterProxyModel with improved integration, SupportMe with minor gallery fixes"
        ]
    }
    ChangelogItem {
        version: "1.8.0-1"
        date: "2025-12-24"
        paragraphs: [
            "- Added translations: Arabic, Bengali, Chinese (Traditional Han script), Dutch (Belgium), Hindi, Malayalam, Norwegian Nynorsk, Persian, Portuguese, Portuguese (Brazil), Tamil, Thai<br>" +
            "- Updated translations: Arabic, Chinese (Simplified Han script), Czech, Dutch (Belgium), Estonian, Finnish, French, German, Italian, Norwegian Nynorsk, Portuguese, Portuguese (Brazil), Romanian, Russian, Serbian, Slovak, Spanish, Swedish, Tamil, Turkish, Ukrainian<br>" +
            "- Fixed Opal.MediaPlayer example: requires Videos and MediaIndexing permissions<br>" +
            "- Added modules: SortFilterProxyModel, PropertyMacros, LocalStorage<br>" +
            "- Updated all modules: check out LinkHandler, About, Delegates, and more<br>" +
            "- Added a new app icon"
        ]
    }
    ChangelogItem {
        version: "1.7.0-1"
        date: "2024-10-30"
        paragraphs: [
            "<i>Translations:</i><br>" +
            "- Updated Estonian, French, Indonesian, Italian, Russian, Slovak, Spanish, Swedish, Turkish, Ukrainian, Lithuanian, and more<br>" +
            "- Fixed missing translations so that all available translations are actually shippped!<br>" +
            "<i>New modules:</i><br>" +
            "- Opal.MediaPlayer: a video player with support for subtitles and headphone buttons that can be added to apps with just a few lines of code<br>" +
            "- Opal.Tabs: a tab bar with a very simple API<br>" +
            "<i>Updated modules:</i> all modules with bug fixes and translation updates"
        ]
    }
    ChangelogItem {
        version: "1.6.0-1"
        date: "2024-10-11"
        paragraphs: [
            "<i>Translations:</i> Ukrainian, Spanish, Chinese, and many more<br>" +
            "<i>New modules:</i><br>" +
            "- Opal.DragDrop: enables ordering lists by drag-and-drop with just a few lines of code<br>" +
            "- Opal.SmartScrollbar: a Harbour-compatible smart scroll bar for long lists<br>" +
            "- Opal.MenuSwitch: a toggle button to be used in Sailfish-style menus<br>" +
            "<i>Updated modules:</i> About, SupportMe, Delegates, InfoCombo, ComboData, LinkHandler"
        ]
    }
    ChangelogItem {
        version: "1.5.1-1"
        date: "2024-07-26"
        paragraphs: [
            "<i>Hotfix:</i> example page of Opal.Delegates failed to load due to a mistake with translation handling."
        ]
    }
    ChangelogItem {
        version: "1.5.0-1"
        date: "2024-07-26"
        paragraphs: [
            "<i>Translations:</i> German, Spanish, Estonian, French, Hungarian, Turkish.",
            "<i>Modules:</i> updated Opal.InfoCombo and added a development preview of Opal.MenuSwitch. The module list is now designed using the new Opal.Delegates module, check it out if your app uses lists!",
            "<i>Planned modules:</i> a list of upcoming and planned modules has been added. They are not yet included in Opal and there are no examples yet. They will be integrated slowly in upcoming versions."
        ]
    }
    ChangelogItem {
        version: "1.4.0-1"
        date: "2024-06-29"
        paragraphs: [
            "<i>Translations:</i> English, Swedish, Estonian, Chinese, Ukrainian, Indonesian, Spanish, Russian, Polish, French have been updated from modules.",
            "<i>Modules:</i> the new Opal.SupportMe, Opal.Delegates, and Opal.LinkHandler modules have been added. All other modules have been updated to the latest version.",
            "<i>New support page:</i> a new call for support has been added, built with the Opal.SupportMe module."
        ]
    }
    ChangelogItem {
        version: "1.3.0"
        date: "2023-06-23"
        paragraphs: [
            "<i>Modules:</i> the new Opal.ComboData module has been added. " +
            "Opal.About and Opal.InfoCombo have been updated to the latest version.",
            "<i>Translations:</i> Swedish, Spanish, French, and many more have been " +
            "updated."
        ]
    }
    ChangelogItem {
        version: "1.2.0"
        date: "2023-06-13"
        paragraphs: [
            "<i>Translations:</i> Indonesian and French have been updated and many " +
            "more have been added from other modules.",
            "<i>Modules:</i> Opal.About has been updated to version 2.1.0.",
            "<i>“About” page:</i> information about translations, contributors, " +
            "and donations has been added to the “About” page."
        ]
    }
    ChangelogItem {
        version: "1.1.0"
        date: "2023-06-08"
        paragraphs: [
            "<i>Updated modules:</i> Opal.About has been updated to version 2.0.0",
            "<i>New changelog:</i> a new in-app changelog has been introduced, built with " +
            "the updated About page module."
        ]
    }
    ChangelogItem {
        version: "1.0.0"
        date: "2023-06-04"
        author: "ichthyosaurus"
        paragraphs: "First public release."
    }
}
