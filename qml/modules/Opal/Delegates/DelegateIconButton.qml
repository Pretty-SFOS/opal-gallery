//@ This file is part of opal-delegates.
//@ https://github.com/Pretty-SFOS/opal-delegates
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Sailfish.Silica 1.0

/*!
    \qmltype DelegateIconButton
    \inqmlmodule Opal.Delegates
    \inherits Sailfish.Silica.HighlightImage

    \brief Item for adding a clickable icon to a delegate.

    This item can be used to add a clickable icon button as a delegate's
    \l {PaddedDelegate::leftItem} or \l {PaddedDelegate::rightItem}.

    Icon and text are both optional and the item will resize accordingly.
    It will become invisible if neither icon nor text are defined.

    The width will grow to fit the whole text on one line by default.
    This can be changed by setting the \c width property to a fixed
    value. In this case, the text will be wrapped and shrunk to fit
    as tightly as possible.

    The icon size must be set through the \l iconSize property and not
    by changing properties of \l icon or \l iconButton. Otherwise the
    sizing of the whole item will break.

    \note the side item will stay interactive even if the delegate
    is set to be not interactive.

    Example:

    \qml
    OneLineDelegate {
        text: "My project"
        interactive: false

        rightItem: DelegateIconButton {
            iconSource: "image://theme/icon-s-setting"
        }
    }
    \endqml

    \sa PaddedDelegate, DelegateInfoItem
*/
SilicaItem {
    id: root

    /*!
      This property defines the icon.

      Set the size of the icon via the \l iconSize property.

      See the Sailfish icon reference for icons that are available
      by default.

      \note in Silica, icons are usually set via the \c {icon.source}
      grouped property. In this component, you must use \l iconSource.

      \sa iconSize, text, icon
    */
    property url iconSource

    /*!
      This property defines the size of the icon.

      Note that setting the size of the whole element does not
      influence the size of the icon button. Set this property
      to a sane value or leave it at the default.

      \defaultValue Theme.iconSizeMedium

      \sa iconSource, text, icon
    */
    property alias iconSize: button.width

    /*!
      This property defines an optional description for the button.

      If no fixed width is defined, the item will grow to contain all text.
      If the item's width is fixed, the text will shrink to a minimum size
      and then wrap to fit into the given space.

      \sa iconSource, iconSize, textLabel
    */
    property alias text: label.text

    /*!
      This property gives access to the internal icon element.

      Do not set size or source via this property. Use \l iconSize
      and \l iconSource instead.

      \sa iconSize, iconSource, iconButton
    */
    property alias icon: button.icon

    /*!
      This property gives access to the internal button element.

      Do not change properties here unless you know what you are doing.

      \sa iconSource, text
    */
    property alias iconButton: button

    /*!
      This property gives access to the internal label element.

      Do not change properties here unless you know what you are doing.

      \sa iconSource, text
    */
    property alias textLabel: label

    /*!
      This property gives access to the parent delegate.

      The \c __padded_delegate variable is put into the context
      by the side item loader, if this component is used as a
      side item in a padded delegate.

      \internal
    */
    property Item _delegate: !!parent && parent._delegate ?
        parent._delegate : (__padded_delegate || null)

    /*!
      This signal is emitted when the button is clicked.
    */
    signal clicked(var mouse)

    /*!
      This signal is emitted when the button is held pressed for some time.
    */
    signal pressAndHold(var mouse)

    width: Math.max(label.implicitWidth, button.width)
    height: Math.max(button.height + label.effectiveHeight,
                     (!!_delegate && _delegate.minContentHeight ?
                         _delegate.minContentHeight : 0))
    highlighted:    area.pressed
                 || button.down
                 || (!! _delegate
                     && _delegate.interactive
                     && _delegate.down)
                 || (!! _delegate
                     && _delegate.menuOpen)
    enabled: !!_delegate ? _delegate.enabled : true

    MouseArea {
        id: area
        z: -100
        anchors.fill: parent
        enabled: root.enabled

        onClicked: {
            root.clicked(mouse)
        }
        onPressAndHold: {
            root.clicked(mouse)
        }
    }

    SilicaItem {
        id: body
        width: parent.width
        height: button.height + label.effectiveHeight
        anchors.verticalCenter: parent.verticalCenter

        IconButton {
            id: button
            width: !!iconSource.toString() ? Theme.iconSizeMedium : 0
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            icon.fillMode: Image.PreserveAspectFit
            icon.source: iconSource
            enabled: root.enabled

            onClicked: {
                root.clicked(mouse)
            }
            onPressAndHold: {
                root.clicked(mouse)
            }

            Binding on highlighted {
                when: area.pressed || root.highlighted
                value: true
            }
        }

        OptionalLabel {
            id: label

            property int effectiveHeight: 0

            width: parent.width
            font.pixelSize: Theme.fontSizeExtraSmall
            fontSizeMode: Text.HorizontalFit
            minimumPixelSize: 0.8 * Theme.fontSizeTiny
            wrapped: true
            highlighted: root.highlighted
            horizontalAlignment: Text.AlignHCenter

            anchors {
                top: button.bottom
                topMargin: !!text ? Theme.paddingSmall : 0
                horizontalCenter: parent.horizontalCenter
            }

            // This is a hackish workaround for calculating the
            // effective height of the element. When using Text.Fit
            // as font size mode, the text will use less space but
            // the height of the label is still calculated as if the
            // text were laid out using the default font size.
            // We fix this without binding loops by reacting to the
            // actual layouting.
            onLineLaidOut: {
                if (line.isLast && !!text) {
                    effectiveHeight = line.y + line.height + anchors.topMargin
                }
            }

            Binding on effectiveHeight {
                when: text == ''
                value: 0
            }
        }
    }
}
