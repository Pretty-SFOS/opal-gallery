//@ This file is part of opal-supportme.
//@ https://github.com/Pretty-SFOS/opal-supportme
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Sailfish.Silica 1.0

/*!
    \qmltype DetailsDrawer
    \inqmlmodule Opal.SupportMe
    \inherits QtObject
    \brief Hide long content in a drawer.

    This component allows to hide long content in a drawer
    that expands/shrinks when it is clicked.

    The drawer can optionally have a title. It contains
    a column that can hold any content you like.

    The \l DetailsParagraph component is made to be used
    to show text instead of plain \c Label items.

    \important do not change the \c height property of this
    component. Instead, change \l closedHeight to define
    a custom size.

    Example:

    \qml
    DetailsDrawer {
        title: qsTr("Why should you care?")

        DetailsParagraph {
            text: qsTr("This project is built with love and passion by a " +
                       "single developer in their spare time, and is provided " +
                       "to you free of charge.")
        }

        DetailsParagraph {
            text: qsTr("I develop Free Software because I am convinced that " +
                       "it is the ethical thing to do - and it is a fun hobby. " +
                       "However, developing software takes a lot of time and effort. " +
                       "As Sailfish and living in general costs money, I need your " +
                       "support to be able to spend time on non-paying projects " +
                       "like this.")
        }
    }
    \endqml

    \note you can use Silica's \c ButtonLayout to comfortably
    include a list of buttons.

    \note use the \c {Opal.LinkHandler} module to give the
    user the option to open or copy links.

    \sa DetailsParagraph, ButtonLayout
*/
BackgroundItem {
    id: root
    width: parent.width

    /*!
      The calculated current height of the item. Do not change.

      If you want to define a custom size for the item,
      modify the \l closedHeight property instead.
    */
    height: (isOpen || !_canOpen ? openHeight : _actualClosedHeight) + extraHeight

    /*!
      This property holds an optional title for the drawer.

      The title is shown above all content and uses
      standard Silica styling for section headers.
    */
    property alias title: titleField.text

    /*!
      Define your custom content as direct children of \l DetailsDrawer.

      All content is included in a column. See above for an example.
    */
    default property alias content: contentBody.data

    /*!
      This property defines whether to drawer is expanded or closed.

      Modifying this property will open/close the drawer. The
      property is updated when the item is clicked.
    */
    property bool isOpen: false

    /*!
      This property defines the maximum height of the item.

      Note that the item will not be expandable if the actual
      content height is smaller than the size defined in this
      property. In that case, the \l DetailsDrawer will behave
      like a standard non-interactive column.
    */
    property int closedHeight: 1.5 * Theme.itemSizeHuge

    /*!
      This property holds the actual size of the item when it is closed.

      Note that the actual size can be smaller than the size defined
      in \l closedHeight.

      \internal
    */
    readonly property int _actualClosedHeight: Math.min(closedHeight, openHeight)

    /*!
      This property tells whether the drawer can be expanded.

      \internal
    */
    readonly property bool _canOpen: _actualClosedHeight >= closedHeight

    /*!
      This property holds the actual content height.
    */
    readonly property int openHeight: contentColumn.height

    /*!
      This property holds the height of the "show more" label and padding.
    */
    readonly property int extraHeight: footer.height

    highlightedColor: "transparent"
    palette.highlightColor: down && _canOpen ?
        Theme.secondaryHighlightColor :
        Theme.highlightColor

    onClicked: {
        isOpen = !isOpen
    }

    OpacityRampEffect {
        enabled: _canOpen && !root.isOpen
        sourceItem: contentItem
        direction: OpacityRamp.TopToBottom
    }

    Item {
        id: contentItem
        clip: true
        width: parent.width
        height: root.isOpen || !_canOpen ?
                    root.openHeight :
                    root._actualClosedHeight

        Behavior on height {
            animation: NumberAnimation {
                duration: 80
            }
        }

        Column {
            id: contentColumn
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x
            spacing: Theme.paddingMedium

            SectionHeader {
                id: titleField
                x: 0

                Binding on height {
                    when: titleField.text === ""
                    value: 0
                }
            }

            Column {
                id: contentBody
                width: parent.width
                spacing: Theme.paddingMedium
            }

            Item {
                width: 1
                height: 1
            }
        }
    }

    Item {
        id: footer
        visible: _canOpen
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        anchors.top: contentItem.bottom
        height: visible ? Theme.itemSizeExtraSmall : 0

        Row {
            spacing: Theme.paddingMedium
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
            }

            Label {
                id: showMoreLabel
                font.pixelSize: Theme.fontSizeExtraSmall
                font.italic: true
                text: root.isOpen ?
                          qsTr("show less") :
                          qsTr("show more")
            }

            Label {
                anchors.verticalCenter: showMoreLabel.verticalCenter
                text: "• • •"
            }
        }
    }
}
