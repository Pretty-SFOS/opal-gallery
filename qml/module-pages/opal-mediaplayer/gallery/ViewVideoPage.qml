//@ This file is part of Opal.MediaPlayer for use in harbour-opal-gallery.
//@ https://github.com/Pretty-SFOS/opal-mediaplayer
//@ SPDX-License-Identifier: GPL-3.0-or-later
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani

import QtQuick 2.0
import Sailfish.Silica 1.0
import Opal.MediaPlayer 1.0

VideoPlayerPage {
    id: root
    allowedOrientations: Orientation.All

    // Required properties that must be set when pushing this page:
    // path: "/home..."
    // title: "My video"

    autoplay: true
    repeat: false
    continueInBackground: false
    enableDarkBackground: true

    mprisAppId: qsTranslate("AboutPage", "Opal Gallery")
}
