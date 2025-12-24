//@ This file is part of opal-about.
//@ https://github.com/Pretty-SFOS/opal-about
//@ SPDX-FileCopyrightText: 2025 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

pragma Singleton
import QtQuick 2.0

// NOTE This enum is intended *only* to be used with
// AboutPageBase::allowDownloadingLicenses.
//
// For the sake of backwards compatibility, remember
// that the meaning of "0" must equal "false", and the meaning
// of "1" must equal "true".

QtObject {
    readonly property int auto: 0  // previously false
    readonly property int enabled: 1  // previously true
    readonly property int disabled: 2
}
