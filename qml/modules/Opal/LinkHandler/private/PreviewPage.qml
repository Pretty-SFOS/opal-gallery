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
                    privateMode: true
            }", root)

            spinnerTimeout.restart()
            timeout.restart()
        } else if (!!__webview) {
            __webview.stop()
            __webview.destroy()
            loadSpinner.running = false
            spinnerTimeout.stop()
            timeout.stop()
        }
    }

    BusyLabel {
        id: loadSpinner
        running: false
    }

    SilicaFlickable {
        id: previewFailed
        anchors.fill: parent
        visible: false

        ViewPlaceholder {
            enabled: true
            text: qsTranslate("Opal.LinkHandler", "No preview available.")
            hintText: qsTranslate("Opal.LinkHandler", "The page is taking too long to load.")
        }
    }

    Timer {
        id: timeout
        interval: 10*1000
        running: false
        onTriggered: {
            if (!!__webview && !__webview.loaded) {
                __webview.stop()
                __webview.destroy()
                loadSpinner.running = false
                previewFailed.visible = true
            }
        }
    }

    Timer {
        id: spinnerTimeout
        interval: 1000
        onTriggered: {
            if (!!__webview && !__webview.loaded) {
                loadSpinner.running = true
            }
        }
    }

    Connections {
        target: __webview
        onLoadProgressChanged: {
            if (__webview.loadProgress > 80) {
                __webview.opacity = 1.0
                loadSpinner.running = false
            }
        }
    }

    Component.onCompleted: {
        statusChanged()
    }
}
