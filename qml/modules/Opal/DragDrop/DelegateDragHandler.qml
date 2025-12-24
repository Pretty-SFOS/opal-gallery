//@ This file is part of opal-dragdrop.
//@ https://github.com/Pretty-SFOS/opal-dragdrop
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.6
import Sailfish.Silica 1.0

// Important: both the DragHandle and the DelegateDragHandler
// are object children of the delegate object, which can be destroyed
// by the view at any time. This creates numerous weird bugs.
//
// The following design decisions should minimize this problem:
// 1. The delegate position is updated each time handleScrolling()
//    is called. A itemMoved signal is sent which should be handled by the view.
// 2. Views should act on itemMoved. If saving is expensive, the updated
//    order should be saved on itemDropped. However, the actual item should
//    always be as close as possible to the dragged image.
// 3. There are no nice movement animations for the dragged image.
//    Adding those would be too much trouble.
// 4. A large cacheBuffer value is recommended to hold as many delegates
//    in memory as possible.
//
// It is not worth the effort to design even more workarounds for this
// memory management issue.

/*!
    \qmltype DelegateDragHandler
    \inqmlmodule Opal.DragDrop
    \inherits Item
    \brief The inner drag-and-drop handler for list delegates.

    \section2 This component

    This component glues the outer \l ViewDragHandler together with
    the visual \l DragHandle.

    The visual handle as well as the \l DelegateDragHandler are added
    automatically when using \c Opal.Delegates. It has to be added
    manually to custom delegates that are not based on \c PaddedDelegate,
    like this:

    \qml
    ListItem {
        ...

        // This is already taken care of when using Opal.Delegates.
        DragHandle {
            id: handle

            anchors {
                right: parent.right
                rightMargin: Theme.horizontalPageMargin
            }

            // The delegate needs its own drag handler that is
            // connected to the outer drag handler of the view.
            // The delegate drag handler must know the index
            // of the delegate.
            moveHandler: DelegateDragHandler {
                viewHandler: viewDragHandler
                handledItem: delegate
                modelIndex: index
            }
        }
    }
    \endqml

    Read on for a complete example.

    \section2 Drag and Drop

    This module add support for drag-and-drop ordering to QML list views.

    \b Prerequisites: your model must support moving items, either through
    the \c move method or via another manually defined route. Qt's
    \c ListModel implements the \c move method.

    This module only provides the visual part (i.e. the actual dragging
    and dropping of list elements) but not the backend part.

    \b Limitations: this module only works with \c ListView based views,
    that are optionally inside of a \c Flickable. Both \c SilicaListView
    and \c SilicaFlickable are supported.

    \section3 Architecture

    The module has three components:

    1. the outer \l ViewDragHandler that has to be defined as a child of
    the list view.

    2. the inner \l DelegateDragHandler that has to be defined on the delegate.

    3. the \l DragHandle that has to be placed in the delegate and is
    the only visual component.

    \section3 Usage

    It is recommended to use this module in combination with the \c Opal.Delegates
    module, which has built-in support for this module.

    \section4 With \c Opal.Delegates

    You only have to define a \l ViewDragHandler and hook it into the
    delegate when using delegates built with \c Opal.Delegates.

    \qml
    import QtQuick 2.0
    import Sailfish.Silica 1.0
    import Opal.Delegates 1.0
    import Opal.DragDrop 1.0

    Page {
        id: root
        allowedOrientations: Orientation.All

        ListModel {
            id: myModel
            ListElement { name: "Jane" }
            ListElement { name: "John" }
            ListElement { name: "Judy" }
        }

        SilicaListView {
            id: view
            model: myModel
            anchors.fill: parent
            header: PageHeader { title: "People" }
            VerticalScrollDecorator {}

            ViewDragHandler {
                id: viewDragHandler
                listView: view
            }

            delegate: OneLineDelegate {
                text: name
                dragHandler: viewDragHandler
            }
        }
    }
    \endqml

    \section4 With custom delegates

    When using custom delegates, you have to define an outer \l ViewDragHandler
    on the view and place a \l DragHandle in the delegate. The \l DragHandle
    defines a \l DelegateDragHandler.

    \qml
    import QtQuick 2.0
    import Sailfish.Silica 1.0
    import Opal.Delegates 1.0
    import Opal.DragDrop 1.0

    Page {
        id: root
        allowedOrientations: Orientation.All

        ListModel {
            id: myModel
            ListElement { name: "Jane" }
            ListElement { name: "John" }
            ListElement { name: "Judy" }
        }

        SilicaListView {
            id: view
            model: myModel
            anchors.fill: parent
            header: PageHeader { title: "People" }
            VerticalScrollDecorator {}

            ViewDragHandler {
                id: viewDragHandler
                listView: view
            }

            delegate: ListItem {
                id: delegate
                contentHeight: Theme.itemSizeSmall

                Label {
                    text: name
                    truncationMode: TruncationMode.Fade
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                        right: handle.left
                        rightMargin: Theme.paddingMedium
                    }
                }

                // Create a visual handle to grab the item, and connect
                // it to the drag handler of the view and the drag handler
                // of the delegate.
                //
                // This part is already taken care of when using Opal.Delegates.
                DragHandle {
                    id: handle

                    anchors {
                        right: parent.right
                        rightMargin: Theme.horizontalPageMargin
                    }

                    // The delegate needs its own drag handler that is
                    // connected to the outer drag handler of the view.
                    // The delegate drag handler must know the index
                    // of the delegate.
                    moveHandler: DelegateDragHandler {
                        viewHandler: viewDragHandler
                        handledItem: delegate
                        modelIndex: index
                    }
                }
            }
        }
    }
    \endqml

    \sa DragHandle, ViewDragHandler, DelegateDragHandler
*/
Item {
    id: root

    // Important: the type of this property must be QtObject
    // instead of ViewDragHandler, even though only a ViewDragHandler
    // object is acceptable here. Using the simpler type is
    // necessary to allow mixing objects created through importing
    // the module via its path and via the dot notation. QML treats
    // those objects as different types even though they are the same.

    /*!
      This property holds the \l ViewDragHandler that handles drags on this list.

      The \l ViewDragHandler must be defined outside of the delegate
      as a direct child of the list view. Assign its \c id to this property.

      \note the assigned value must be of type \c ViewDragHandler, even
      though the property is declared as \c QtObject.

      \sa ViewDragHandler
    */
    property QtObject /*ViewDragHandler*/ viewHandler

    /*!
      This property holds the delegate that is being handled.

      Assign the \c id of the \c ListItem to this property.
    */
    property Item handledItem

    /*!
      This property holds the index of the handled item.

      Assign the index of the delegate to this property.
      It is usually the \c index property, or it can be accessed
      through \c model.index or \c modelData.index.

      \defaultValue -1
    */
    property int modelIndex: -1

    /*!
      This property shows whether the \l ViewDragHandler is active.
    */
    readonly property bool active: !!viewHandler &&
        !!viewHandler.listView && viewHandler.active

    /*!
      This property shows whether the item is currently being dragged.
    */
    readonly property bool dragging: !!viewHandler &&
        !!viewHandler.listView && viewHandler.active &&
            viewHandler._originalIndex >= 0 ?
                viewHandler._originalIndex === _originalIndex : false

    // internal
    property int _originalIndex: -1
    property alias _draggableItem: _draggableItem
    property double _previousOpacity: 1.0

    readonly property var _listView: viewHandler.listView
    readonly property var _flickable: viewHandler.flickable

    function _findTargetIndex() {
        var finalIndex = -1
        var itemY = _draggableItem.y

        if (_listView === _flickable) {
            itemY = _draggableItem.mapToItem(_listView.contentItem, 0, 0).y
        }

        if (itemY < 0) {
            finalIndex = 0
        } else if (itemY + _draggableItem.height / 2 >
                   _listView.contentHeight) {
            finalIndex = _listView.indexAt(_listView.contentX,
                                           _listView.contentHeight - 1)
        } else {
            finalIndex = _listView.indexAt(
                _listView.contentX,
                itemY + _draggableItem.height / 2)
        }

        return finalIndex
    }

    function _startDrag() {
        if (!viewHandler) {
            console.error("[DelegateDragHandler] viewHandler must not be null, set it to a valid value")
            return
        } else if (!viewHandler.hasOwnProperty('__opal_view_drag_handler')) {
            console.error("[DelegateDragHandler] viewHandler must be a reference to a valid ViewDragHandler")
            return
        }

        _previousOpacity = handledItem.opacity
        _draggableItem.source = ''
        _draggableItem.width = handledItem.width
        _draggableItem.height = handledItem.height

        handledItem.grabToImage(function(result) {
            _draggableItem.source = result.url
            root._originalIndex = modelIndex
            viewHandler._draggedItem = _draggableItem
            viewHandler._originalIndex = modelIndex
        }, Qt.size(handledItem.width,
                   handledItem.height))
    }

    function _stopDrag() {
        if (dragging) {
            var finalIndex = _findTargetIndex()

            if (finalIndex >= 0) {
                if (finalIndex !== modelIndex) {
                    viewHandler.itemMoved(modelIndex, finalIndex)
                }

                if (finalIndex !== viewHandler._originalIndex) {
                    viewHandler.itemDropped(viewHandler._originalIndex, modelIndex, finalIndex)
                }
            }

            console.log("[DelegateDragHandler] stopped at", finalIndex,
                        "| moved from", viewHandler._originalIndex,
                        "via", modelIndex, "to", finalIndex)

            if (!!handledItem) {
                // the delegate may have been destroyed because it was
                // scrolled out of the visible area
                handledItem.opacity = _previousOpacity
            }

            viewHandler._draggedItem = null
            viewHandler._originalIndex = -1
            root._originalIndex = -1
            _draggableItem.source = ''
        }
    }

    function handleScrolling() {
        if (root.dragging) {
            var mappedY = _draggableItem.mapToItem(_flickable, 0, 0).y

            if (mappedY - _draggableItem.height < 0 &&
                _flickable.contentY > viewHandler._minimumFlickableY) {
                viewHandler._scrollUp()
            } else if (_flickable.contentY < viewHandler._maximumFlickableY &&
                       mappedY + _draggableItem.height * 3 / 2 > _flickable.height) {
                viewHandler._scrollDown()
            } else {
                viewHandler._stopScrolling()
            }

            var i = _findTargetIndex()
            if (i >= 0 && i !== root.modelIndex) {
                console.log("[DelegateDragHandler] move", root.modelIndex, "to", i)
                viewHandler.itemMoved(modelIndex, i)
            }
        }
    }

    ListView.onRemove: {
        if (!!handledItem) {
            animateRemoval(handledItem)
        }
    }

    Binding {
        when: dragging
        target: handledItem
        property: "opacity"
        value: 0.0
    }

    Image {
        id: _draggableItem
        anchors.horizontalCenter: parent.horizontalCenter
        width: handledItem.width
        height: handledItem.height
        visible: !!source.toString()
        onYChanged: handleScrolling()

        Connections {
            target: root.dragging && _flickable === _listView ? _flickable : null
            onContentYChanged: handleScrolling()
        }

        Rectangle {
            z: -100
            visible: _draggableItem.visible
            anchors.fill: parent
            color: Theme.highlightBackgroundColor
            opacity: Theme.highlightBackgroundOpacity
        }

        states: [
            State {
                name: "normal"
                when: !root.dragging && !!handledItem
                ParentChange {
                    target: _draggableItem
                    parent: handledItem.contentItem
                    rotation: 0
                    y: 0
                }
                PropertyChanges {
                    target: _draggableItem
                    opacity: 0.0
                }
            },
            State {
                name: "normalReset"
                when: !root.dragging && !handledItem
                ParentChange {
                    target: _draggableItem
                    parent: root
                    rotation: 0
                    y: 0
                }
                PropertyChanges {
                    target: _draggableItem
                    source: ''
                    width: 0
                    height: 0
                }
            },
            State {
                name: "dragging"
                when: root.dragging
                ParentChange {
                    target: _draggableItem
                    parent: _listView
                    rotation: 0
                    y: _draggableItem.mapToItem(_listView, 0, 0).y
                }
                PropertyChanges {
                    target: _draggableItem
                    opacity: 1.0
                }
            }
        ]
    }
}
