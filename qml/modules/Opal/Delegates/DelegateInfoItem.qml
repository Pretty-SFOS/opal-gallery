//@ This file is part of opal-delegates.
//@ https://github.com/Pretty-SFOS/opal-delegates
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.5
import Sailfish.Silica 1.0

/*!
    \qmltype DelegateInfoItem
    \inqmlmodule Opal.Delegates
    \inherits Item

    \brief Item for adding an info box to a delegate.

    This item can be used to add an info box as a delegate's
    \l {PaddedDelegate::leftItem} or \l {PaddedDelegate::rightItem}.

    \section2 Contents

    The three texts are all optional and have different font sizes
    by default. The \l title text is small and at the top.
    The \l text text is large and in the middle. The \l description
    text is small and at the bottom.

    If one of the texts is empty, the others will move together
    so that they are vertically centered without leaving gaps.

    \section2 Sizing behaviour

    By default, the item will grow in width to fit all contents. It will
    also slim down to the size defined in \l minWidth if the
    labels are short.

    You can set the \l fixedWidth property to disable this behaviour.
    In that case, overflowing text will fade out to fit in.

    \section2 Content alignment

    By default, all labels are horizontally centered. This can be changed
    by setting the \l alignment property.

    When using centered alignment, make sure to set sane values for \l minWidth
    or \l fixedWidth. Otherwise the labels in a list of entries are unevenly
    centered.

    The vertical alignment is managed through the parent delegate. See
    \l {PaddedDelegate::leftItemAlignment} and \l {PaddedDelegate::rightItemAlignment}.

    \section2 Example

    \qml
    OneLineDelegate {
        text: "It's hot today"
        interactive: false

        rightItem: DelegateInfoItem {
            title: qsTr("Temperature")
            text: "36.3"
            description: qsTr("°C")
            fixedWidth: S.Theme.itemSizeLarge
        }
    }
    \endqml

    \sa PaddedDelegate, DelegateIconItem
*/
Item {
    id: root
    width: Math.max(column.width, minWidth)
    height: Math.max(parent.height, column.height)

    /*!
      This property defines the minimum width of the item.

      This value is ignored if \l fixedWidth is set to a
      value above zero.

      \defaultValue Theme.itemSizeMedium
    */
    property int minWidth: Theme.itemSizeMedium

    /*!
      This property defines the fixed width of the item.

      If this value is set to zero, the item will grow and
      shrink (at maximum down to \l minWidth) to fit the
      content.

      \defaultValue 0
    */
    property int fixedWidth: 0

    /*!
      This property defines the horizontal alignment of the labels.

      Allowed values are \l Qt.AlignHCenter, \l Qt.AlignLeft,
      and \l Qt.AlignRight.

      The vertical alignment is managed through the parent delegate. See
      \l {PaddedDelegate::leftItemAlignment} and \l {PaddedDelegate::rightItemAlignment}.

      \defaultValue Qt.AlignHCenter
    */
    property int alignment: Qt.AlignHCenter

    /*!
      This property maps the Qt alignment enum to the Text alignment enum.

      \internal
    */
    property int __textAlignment: {
        if (alignment == Qt.AlignHCenter) Text.AlignHCenter
        else if (alignment == Qt.AlignLeft) Text.AlignLeft
        else if (alignment == Qt.AlignRight) Text.AlignRight
        else Text.AlignHCenter
    }

    /*!
      This property defines the top text.

      The title text is small and at the top of the box.

      All texts are optional and will take up no space if
      they are empty.
    */
    property string title

    /*!
      This property defines the center text.

      The title text is large and at the center of the box.

      All texts are optional and will take up no space if
      they are empty.
    */
    property string text

    /*!
      This property defines the bottom text.

      The title text is small and at the bottom of the box.

      All texts are optional and will take up no space if
      they are empty.
    */
    property string description

    /*!
      This property gives access to the top label.

      You can use this property to customize all properties
      of the \l OptionalLabel item that is used
      for this text.
    */
    readonly property alias titleLabel: _line0

    /*!
      This property gives access to the center label.

      You can use this property to customize all properties
      of the \l OptionalLabel item that is used
      for this text.
    */
    readonly property alias textLabel: _line1

    /*!
      This property gives access to the bottom label.

      You can use this property to customize all properties
      of the \l OptionalLabel item that is used
      for this text.
    */
    readonly property alias descriptionLabel: _line2

    Column {
        id: column
        width: Math.max(_line0.width, _line1.width, _line2.width)
        height: Math.max(root.parent.height
                         , _line0.height
                         + _line1.height
                         + _line2.height)
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        OptionalLabel {
            id: _line0
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            text: root.title

            palette {
                primaryColor: Theme.secondaryColor
                highlightColor: Theme.secondaryHighlightColor
            }
        }

        OptionalLabel {
            id: _line1
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeLarge
            text: root.text

            palette {
                primaryColor: Theme.primaryColor
                highlightColor: Theme.highlightColor
            }
        }

        OptionalLabel {
            id: _line2
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            text: root.description

            palette {
                primaryColor: Theme.secondaryColor
                highlightColor: Theme.secondaryHighlightColor
            }
        }

        states: [
            State {
                name: "alignLeft"
                when: alignment == Qt.AlignLeft

                AnchorChanges {
                    target: column
                    anchors.horizontalCenter: undefined
                    anchors.left: parent.left
                    anchors.right: undefined
                }

                PropertyChanges {
                    target: _line0
                    horizontalAlignment: Text.AlignLeft
                }

                AnchorChanges {
                    target: _line0
                    anchors.horizontalCenter: undefined
                    anchors.left: parent.left
                    anchors.right: undefined
                }

                PropertyChanges {
                    target: _line1
                    horizontalAlignment: Text.AlignLeft
                }

                AnchorChanges {
                    target: _line1
                    anchors.horizontalCenter: undefined
                    anchors.left: parent.left
                    anchors.right: undefined
                }

                PropertyChanges {
                    target: _line2
                    horizontalAlignment: Text.AlignLeft
                }

                AnchorChanges {
                    target: _line2
                    anchors.horizontalCenter: undefined
                    anchors.left: parent.left
                    anchors.right: undefined
                }
            },
            State {
                name: "alignRight"
                when: alignment == Qt.AlignRight

                AnchorChanges {
                    target: column
                    anchors.horizontalCenter: undefined
                    anchors.left: undefined
                    anchors.right: parent.right
                }

                PropertyChanges {
                    target: _line0
                    horizontalAlignment: Text.AlignRight
                }

                AnchorChanges {
                    target: _line0
                    anchors.horizontalCenter: undefined
                    anchors.left: undefined
                    anchors.right: parent.right
                }

                PropertyChanges {
                    target: _line1
                    horizontalAlignment: Text.AlignRight
                }

                AnchorChanges {
                    target: _line1
                    anchors.horizontalCenter: undefined
                    anchors.left: undefined
                    anchors.right: parent.right
                }

                PropertyChanges {
                    target: _line2
                    horizontalAlignment: Text.AlignRight
                }

                AnchorChanges {
                    target: _line2
                    anchors.horizontalCenter: undefined
                    anchors.left: undefined
                    anchors.right: parent.right
                }
            }
        ]
    }

    states: [
        State {
            name: "fixedWidth"
            when: fixedWidth > 0

            PropertyChanges {
                target: root
                width: fixedWidth
            }

            PropertyChanges {
                target: column
                width: fixedWidth
            }

            PropertyChanges {
                target: _line0
                width: fixedWidth
                wrapped: false
                horizontalAlignment: _line0.contentWidth > fixedWidth ?
                                         Text.AlignLeft : __textAlignment
            }

            AnchorChanges {
                target: _line0
                anchors.horizontalCenter: undefined
                anchors.left: parent.left
            }

            PropertyChanges {
                target: _line1
                width: fixedWidth
                wrapped: false
                horizontalAlignment: _line1.contentWidth > fixedWidth ?
                                         Text.AlignLeft : __textAlignment
            }

            AnchorChanges {
                target: _line1
                anchors.horizontalCenter: undefined
                anchors.left: parent.left
            }

            PropertyChanges {
                target: _line2
                width: fixedWidth
                wrapped: false
                horizontalAlignment: _line2.contentWidth > fixedWidth ?
                                         Text.AlignLeft : __textAlignment
            }

            AnchorChanges {
                target: _line2
                anchors.horizontalCenter: undefined
                anchors.left: parent.left
            }
        }
    ]
}
