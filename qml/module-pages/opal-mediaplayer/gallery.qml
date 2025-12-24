//@ This file is part of Opal.MediaPlayer for use in harbour-opal-gallery.
//@ https://github.com/Pretty-SFOS/opal-mediaplayer
//@ SPDX-License-Identifier: GPL-3.0-or-later
//@ SPDX-FileCopyrightText: 2023-2024 Mirian Margiani

import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import "gallery"

VideoPickerPage {
    allowedOrientations: Orientation.All
    onSelectedContentPropertiesChanged: {
        pageStack.push("gallery/ViewVideoPage.qml", {
            path: selectedContentProperties.filePath,
            title: !selectedContentProperties.title ||
                   selectedContentProperties.title === "''" ?
                       selectedContentProperties.fileName :
                       selectedContentProperties.title,
        })
    }
}
