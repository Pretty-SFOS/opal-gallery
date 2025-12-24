//@ This file is part of opal-infocombo.
//@ https://github.com/Pretty-SFOS/opal-infocombo
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.6
import Sailfish.Silica 1.0

SilicaControl {
    id: root
    height: column.height
    width: parent.width
    highlighted: false

    property bool allowChanges
    property ComboBox comboBox
    property int modelIndex

    signal linkActivated(var link)

    // Note:
    // Why not allow clicking the description to select an option?
    // 1. Due to limitations in Silica, it is not possible to make a
    //    list of interactive elements that doesn't flicker when being
    //    scrolled. The necessary tools are private in Silica and
    //    cannot be used due to Harbour restrictions.
    // 2. If the description is interactive, it is easily possible
    //    to accidentally select an option when trying to scroll
    //    below the end of the page. That is annoying.
    // 3. Having interactive elements inside of an interactive
    //    element that have different effects is confusing.
    //    Clickable links in the description are more important
    //    than (mis-)selecting an option more quickly.

    Column {
        id: column
        width: parent.width

        TextSwitch {
            id: toggle

            height: implicitHeight
            checked: !!comboBox && comboBox.currentIndex == modelIndex
            automaticCheck: false
            leftMargin: Theme.horizontalPageMargin + Theme.paddingMedium

            Binding on highlighted {
                when: !allowChanges
                value: true
            }

            text: modelData.title

            onClicked: {
                if (!allowChanges || !comboBox || comboBox.currentIndex == modelIndex) {
                    return
                }

                comboBox.currentIndex = modelIndex
            }
        }

        Label {
            id: descriptionLabel
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x
            height: text.length > 0 ? (implicitHeight + Theme.paddingMedium) : 0
            opacity: root.enabled ? 1.0 : Theme.opacityLow
            wrapMode: Text.Wrap
            font.pixelSize: Theme.fontSizeSmall
            color: root.palette.secondaryHighlightColor
            linkColor: highlighted ? root.palette.highlightColor : root.palette.secondaryColor
            onLinkActivated: root.linkActivated(link)
            text: modelData.text
        }
    }
}
