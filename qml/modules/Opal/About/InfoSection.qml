//@ This file is part of opal-about.
//@ https://github.com/Pretty-SFOS/opal-about
//@ SPDX-FileCopyrightText: 2020-2023 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../LinkHandler" as L

/*!
    \qmltype InfoSection
    \inqmlmodule Opal.About
    \inherits QtObject
    \brief Defines a section on the main About page.

    Info sections (defined through the \l AboutPageBase::extraSections property)
    can show a paragraph, a paragraph of small print, and one or multiple
    buttons below the text(s).

    They are not intended for attributions to (e.g.) third-party libraries.
    Use dedicated attributions (with support for licenses) instead, through
    the \l AboutPageBase::attributions property.

    \qml
    extraSections: InfoSection {
        title: qsTr("Data")
        text: qsTr("Lorem ipsum dolor sit amet et cetera ad libitum plurum sid alum.")
        smallPrint: qsTr("Alum sid plurum libitum ad cetera et amet sit dolor ipsum lorem.")
        buttons: InfoButton {
            text: qsTr("Terms of Use")
            onClicked: openOrCopyUrl("https://example.org")
        }
    }
    \endqml

    \sa InfoSection, InfoButton, AboutPageBase::extraSections, AboutPageBase::openOrCopyUrl
*/
Column {
    id: root
    spacing: 0
    width: parent.width
    height: childrenRect.height

    // Proxy LinkHandler::openOrCopyUrl to ensure it is available.
    function openOrCopyUrl(externalUrl, title) {
        L.LinkHandler.openOrCopyUrl(externalUrl, title)
    }

    /*!
      This property holds the section title.

      The title is not required and may be omitted.
    */
    property alias title: _titleLabel.text

    /*!
      This property holds the text shown in the section.

      This text will be normal sized. Use \l smallPrint for
      tiny text.
    */
    property string text: ""

    /*!
      This property holds any small print inflicted on users.

      This text will be very small. Use \l text for normal
      sized text.
    */
    property string smallPrint: ""

    /*!
      This property holds the text shown to hint at more details.

      This label will only be shown if \l enabled is \c true.
      The default text is "show details".
    */
    property string showMoreLabel: qsTranslate("Opal.About", "show details")

    /*!
      This property holds a list of buttons to be shown below the text.

      Buttons should be used for opening something externally, for example
      a website. If you want to show a new page in the app, make the
      section clickable (\l enabled, \l showMoreLabel, \l clicked).

      \sa InfoButton, enabled, showMoreLabel, clicked
    */
    property list<InfoButton> buttons

    /*!
      If this is \c true, the section will be clickable and \l showMoreLabel will be shown.

      \sa clicked
    */
    property alias enabled: _bgItem.enabled

    /*!
      This property holds all children.
      \internal
    */
    default property alias contentItem: _contents.children

    /*!
      This signal is emitted when the section is clicked.

      It is recommended to use this for showing new pages, for
      example for pushing a new page with gameplay rules.
      Use \e buttons if you want to open something externally.

      The corresponding handler is \c onClicked.

      \sa enabled, buttons, AboutPageBase::openOrCopyUrl, Qt::openUrlExternally
    */
    signal clicked

    property alias _backgroundItem: _bgItem
    property alias _titleItem: _titleLabel
    property alias _textItem: _textLabel
    property alias _smallPrintItem: _smallPrintLabel
    property alias _showMoreLabelItem: _showMoreLabel

    property list<DonationService> __donationButtons

    BackgroundItem {
        id: _bgItem

        enabled: false
        width: parent.width
        height: column.height

        onClicked: root.clicked()

        Column {
            id: column
            width: parent.width - 2*Theme.horizontalPageMargin
            height: childrenRect.height
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 0

            Item {
                width: 1
                height: Theme.paddingSmall
            }

            Label {
                id: _titleLabel
                width: parent.width
                horizontalAlignment: Text.AlignRight
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeMedium
                visible: text !== ""
                height: visible ? implicitHeight + Theme.paddingSmall : 0
                color: Theme.highlightColor
            }

            Item {
                id: _contents
                width: parent.width
                height: childrenRect.height
            }

            Column {
                width: parent.width
                spacing: Theme.paddingMedium
                visible: root.text !== "" || root.smallPrint !== ""

                Label {
                    id: _textLabel
                    visible: root.text !== ''
                    width: parent.width
                    horizontalAlignment: Text.AlignLeft
                    wrapMode: Text.Wrap
                    text: root.text
                    textFormat: Text.StyledText
                    linkColor: palette.secondaryColor
                    palette.primaryColor: Theme.highlightColor
                    onLinkActivated: openOrCopyUrl(link)
                }

                Label {
                    id: _smallPrintLabel
                    visible: smallPrint !== ''
                    width: parent.width
                    horizontalAlignment: Text.AlignLeft
                    wrapMode: Text.Wrap
                    text: smallPrint
                    textFormat: Text.StyledText
                    linkColor: palette.secondaryColor
                    palette.primaryColor: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    onLinkActivated: openOrCopyUrl(link)
                }

                Row {
                    id: showMoreRow
                    anchors.right: parent.right
                    spacing: Theme.paddingSmall
                    visible: root.enabled && showMoreLabel !== ""
                    height: visible ? _showMoreLabel.height : 0

                    Label {
                        id: _showMoreLabel
                        font.pixelSize: Theme.fontSizeExtraSmall
                        textFormat: Text.StyledText
                        text: "<i>%1</i>".arg(showMoreLabel)
                    }
                    Label {
                        anchors.verticalCenter: _showMoreLabel.verticalCenter
                        text: " \u2022 \u2022 \u2022" // three dots
                    }
                }
            }

            Item {
                width: 1
                height: root.text !== "" ? Theme.paddingMedium : 0
            }
        }
    }

    Item {
        width: 1
        height: (buttons.length > 0 || __donationButtons.length > 0)
                ? Theme.paddingMedium : 0
    }

    Column {
        width: parent.width
        height: childrenRect.height
        spacing: Theme.paddingMedium

        Repeater {
            model: buttons
            delegate: Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 4 * 3
                height: visible ? implicitHeight : 0

                visible: modelData.text !== '' && modelData.enabled === true
                text: modelData.text
                onClicked: modelData.clicked()
            }
        }

        Repeater {
            model: __donationButtons
            delegate: Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 4 * 3
                height: visible ? implicitHeight : 0

                visible: modelData.name !== '' && modelData.url !== ''
                text: modelData.name
                onClicked: openOrCopyUrl(modelData.url)
            }
        }
    }
}
