//@ This file is part of opal-supportme.
//@ https://github.com/Pretty-SFOS/opal-supportme
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Sailfish.Silica 1.0

/*!
    \qmltype SupportDialog
    \inqmlmodule Opal.SupportMe
    \inherits QtObject
    \brief Define the content of your support dialog.

    This component defines the basic structure of a support
    dialog. Custom items can be added to the body of the
    dialog by simply adding them as direct children of this
    component.

    See the main documentation (\l AskForSupport) for a complete
    example dialog.

    All content will be added in a column. You can configure
    the standard contents by changing the respecting properties.

    \sa AskForSupport, SupportAction, DetailsDrawer
*/
Dialog {
    id: root
    allowedOrientations: Orientation.All

    /*!
      This property defines the main title of the dialog.

      The text here should be short and inviting. It is
      shown in huge letters at the top.

      Default: Hi there!
    */
    property string greeting: qsTr("Hi there!")

    /*!
      This property defines the introduction text.

      The text should be short and inviting. It is
      shown directly below the greeting.

      Default: Thank you for using my little app!
      Maybe you can contribute back?
    */
    property string hook: qsTr("Thank you for using my little app! " +
                               "Maybe you can contribute back?")

    /*!
      This property defines the salutation.

      The text is shown at the very end of the dialog
      in big letters.

      Default: Thank you for your support!
    */
    property string goodbye: qsTr("Thank you for your support!")

    /*!
      All items added as children of the dialog will be added
      to the body column.
    */
    default property alias contents: contentColumn.data

    /*!
      \internal
    */
    signal dontAskAgain

    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator {
            flickable: flick
        }

        Column {
            id: column
            width: parent.width

            PageHeader { /* empty on purpose */ }

            Label {
                visible: !!greeting
                topPadding: Theme.paddingMedium
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeHuge
                font.family: Theme.fontFamilyHeading
                wrapMode: Text.Wrap
                color: palette.highlightColor
                text: greeting
            }

            Label {
                visible: !!hook
                topPadding: Theme.paddingMedium
                bottomPadding: Theme.paddingMedium
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                color: palette.highlightColor
                font.pixelSize: Theme.fontSizeMedium
                wrapMode: Text.Wrap
                text: hook
            }

            Column {
                id: contentColumn
                width: parent.width
                spacing: Theme.paddingMedium

                Item {
                    width: 1
                    height: Theme.paddingSmall
                }
            }

            Label {
                visible: !!goodbye
                topPadding: 2*Theme.paddingLarge
                x: 4*Theme.horizontalPageMargin
                width: parent.width - 2*x
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeExtraLarge
                font.family: Theme.fontFamilyHeading
                wrapMode: Text.Wrap
                color: palette.highlightColor
                text: goodbye
            }

            Item {
                width: 1
                height: 2*Theme.paddingLarge
            }

            ButtonLayout {
                preferredWidth: Theme.buttonWidthLarge

                Button {
                    text: qsTr("Remind me later")
                    onClicked: root.accept()
                }

                Button {
                    text: qsTr("Don't ask me again")
                    onClicked: {
                        root.dontAskAgain()
                        root.accept()
                    }
                }
            }

            Item {
                width: 1
                height: 2*Theme.paddingLarge
            }
        }
    }
}
