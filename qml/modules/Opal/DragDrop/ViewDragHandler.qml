//@ This file is part of opal-dragdrop.
//@ https://github.com/Pretty-SFOS/opal-dragdrop
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.6
import Sailfish.Silica 1.0

/*!
    \qmltype ViewDragHandler
    \inqmlmodule Opal.DragDrop
    \inherits Item
    \brief The outer drag-and-drop handler for the list view.

    \section2 This component

    This component is the outer handler which has to be defined in the
    list view like this:

    \qml
    SilicaListView {
        id: view
        ...

        ViewDragHandler {
            id: viewDragHandler
            listView: view
        }
    }
    \endqml

    Read on for a complete example.

    \section2 Drag and Drop

    This module add support for drag-and-drop ordering to QML list views.

    Prerequisites: your model must support moving items, either through
    the \c move method or via another manually defined route. Qt's
    \c ListModel implements the \c move method.

    This module only provides the visual part (i.e. the actual dragging
    and dropping of list elements) but not the backend part.

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

    /*!
      This property holds the list view that is being handled.

      Define the \l ViewDragHandler as a direct child of the list view,
      then assign the list view's \c id to this property.

      \qml
      SilicaListView {
          id: view

          ViewDragHandler {
              listView: view
          }
      }
      \endqml

      When using lists inside of a \c SilicaFlickable, you have to assign
      the \c id of the main flickable to the \l flickable property, and
      the \c id of the \c SilicaListView to the \l listView property.

      \sa flickable, smartScrollbar, active
    */
    property Item /*ListView*/ listView

    /*!
      This property optionally holds a reference to the main flickable.

      Usually in Sailfish apps, the \c SilicaListView fills the whole page
      and is the main flickable area of the page.

      When using lists inside of a \c SilicaFlickable, you have to assign
      the \c id of the main flickable to the \l flickable property, and
      the \c id of the \c SilicaListView to the \l listView property.

      \qml
      SilicaFlickable {
          id: flick
          anchors.fill: parent

          SilicaListView {
              id: view
              height: 800

              ViewDragHandler {
                  listView: view
                  flickable: flick
              }

              ...
          }
      }
      \endqml
    */
    property Flickable flickable: !!listView ? listView : null

    /*!
      This property optionally disables a smart scrollbar while dragging.

      Interactive scrollbars built with \c Opal.SmartScrollbar can get in
      the way when dragging items. Especially when the drag handle is on the
      same side as the scrollbar, it can be difficult to grab the handle instead
      of the scrollbar.

      Assign the \c id of the smart scrollbar to this property to automatically
      disable it while the handler is active.

      \note make sure to manually manage the \l active property when using
      this feature.

      \sa active
    */
    property QtObject smartScrollbar

    /*!
      This property defines whether the handler is active.

      When the handler is inactive, no signals are sent, and drag handles
      will be hidden by default.

      The handler will always be inactive when the \l listView property is invalid.

      By default, it will always be active when the \l listView is valid.
      Make sure to manually enable/disable the handler when using a smart scrollbar.

      \sa smartScrollbar
    */
    property bool active: !!listView

    /*!
      This property defines whether moves are handled automatically.

      Disable this property to manually handles \l itemMoved signals.

      \sa itemMoved
    */
    property bool handleMove: true

    /*!
      This property defines the default list view cache buffer.

      Increasing this value can improve scrolling performance but
      may increase loading times. The \l ViewDragHandler increases
      this value by default to make dragging over the screen edge
      faster.

      Set this value to zero to keep the system default.

      See the documentation of \c ListView.cacheBuffer for details.

      \defaultValue 20 * Screen.height
    */
    property int listViewCacheBuffer: 20 * Screen.height

    /*!
      This signal is emitted when a delegate is dragged over a new index.

      This signal is emitted every time the delegate reaches a new
      valid position but the drag has not ended.

      By default, the model's \c move(fromIndex, toIndex, 1) method
      is called for this signal. Set \l handleMove to \c false to disable
      automatic handling of this signal.

      \note always make sure that the dragged item is as close as possible
      to the current drag position. In other words: always handle this
      signal. Otherwise you will encounter difficult bugs.

      When saving item positions to disk, it is advisable to implement
      a quick visual-only way to move items, and only actually save positions
      when the \l itemDropped signal is sent.

      \sa itemDropped
    */
    signal itemMoved(var fromIndex, var toIndex)

    /*!
      This signal is emitted when a delegate has been dropped at a new position.

      This signal is emitted only once for a drag-and-drop action.

      \sa itemMoved
    */
    signal itemDropped(var originalIndex, var currentIndex, var finalIndex)


    // internal API
    property Item _draggedItem
    property int _originalIndex: -1
    readonly property bool _scrolling: scrollUpTimer.running || scrollDownTimer.running

    readonly property int _minimumFlickableY: {
        if (!flickable || !listView || !_draggedItem) return 0

        if (flickable === listView) {
            return !!listView.headerItem ? -listView.headerItem.height : 0
        } else {
            var base = flickable.contentY + listView.mapToItem(flickable, 0, 0).y
            return base - _draggedItem.height * 3 / 2
        }
    }
    readonly property int _maximumFlickableY: {
        if (!flickable || !listView || !_draggedItem) return 0

        if (flickable === listView) {
            return   listView.contentHeight
                   - listView.height
                   - (!!listView.headerItem ? listView.headerItem.height : 0)
        } else {
            var base =   flickable.contentY
                       + listView.mapToItem(flickable, 0, 0).y
                       + listView.height
                       - flickable.height
            return Math.min(
                base + _draggedItem.height,
                flickable.contentHeight)
        }
    }

    // internal
    // used to identify an object as a valid view drag handler
    readonly property bool __opal_view_drag_handler: true


    function _scrollUp() {
        scrollUpTimer.start()
        scrollDownTimer.stop()
    }

    function _scrollDown() {
        scrollUpTimer.stop()
        scrollDownTimer.start()
    }

    function _stopScrolling() {
        scrollUpTimer.stop()
        scrollDownTimer.stop()
    }

    function _setListViewProperties() {
        if (!listView) return
        listView.moveDisplaced = moveDisplaced
    }

    onItemMoved: {
        if (!handleMove) return
        listView.model.move(fromIndex, toIndex, 1)
    }

    onListViewChanged: {
        _setListViewProperties()
    }

    onListViewCacheBufferChanged: {
        if (!!listView
                && listView.hasOwnProperty('cacheBuffer')
                && listViewCacheBuffer > 0) {
            listView.cacheBuffer = listViewCacheBuffer
        }
    }

    implicitWidth: 0
    implicitHeight: 0

    Binding {
        target: smartScrollbar
        property: "smartWhen"
        value: false
        when: !!flickable && root.active
    }

    Transition {
        id: moveDisplaced

        NumberAnimation {
            properties: "x,y"
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    Timer {
        id: scrollUpTimer
        repeat: true
        interval: 10
        onTriggered: {
            if (!_draggedItem) {
                stop()
                return
            }

            if (flickable.contentY > _minimumFlickableY) {
                flickable.contentY -= 15

                if (flickable !== listView) {
                    _draggedItem.y -= 15
                }
            } else {
                stop()
                // flickable.contentY = 0
                // _draggedItem.y = 0
            }
        }
    }

    Timer {
        id: scrollDownTimer
        repeat: true
        interval: 10
        onTriggered: {
            if (!_draggedItem) {
                stop()
                return
            }

            if (flickable.contentY < _maximumFlickableY) {
                flickable.contentY += 15

                if (flickable !== listView) {
                    _draggedItem.y += 15
                }
            } else {
                stop()
                // flickable.contentY = _maximumFlickableY
                // _draggedItem.y = _maximumFlickableY
            }
        }
    }

    Component.onCompleted: {
        _setListViewProperties()
    }
}
