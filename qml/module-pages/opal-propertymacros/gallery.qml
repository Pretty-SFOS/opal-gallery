//@ This file is part of Opal.PropertyMacros for use in harbour-opal-gallery.
//@ https://github.com/Pretty-SFOS/opal-propertymacros
//@ SPDX-License-Identifier: GPL-3.0-or-later
//@ SPDX-FileCopyrightText: 2023-2025 Mirian Margiani

import QtQuick 2.0
import Sailfish.Silica 1.0 as S

S.Page {
    id: root
    allowedOrientations: S.Orientation.All

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
                title: "Opal.PropertyMacros"
            }

            S.SectionHeader {
                text: qsTranslate("Opal.PropertyMacros", "About this module")
            }

            Repeater {
                model: [
                    "This module provides C++ macros to help with defining " +
                    "QML properties in classes derived from <b>QObject</b> and <b>QGadget</b>.",

                    "Instead of writing a <b>Q_PROPERTY</b> entry, with custom signals, " +
                    "setters, and getters, you can now define a property in a single line. " +
                    "The macros will then define all necessary boilerplate for you.",

                    "Include the <b>property_macros.h</b> header in your C++ classes " +
                    "to use this module.",

                    "Read the comments in the file for more information."
                ]

                S.Label {
                    x: S.Theme.horizontalPageMargin
                    width: root.width - 2*x
                    wrapMode: Text.Wrap
                    color: S.Theme.highlightColor
                    font.pixelSize: S.Theme.fontSizeSmall
                    text: modelData
                }
            }
        }
    }
}
