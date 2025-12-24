//@ This file is part of opal-linkhandler.
//@ https://github.com/Pretty-SFOS/opal-linkhandler
//@ SPDX-FileCopyrightText: 2020-2025 Mirian Margiani
//@ SPDX-FileCopyrightText: 2025 roundedrectangle
//@ SPDX-License-Identifier: GPL-3.0-or-later

// Note: this file is not a marked as a library because it needs some variables
// from the calling context (pageStack).

var _defaultPreviewMode = 0

/*!
    \qmltype LinkHandler
    \inqmlmodule Opal.LinkHandler
    \brief Provides link handlers.

    Use the \l openOrCopyUrl in \c onLinkActivated handlers in \c Label items.

    Example:

    \qml
    import Opal.LinkHandler 1.0

    Label {
        text: 'This is my text, and <a href="https://example.org">this is my link</a>.'
        color: Theme.highlightColor
        linkColor: Theme.primaryColor  // important, as the default color is plain blue
        onLinkActivated: LinkHandler.openOrCopyUrl(link)
    }
    \endqml
*/

// Add values missing from \a obj from \a toAdd to \a obj.
function _extendObj(obj, toAdd){
    for (var i in toAdd) {
        if (!obj.hasOwnProperty(i)) {
            obj[i] = toAdd[i]
        }
    }

    return obj
};

// We have to explicitly set the \c _defaultPageOrientations property
// to \c Orientation.All so the page stack's default placeholder page
// will be allowed to be in landscape mode. (The default value is
// \c Orientation.Portrait.)
//
// Without this setting, pushing pages to the stack using \c animatorPush()
// while in landscape or inverted portrait mode will cause the view to get
// stuck on the empty placeholder page.
//
// Issue since at least 2021, SFOS 3.4 (sailfishsilica-qt5 version 1.1.110.3-1.33.3.jolla)
// Persistent until at least 2025, SFOS 4.6
function _fixPageOrientations() {
    try {
        __silica_applicationwindow_instance._defaultPageOrientations = 15
    } catch(e) {
        console.warn("[Opal.LinkHandler] failed to apply workaround for animatorPush() issue")
    }
}

/*!
  \qmlmethod Page LinkHandler::openOrCopyUrl(url externalUrl, string title, int previewMode)

  This function shows a page that allows users to open, copy, share, or quickly preview an
  external link (\a externalUrl).

  You can give an optional page title in the \a title argument. A default title based
  on the URL type is used if this argument is empty.

  The preview is only enabled if the link is a web address (HTTP or HTTPS) and
  the app has network access (connection and permissions).

  \note this module is compatible with older Sailfish versions where the \c WebView
  module is not available. However, the preview will be disabled.

  Optionally, set the \a previewMode parameter to one of the following values.

  \table
    \header
        \li Preview Mode
        \li Description
    \row
        \li \c LinkPreviewMode.auto
        \li default: enables the preview if any network connection is available and the URL scheme is valid
    \row
        \li \c LinkPreviewMode.disabledIfMobile
        \li disables the preview if the device is connected via a mobile data connection
    \row
        \li \c LinkPreviewMode.enabled
        \li enables the preview if the URL scheme is valid
    \row
        \li \c LinkPreviewMode.disabled
        \li disables the preview
  \endtable

  You can pass extra properties directly to the handler page by passing an object in
  the optional parameter \a extraProperties.

  \table
    \header
        \li Property name
        \li Type
        \li Default
        \li Description
    \row
        \li \c allowedSchemesRegex
        \li RegExp
        \li \c {/^https:\/\//}
        \li a regular expression to check whether a link may show a preview
  \endtable

  Returns the handler page instance.

  \sa Qt::openUrlExternally, openOrCopyMultipleUrls, ExternalUrlPage
*/
function openOrCopyUrl(externalUrl, title, previewMode, extraProperties) {
    _fixPageOrientations()
    return pageStack.animatorPush(Qt.resolvedUrl("private/ExternalUrlPage.qml"), _extendObj({
        'externalUrl': externalUrl,
        'title': !!title ? title : '',
        'previewMode': typeof previewMode !== 'undefined' ? previewMode : _defaultPreviewMode
    }, !!extraProperties ? extraProperties : {}))
}

/*!
  \qmlmethod void LinkHandler::openOrCopyMultipleUrls(array sets)

  This function is the same as \l openOrCopyUrl, except that it shows multiple
  URLs for opening or copying.

  Provide an array of objects in the \a sets parameter. Each object in the array
  must have the same keys that \l openOrCopyUrl takes as parameters: the
  \c externalUrl key is required, the \c title, \c previewMode, and \c extraProperties
  keys are optional.

  Returns nothing.

  \sa openOrCopyUrl
*/
function openOrCopyMultipleUrls(sets) {
    var pages = []

    for (var i = 0; i < sets.length; ++i) {
        pages.push({
            'page': Qt.resolvedUrl('ExternalUrlPage.qml'),
            'properties': _extendObj({
                'externalUrl': sets[i].externalUrl,
                'title': sets[i].hasOwnProperty('title') ? sets[i].title : "",
                'previewMode': typeof sets[i].previewMode !== 'undefined' ? sets[i].previewMode : _defaultPreviewMode
            }, sets[i].hasOwnProperty('extraProperties') && !!sets[i].extraProperties ?
                sets[i].extraProperties : {})
        })
    }

    _fixPageOrientations()
    pageStack.push(pages)
}
