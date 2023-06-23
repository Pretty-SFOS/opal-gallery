/*
 * This file is part of harbour-opal-gallery.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2023 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Column {
        width: parent.width
        spacing: Theme.paddingMedium

        anchors {
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -Theme.paddingLarge
        }

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source: "../images/icon-l-opal.png"
            width: 1.5 * Theme.iconSizeLarge
            height: width
        }

        Item {
            width: parent.width
            height: Theme.paddingMedium
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 2*Theme.paddingMedium
            color: Theme.highlightColor
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            font.pixelSize: Theme.fontSizeLarge
            fontSizeMode: Text.VerticalFit

            text: "Opal"
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 2*Theme.paddingMedium
            color: Theme.secondaryHighlightColor
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            font.pixelSize: Theme.fontSizeLarge
            fontSizeMode: Text.VerticalFit

            text: qsTr("Gallery")
        }
    }
}
