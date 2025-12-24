//@ This file is part of opal-dragdrop.
//@ https://github.com/Pretty-SFOS/opal-dragdrop
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.6
import Sailfish.Silica 1.0

/*!
    \qmltype DragHandle
    \inqmlmodule Opal.DragDrop
    \inherits SilicaItem
    \brief The visual handle to grab an item for drag and drop.

    \section2 This component

    This component is the visual handle that the user can grab to drag
    a list delegate to a new position.

    The visual handle as well as the \l DelegateDragHandler are added
    automatically when using \c Opal.Delegates. It has to be added
    manually to custom delegates that are not based on \c PaddedDelegate,
    like this:

    \qml
    ListItem {
        ...

        // This is already take care of when using Opal.Delegates.
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

    \section3 Sizing

    By default, the handle is roughly twice as wide as it is high. When
    building custom delegates, it is recommended to make the active area
    as large as possible to make it easier to grab the handle.

    Enable the \l showActiveArea property to show the clickable area
    while developing a delegate.

    When using \c Opal.Delegates, this is already taken care of for you.

    \section3 Visibility

    The handle will automatically hide itself when the \l ViewDragHandler
    is invalid or it is not active. Set the \c visible property to a custom
    value to change this behavior.

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
      This property holds the \l DelegateDragHandler for this delegate.

      Simply assign a new \l DelegateDragHandler instance to this
      property.

      \qml
        DragHandle {
            moveHandler: DelegateDragHandler {
                viewHandler: viewDragHandler
                handledItem: delegate
                modelIndex: index
            }
        }
      \endqml

      \sa DelegateDragHandler, ViewDragHandler
    */
    property DelegateDragHandler moveHandler

    /*!
      This property gives access to the handle icon.

      The \c Opal.DragDrop module provides a default icon
      for the handle. You can change this icon by setting
      \c handleImage.source to a custom url.
    */
    property alias handleImage: image

    /*!
      This property defines the vertical alignment of the icon.

      The clickable area is larger than the handle icon. This property
      defines the vertical alignment of the image inside of the
      clickable area.

      When designing delegates, it is recommended to align all
      contents equally. If your delegate's content is top aligned,
      then your handle should be top aligned as well.

      \sa verticalPadding, handleImage
    */
    property int verticalAlignment: Qt.AlignCenter

    /*!
      This property defines the padding above and below the icon.

      This padding is kept above or below the icon when it is top
      or bottom aligned. This property is ignored when the icon
      is vertically centered.

      \sa verticalAlignment, handleImage
    */
    property int verticalPadding: Theme.paddingMedium

    /*!
      This property can be used to show the clickable area for debugging.

      Set this to \c true to show the clickable area. The clickable area
      should be larger than the icon so that it is easy to grab the
      handle.
    */
    property bool showActiveArea: false

    /*!
      This property defines whether the drag handle icon is highlighted.

      This value is not inherited from the parent item. If the drag handle
      should be highlighted whent he parent is highlighted, you must create a
      manual binding.
    */
    property bool highlighted: false

    visible: !!moveHandler && moveHandler.active
    implicitWidth: visible ? Theme.itemSizeMedium : 0
    implicitHeight: visible ? Theme.itemSizeSmall - 2*Theme.paddingMedium : 0
    anchors.verticalCenter: parent ? parent.verticalCenter: undefined

    MouseArea {
        id: area
        anchors.fill: parent
        enabled: root.visible

        onPressed: moveHandler._startDrag()
        onReleased: moveHandler._stopDrag()
        onCanceled: moveHandler._stopDrag()

        drag.target: !!moveHandler ?
            (moveHandler.dragging ? moveHandler._draggableItem : null) : null
        drag.axis: Drag.YAxis
    }

    HighlightImage {
        id: image
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        source: Qt.resolvedUrl("private/icons/drag-handle.png")
        width: Theme.iconSizeMedium
        height: width
        highlighted: root.highlighted || moveHandler.dragging || area.containsPress

        states: [
            State {
                when: root.verticalAlignment === Qt.AlignTop
                AnchorChanges {
                    target: image
                    anchors {
                        top: parent.top
                        verticalCenter: undefined
                        bottom: undefined
                    }
                }
                PropertyChanges {
                    target: image
                    anchors.topMargin: verticalPadding
                }
            },
            State {
                when: root.verticalAlignment === Qt.AlignVCenter
                AnchorChanges {
                    target: image
                    anchors {
                        top: undefined
                        verticalCenter: parent.verticalCenter
                        bottom: undefined
                    }
                }
            },
            State {
                when: root.verticalAlignment === Qt.AlignBottom
                AnchorChanges {
                    target: image
                    anchors {
                        top: undefined
                        verticalCenter: undefined
                        bottom: parent.bottom
                    }
                }
                PropertyChanges {
                    target: image
                    anchors.bottomMargin: verticalPadding
                }
            }
        ]
    }

    // vvv DEBUG
    Rectangle {
        visible: showActiveArea
        anchors.fill: parent
        color: "red"
        opacity: 0.3
    }
    // ^^^ DEBUG
}
