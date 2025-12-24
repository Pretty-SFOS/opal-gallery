//@ This file is part of opal-delegates.
//@ https://github.com/Pretty-SFOS/opal-delegates
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.6

// Important: the DragDrop module must be imported
// via its path and not using the dot notation in
// case the app developer has not enabled Opal dot imports.
//
// This import path assumes that modules are installed to qml/modules/Opal/.
import "../../DragDrop"

DragHandle {
    id: root

    // required as context variables:
    //   viewHandler, handledItem, modelIndex
    property QtObject __viewHandler: viewHandler
    property Item __handledItem: handledItem
    property int __modelIndex: modelIndex

    // set by PaddedDelegate
    property var _delegate

    verticalPadding: {
        if (!_delegate) {
            return 0
        } else if (_delegate.dragHandleAlignment === Qt.AlignTop) {
            return _delegate.padding.effectiveTop
        } else if (_delegate.dragHandleAlignment === Qt.AlignBottom) {
            return _delegate.padding.effectiveBottom
        } else {
            return 0
        }
    }

    verticalAlignment: !!_delegate ?
        _delegate.dragHandleAlignment : Qt.AlignVCenter

    highlighted: !! _delegate && (
                     (   _delegate.interactive
                      && _delegate.down) ||
                     (_delegate.menuOpen))

    moveHandler: DelegateDragHandler {
        id: handler
        viewHandler: __viewHandler
        handledItem: __handledItem
        modelIndex: __modelIndex
    }
}
