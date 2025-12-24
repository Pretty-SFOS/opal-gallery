//@ This file is part of opal-delegates.
//@ https://github.com/Pretty-SFOS/opal-delegates
//@ SPDX-FileCopyrightText: 2023 Peter G. (nephros)
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Sailfish.Silica 1.0

/*!
    \qmltype TwoLineDelegate
    \inqmlmodule Opal.Delegates
    \inherits PaddedDelegate

    \brief Delegate for two strings of text.

    This delegate can be used to show a primary text,
    a description, as well as custom left and right items.

    All texts are optional and will take up no space if
    they are empty.

    \section2 Anatomy

    The delegate is structured like this:

    \code
    +----------------------------------------------------------+
    |                        top padding                       |
    |         +--------------------------------------+         |
    | left    | left  |          text        | right | right   |
    | padding | item  |       description    | item  | padding |
    |         +--------------------------------------+         |
    |                      bottom padding                      |
    +----------------------------------------------------------+
    \endcode

    \section2 Wrapped text

    The text is not wrapped by default. You can configure that
    by changing the \l {OptionalLabel::wrapped} property of
    the label. However, note that the height of the delegate
    will become dynamic if text is wrapped.

    You can programmatically switch between wrapped and
    non-wrapped views by passing the label to the
    \l {PaddedDelegate::toggleWrappedText} function:

    \qml
    toggleWrappedText(textLabel)
    toggleWrappedText(descriptionLabel)
    \endqml

    \section2 Side content

    You can define custom content in the \l {PaddedDelegate::leftItem}
    and \l {PaddedDelegate::rightItem} properties. Common uses
    are to show an icon or some additional info. For this, you can
    use \l DelegateIconItem and \l DelegateInfoItem respectively.

    \section2 Custom content items

    Arbitrary extra content items can be appended at the bottom of the center
    column by parenting them to the \l {bodyColumn} property.

    \qml
    TwoLineDelegate {
        id: delegate
        text: "My delegate"

        Image {
            parent: delegate.bodyColumn
            source: "my-image.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    \endqml

    The delegate will adapt its height automatically but if the extra content
    has a fixed height, consider setting the \l {PaddedDelegate::minContentHeight}
    property to a more fitting value.

    Note: alternatively, you can also parent custom items to the
    \l {PaddedDelegate::centeredContainer} property. However, you can change
    column properties like spacing only through the \l {bodyColumn} property.

    \section2 Example

    \qml
    import QtQuick 2.0
    import Sailfish.Silica 1.0
    import Opal.Delegates 1.0

    DelegateColumn {
        model: ListModel {
            ListElement {
                name: "Jane Doe"
                post: "Hello there"
            }
            ListElement {
                name: "John Doe"
                post: "Goodbye again"
            }
        }
        delegate: D.OneLineDelegate {
            text: post
            description: name

            textLabel.wrapped: true
        }
    }
    \endqml

    \sa PaddedDelegate, OneLineDelegate, ThreeLineDelegate, OptionalLabel,
        DelegateIconItem, DelegateInfoItem, DelegateColumn
*/
PaddedDelegate {
    id: root
    minContentHeight: Theme.itemSizeMedium
                      - padding.effectiveTop
                      - padding.effectiveBottom
    centeredContainer: contentColumn

    /*!
      This property holds the primary text of the delegate.

      The text is shown vertically centered and is not
      wrapped by default. You can change that by changing
      the \l {OptionalLabel::wrapped} property.

      All texts are optional and will take up no space if
      they are empty.
    */
    property string text

    /*!
      This property holds the description text of the delegate.

      The text is shown below the primary text and is not
      wrapped by default. You can change that by changing
      the \l {OptionalLabel::wrapped} property.

      All texts are optional and will take up no space if
      they are empty.
    */
    property string description

    /*!
      This property gives access to the text label.

      You can use this property to customize all properties
      of the \l OptionalLabel item that is used
      for this text.
    */
    readonly property alias textLabel: _line1

    /*!
      This property gives access to the description label.

      You can use this property to customize all properties
      of the \l OptionalLabel item that is used
      for this text.
    */
    readonly property alias descriptionLabel: _line2

    /*!
      This property gives access to the body column at the center of the delegate.

      You can use this property to add extra contents to the delegate by
      parenting custom items to this property.

      See \l {Custom content items} for an example.
    */
    readonly property alias bodyColumn: contentColumn

    Column {
        id: contentColumn
        width: parent.width

        // Important: setting this here creates a binding loop
        // on the delegate's height property. Instead, use the
        // state mechanism provided by PaddedDelegate to automatically
        // center or un-center the item based on its size.
        // >>> anchors.verticalCenter: parent.verticalCenter

        OptionalLabel {
            id: _line1
            width: parent.width
            text: root.text
            font.pixelSize: Theme.fontSizeMedium

            palette {
                primaryColor: Theme.primaryColor
                highlightColor: Theme.highlightColor
            }
        }

        OptionalLabel {
            id: _line2
            width: parent.width
            text: root.description
            font.pixelSize: Theme.fontSizeSmall

            palette {
                primaryColor: Theme.secondaryColor
                highlightColor: Theme.secondaryHighlightColor
            }
        }
    }
}
