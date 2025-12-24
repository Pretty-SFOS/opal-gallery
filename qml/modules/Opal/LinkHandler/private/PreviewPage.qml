//@ This file is part of opal-linkhandler.
//@ https://github.com/Pretty-SFOS/opal-linkhandler
//@ SPDX-FileCopyrightText: 2025 roundedrectangle
//@ SPDX-FileCopyrightText: 2025 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: root
    allowedOrientations: Orientation.All

    property url externalUrl

    property bool __linkhandler_webview: true
    property var __webview: null

    onStatusChanged: {
        if (status == PageStatus.Active) {
            __webview = Qt.createQmlObject("
                import QtQuick 2.2
                import Sailfish.WebView 1.0
                import Sailfish.Silica 1.0

                WebView {
                    anchors.fill: parent
                    opacity: 0.0
                    Behavior on opacity { FadeAnimation { duration: 300 } }
                    url: externalUrl
            }", root)
        } else if (__webview) {
            __webview.destroy()
        }
    }

    Connections {
        target: __webview
        onLoadProgressChanged: {
            if (__webview.loadProgress > 80) {
                __webview.opacity = 1.0
            }
        }
    }

    Component.onCompleted: {
        statusChanged()
    }
}
