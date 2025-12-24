//@ This file is part of opal-delegates.
//@ https://github.com/Pretty-SFOS/opal-delegates
//@ SPDX-FileCopyrightText: 2023 Peter G. (nephros)
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Sailfish.Silica 1.0
import "private"

/*!
    \qmltype PaddedDelegate
    \inqmlmodule Opal.Delegates
    \inherits Sailfish.Silica.ListItem

    \brief Base type providing a \c ListItem intended to be used in views.

    This base type can be used for building custom list items that
    follow Silica styling with a simple API.

    The ready-made delegates \l OneLineDelegate, \l TwoLineDelegate, and
    \l ThreeLineDelegate are sufficient for most use-cases. Complex
    customizations are possible with these types, without having to
    develop a custom delegate.

    \section2 Anatomy

    The basic anatomy of a padded delegate is like this:

    \code
    +----------------------------------------------------------+
    |                        top padding                       |
    |         +--------------------------------------+         |
    | left    | left  |        content       | right | right   |
    | padding | item  |         item         | item  | padding |
    |         +--------------------------------------+         |
    |                      bottom padding                      |
    +----------------------------------------------------------+
    \endcode

    All contents that are added as direct children of the \l PaddedDelegate
    component are inserted into the content item in the center of the
    delegate.

    Custom contents can be added to the left and the right of the item.

    The default padding adds the standard page margin to both sides and
    standard spacing between delegates. These values usually don't have to be
    changed unless you know what you are doing.

    \section2 Custom content alignment

    When building a custom delegate that should have vertically centered content,
    make sure to put all custom content into a container like \c Column.
    Do not set its vertical center anchor! Instead, assign the container to the
    \l centeredContainer property.

    This makes sure that the container is vertically centered without causing
    any binding loops on the item's height.

    The vertical alignment of side items can be changed through the
    \l leftItemAlignment and \l rightItemAlignment properties. Side items are
    vertically centered by default. Their horizontal alignment is managed through
    the items themselves. See e.g. \l {DelegateInfoItem::alignment}.

    \section2 Example

    \note Usually, it is recommended to use the provided implementations for new
    delegates.

    \qml
    import QtQuick 2.6
    import Sailfish.Silica 1.0
    import Opal.Delegates 1.0

    PaddedDelegate {
        id: root

        property int temperature
        property string text

        minContentHeight: Theme.itemSizeSmall
        centeredContainer: contentContainer
        interactive: false

        leftItem: DelegateIconItem {
            source: "image://theme/icon-m-favorite"
        }

        rightItem: DelegateInfoItem {
            title: qsTr("Temperature")
            text: temperature
            description: qsTr("°C")
            fixedWidth: S.Theme.itemSizeLarge
        }

        Column {
            // Note: all contents are placed inside a column to avoid
            // a binding loop on the delegate's height property.
            // Directly setting the label as the centeredContainer does
            // not work.
            id: contentContainer
            width: parent.width

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
        }
    }
    \endqml

    \sa OneLineDelegate, TwoLineDelegate, ThreeLineDelegate, DelegateColumn
*/
ListItem {
    id: root

    /*!
      This property defines whether delegates will be emphasized with alternating colors.

      If \c true, delegates will use alternating background colors
      to make rows visually more distinct.

      It is better design to make delegates look clear and easily
      distinguishable on their own. This feature is intended as a last resort,
      or for special cases.

      \defaultValue false

      \sa oddColor, evenColor, emphasisBackground
    */
    property bool showOddEven: false

    /*!
      Background color for odd elements.

      This value is only used if \l showOddEven is set to \c true.

      \defaultValue "transparent"
    */
    property color oddColor: "transparent"

    /*!
      Background color for even elements.

      This value is only used if \l showOddEven is set to \c true.

      \defaultValue Theme.rgba(Theme.highlightBackgroundColor, Theme.opacityLow)
    */
    property color evenColor: Theme.rgba(Theme.highlightBackgroundColor, Theme.opacityLow)

    /*!
      Background rectangle for emphasizing rows.

      This item is only used if \l showOddEven is set to \c true. You can
      use this to customize the background further, beyond simply changing its
      color.

      \sa showOddEven, oddColor, evenColor
    */
    property alias emphasisBackground: emphasisBackground

    // internal
    property bool _isOddRow: typeof index !== 'undefined' && (index % 2 != 0)

    // internal
    readonly property int _modelIndex: typeof index !== 'undefined' ? index : -1

    /*!
      This property defines whether the delegate is interactive.

      Setting this to \c false will switch to non-interactive
      styling. This means \l highlighted will be set to \c true.

      \note context menu and click signals are still
      handled. To avoid confusion, do not set the \c onClicked
      or \c menu properties for non-interactive delegates.

      \defaultValue true
    */
    property bool interactive: true

    /*!
      This property defines an optional custom content item.

      Assign any visual item here to add extra content to the
      left side of the delegate.

      The vertical alignment of side items can be changed through
      the \l rightItemAlignment and \l leftItemAlignment properties.

      If the side item has a property called \c _delegate, it will
      be bound to the delegate object automatically. Important: the
      property type must be \c var or the app will crash.

      \note it takes up no space if left undefined.

      \sa rightItem, leftItemAlignment, DelegateIconItem, DelegateInfoItem, DelegateIconButton
    */
    property Component leftItem: null

    /*!
      This property provides access to the loader for the left side item.

      Side items (\l leftItem and \l rightItem) are loaded independently
      of the delegate's main content. If \l loadSideItemsAsync is \c true,
      side items will be loaded asynchronously.

      This property gives access to the \c Loader instance for this
      side item. You can access the loaded item once it is ready via
      the \c {Loader.item} property. Make sure the item is loaded before
      accessing it, by verifying the loader's \c status property is
      \c {Loader.Ready}.

      \sa leftItem, rightItem, leftItemLoader, rightItemLoader, loadSideItemsAsync
    */
    readonly property alias leftItemLoader: leftItemLoader

    /*!
      This property gives access to the central content item.

      All children of \l PaddedDelegate will be parented to
      this item. You can use this property to manually parent
      content to it.

      It is usually not necessary to change any properties
      of this item.
    */
    readonly property alias centerItem: centerItem

    /*!
      This property defines an optional custom content item.

      Assign any visual item here to add extra content to the
      right side of the delegate.

      The vertical alignment of side items can be changed through
      the \l rightItemAlignment and \l leftItemAlignment properties.

      If the side item has a property called \c _delegate, it will
      be bound to the delegate object automatically. Important: the
      property type must be \c var or the app will crash.

      \note it takes up no space if left undefined.

      \sa leftItem, rightItemAlignment, DelegateIconItem, DelegateInfoItem, DelegateIconButton
    */
    property Component rightItem: null

    /*!
      This property provides access to the loader for the right side item.

      Side items (\l leftItem and \l rightItem) are loaded independently
      of the delegate's main content. If \l loadSideItemsAsync is \c true,
      side items will be loaded asynchronously.

      This property gives access to the \c Loader instance for this
      side item. You can access the loaded item once it is ready via
      the \c {Loader.item} property. Make sure the item is loaded before
      accessing it, by verifying the loader's \c status property is
      \c {Loader.Ready}.

      \sa leftItem, rightItem, leftItemLoader, rightItemLoader, loadSideItemsAsync
    */
    readonly property alias rightItemLoader: rightItemLoader

    /*!
      This property can be used to load side items asynchronously.

      Settings this to \c true will load side items in a separate
      thread. This is useful if your custom content items are
      very complex and take a long time to load.

      However, this can mess up the size of your delegates. When
      using this feature, take care to engineer your delegates
      to not change their size.

      In other words: make sure that the side items are not taller
      than the height defined in \l minContentHeight, and make sure
      to set the \c fixedWidth property of your side items.

      \defaultValue false

      \sa leftItem, rightItem, DelegateIconItem, DelegateInfoItem
    */
    property bool loadSideItemsAsync: false

    /*!
      This property gives access to the central content item.

      All children of \l PaddedDelegate will be parented to
      this item. You can use this property to manually parent
      content to it.

      It is usually not necessary to change any properties
      of this item.
    */
    default property alias contents: centerItem.data

    /*!
      This property enables centering of the delegate's contents.

      When building a custom delegate that should have vertically centered content,
      make sure to put all custom content into a container like \c Column.
      Do not set its vertical center anchor! Instead, assign the container to the
      \l centeredContainer property.

      This makes sure that the container is vertically centered without causing
      any binding loops on the item's height.
    */
    property var centeredContainer

    /*!
      This property defines the minimum height of the delegate.

      The delegate may grow and shrink to fit its content but it
      will never shrink below this height.

      \defaultValue Theme.itemSizeMedium
    */
    property int minContentHeight: Theme.itemSizeMedium

    /*!
      This property defines the space between side items and content.

      If a left or right side item is defined, then this will
      be the spacing between the side items and the content.

      This value is ignored if no side items are defined.

      \defaultValue Theme.paddingMedium

      \sa leftItem, rightItem
    */
    property int spacing: Theme.paddingMedium

    /*!
      This property defines the vertical alignment of the right side item.

      Allowed values are \l Qt.AlignVCenter, \l Qt.AlignTop,
      and \l Qt.AlignBottom.

      \defaultValue Qt.AlignVCenter

      \sa leftItem, rightItem, dragHandleAlignment
    */
    property int rightItemAlignment: Qt.AlignVCenter

    /*!
      This property defines the vertical alignment of the left side item.

      Allowed values are \l Qt.AlignVCenter, \l Qt.AlignTop,
      and \l Qt.AlignBottom.

      \defaultValue Qt.AlignVCenter

      \sa leftItem, rightItem, dragHandleAlignment
    */
    property int leftItemAlignment: Qt.AlignVCenter

    /*!
      This group defines the outer padding around the delegate.

      See \l PaddingData for details.

      \sa PaddingData, PaddedDelegate
    */
    readonly property PaddingData padding: PaddingData {
        readonly property int __defaultLeftRight: Theme.horizontalPageMargin
        readonly property int __defaultTopBottom: Theme.paddingSmall

        leftRight: all === _undefinedValue && (left === _undefinedValue || right === _undefinedValue) ? __defaultLeftRight : NaN
        topBottom: all === _undefinedValue && (top === _undefinedValue || bottom === _undefinedValue) ? __defaultTopBottom : NaN
    }

    /*!
      This property registers the list view's drag handler to enable drag and drop.

      Set this property to a reference to a valid \c ViewDragHandler instance
      from the \c Opal.DragDrop module. Sorting items is then possible by grabbing
      them by the automatically added drag handle.

      When the drag handler is active, the right side item is hidden and the
      delegate shows the grab handle instead. This behavior can be changed
      by setting \l hideRightItemWhileDragging to \c false.

      \note this only works if the delegate lives in a \c SilicaListView
      or plain \c ListView.

      \sa hideRightItemWhileDragging, draggable
    */
    property Item /*ViewDragHandler*/ dragHandler: null

    readonly property Item _effectiveDragHandler: !!dragHandler
        && dragHandler.hasOwnProperty('__opal_view_drag_handler') ?
            dragHandler : null

    /*!
      This property defines the vertical alignment of the drag handle.

      This value has no effect if drag and drop is not enabled on this
      delegate. See \l dragHandler for details.

      Allowed values are \l Qt.AlignVCenter, \l Qt.AlignTop,
      and \l Qt.AlignBottom.

      The default value depends on the value of \l leftItemAlignment and
      \l rightItemAlignment. If either is set to \c Qt.AlignTop, the drag
      handle will also default to \c Qt.AlignTop. Otherwise, the default
      is \c Qt.AlignVCenter.

      \defaultValue Qt.AlignVCenter

      \sa dragHandler, leftItem, rightItem
    */
    property int dragHandleAlignment: leftItemAlignment === Qt.AlignTop ||
        rightItemAlignment === Qt.AlignTop ? Qt.AlignTop : Qt.AlignVCenter

    /*!
      This property defines whether to use the default grab handle.

      Set this property to \c false if you want to implement a custom drag handle.
      See the \c Opal.DragDrop documentation for how to use \c DragHandle.
    */
    property bool enableDefaultGrabHandle: true

    /*!
      This property defines whether the right side item is hidden while dragging.

      When the drag handler is active, the right side item is hidden and the
      delegate shows the grab handle instead. This behavior can be changed
      by setting \l hideRightItemWhileDragging to \c false.

      When this property is set to \c false, the grab handle is shown to the
      left of the right side item.

      \sa dragHandler, draggable
    */
    property bool hideRightItemWhileDragging: enableDefaultGrabHandle

    /*!
      This property shows whether the item is draggable.

      The item can be moved by drag and drop when a valid drag handler is
      registered, and the drag handler is set to be active.
    */
    readonly property bool draggable:    !!_effectiveDragHandler
                                      && !!_effectiveDragHandler.active

    /*!
      This function toggles text wrapping in text labels.

      Provide a \l OptionalLabel as \a label argument to toggle its
      text wrapping mode.

      You can also manually set the \l {OptionalLabel::wrapped}
      property.

      \sa OptionalLabel
    */
    function toggleWrappedText(label) {
        label.wrapped = !label.wrapped
    }

    opacity: enabled ? 1.0 : Theme.opacityLow

    Binding on highlighted {
        when: !interactive
        value: true
    }

    Binding on _backgroundColor {
        when: !interactive
        value: "transparent"
    }

    contentHeight: hidden ? 0 : Math.max(
          topPaddingItem.height
        + bottomPaddingItem.height
        + Math.max(leftItemLoader.height,
                   rightItemLoader.height,
                   centerItem.height)
        , minContentHeight
    )

    Item {
        id: topPaddingItem
        anchors.bottom: centerItem.top
        width: root.width
        height: padding.effectiveTop
    }

    Item {
        id: bottomPaddingItem
        anchors.top: centerItem.bottom
        width: root.width
        height: padding.effectiveBottom
    }

    Item {
        id: leftPaddingItem
        anchors.left: parent.left
        width: padding.effectiveLeft
        height: contentHeight
    }

    Item {
        id: rightPaddingItem
        anchors.right: parent.right
        width: padding.effectiveRight
        height: contentHeight
    }

    Loader {
        id: leftItemLoader
        sourceComponent: leftItem
        asynchronous: loadSideItemsAsync
        anchors {
            left: leftPaddingItem.right
            verticalCenter: parent.verticalCenter
        }

        property Item __padded_delegate: root

        Binding {
            target: !!leftItemLoader.item &&
                    leftItemLoader.item.hasOwnProperty('_delegate') ?
                        leftItemLoader.item : null
            property: "_delegate"
            value: root
        }

        states: [
            State {
                when: leftItemAlignment == Qt.AlignVCenter
                AnchorChanges {
                    target: leftItemLoader
                    anchors.verticalCenter: leftItemLoader.parent.verticalCenter
                    anchors.top: undefined
                    anchors.bottom: undefined
                }
            },
            State {
                when: leftItemAlignment == Qt.AlignTop
                AnchorChanges {
                    target: leftItemLoader
                    anchors.verticalCenter: undefined
                    anchors.top: topPaddingItem.bottom
                    anchors.bottom: undefined
                }
            },
            State {
                when: leftItemAlignment == Qt.AlignBottom
                AnchorChanges {
                    target: leftItemLoader
                    anchors.verticalCenter: undefined
                    anchors.top: undefined
                    anchors.bottom: bottomPaddingItem.top
                }
            }
        ]
    }

    Loader {
        id: rightItemLoader
        visible: !hideRightItemWhileDragging || !dragHandleLoader.visible
        sourceComponent: rightItem
        asynchronous: loadSideItemsAsync
        anchors {
            right: rightPaddingItem.left
            verticalCenter: parent.verticalCenter
        }

        property Item __padded_delegate: root

        Binding {
            target: !!rightItemLoader.item &&
                    rightItemLoader.item.hasOwnProperty('_delegate') ?
                        rightItemLoader.item : null
            property: "_delegate"
            value: root
        }

        states: [
            State {
                when: rightItemAlignment == Qt.AlignVCenter
                AnchorChanges {
                    target: rightItemLoader
                    anchors.verticalCenter: rightItemLoader.parent.verticalCenter
                    anchors.top: undefined
                    anchors.bottom: undefined
                }
            },
            State {
                when: rightItemAlignment == Qt.AlignTop
                AnchorChanges {
                    target: rightItemLoader
                    anchors.verticalCenter: undefined
                    anchors.top: topPaddingItem.bottom
                    anchors.bottom: undefined
                }
            },
            State {
                when: rightItemAlignment == Qt.AlignBottom
                AnchorChanges {
                    target: rightItemLoader
                    anchors.verticalCenter: undefined
                    anchors.top: undefined
                    anchors.bottom: bottomPaddingItem.top
                }
            }
        ]
    }

    Loader {
        id: dragHandleLoader
        visible: enableDefaultGrabHandle && status === Loader.Ready && draggable

        // set as context for the drag handle
        // The values must be passed on like this because it is
        // not possible to set properties of the source component.
        // We cannot use a Component because it is possible that
        // the app developer chose not to install the DragDrop
        // module, in which case loading would fail fatally. When
        // loading by URL, it is non-fatal if loading fails.
        property QtObject viewHandler: _effectiveDragHandler
        property Item handledItem: root
        property int modelIndex: root._modelIndex

        source: !!_effectiveDragHandler && enableDefaultGrabHandle ?
            Qt.resolvedUrl("private/OptionalDragHandle.qml") : ""
        asynchronous: false

        height: contentHeight
        anchors {
            right: rightItemLoader.left
            rightMargin: rightItemLoader.width > 0 ? root.spacing : 0
            top: parent.top
        }

        Binding {
            target: !!dragHandleLoader.item &&
                    dragHandleLoader.item.hasOwnProperty('_delegate') ?
                        dragHandleLoader.item : null
            property: "_delegate"
            value: root
        }

        states: [
            State {
                when: !rightItemLoader.visible
                AnchorChanges {
                    target: dragHandleLoader
                    anchors.right: rightPaddingItem.left
                }
                PropertyChanges {
                    target: dragHandleLoader
                    anchors.rightMargin: 0
                }
            }
        ]
    }

    SilicaItem {
        id: centerItem
        height: Math.max(minContentHeight, childrenRect.height)

        anchors {
            left: leftItemLoader.right
            leftMargin: leftItemLoader.width > 0 ? spacing : 0
            right: rightItemLoader.left
            rightMargin: rightItemLoader.width > 0 ? spacing : 0
            verticalCenter: parent.verticalCenter
        }

        states: State {
            when: dragHandleLoader.visible
            AnchorChanges {
                target: centerItem
                anchors.right: dragHandleLoader.left
            }
            PropertyChanges {
                target: centerItem
                anchors.rightMargin: dragHandleLoader.width > 0 ? spacing : 0
            }
        }
    }

    Rectangle {
        id: emphasisBackground
        anchors.fill: parent

        visible: showOddEven
        radius: 0
        opacity: Theme.opacityFaint
        color: _isOddRow ? oddColor : evenColor
    }

    states: [
        State {
            name: "tall"
            when: !!centeredContainer &&
                  (   centeredContainer.height > minContentHeight
                   || centeredContainer.implicitHeight > minContentHeight
                   || centeredContainer.childrenRect.height > minContentHeight)

            AnchorChanges {
                target: centeredContainer
                anchors {
                    verticalCenter: undefined
                    top: centeredContainer.parent.top
                }
            }
        },
        State {
            name: "short"
            when: !!centeredContainer &&
                  (   centeredContainer.height <= minContentHeight
                   || centeredContainer.implicitHeight <= minContentHeight
                   || centeredContainer.childrenRect.height <= minContentHeight)

            AnchorChanges {
                target: centeredContainer
                anchors {
                    top: undefined
                    verticalCenter: centeredContainer.parent.verticalCenter
                }
            }
        }
    ]
}
