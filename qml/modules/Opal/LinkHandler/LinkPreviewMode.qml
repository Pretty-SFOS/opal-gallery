//@ This file is part of opal-linkhandler.
//@ https://github.com/Pretty-SFOS/opal-linkhandler
//@ SPDX-FileCopyrightText: 2025 roundedrectangle
//@ SPDX-FileCopyrightText: 2025 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

pragma Singleton
import QtQuick 2.0

// NOTE When changing values, remember to adapt LinkHandler.js.
// NOTE Values are documented in openOrCopyUrl() in LinkHandler.js.

QtObject {
    // scheme is checked in all cases!

    // verify that that any network connection is enabled
    readonly property int auto: 0

    // always enabled
    readonly property int enabled: 1

    // disabled if no network or mobile data is connected
    readonly property int disabledIfMobile: 2

    // always disabled
    readonly property int disabled: 3
}
