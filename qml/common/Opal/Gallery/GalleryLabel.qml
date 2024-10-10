/*
 * This file is part of harbour-opal-gallery.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2024 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

Label {
    x: Theme.horizontalPageMargin
    width: parent.width - 2*x
    wrapMode: Text.Wrap
    color: Theme.secondaryHighlightColor
    font.pixelSize: Theme.fontSizeSmall
}
