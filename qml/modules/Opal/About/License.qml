//@ This file is part of opal-about.
//@ https://github.com/Pretty-SFOS/opal-about
//@ SPDX-FileCopyrightText: 2020-2022 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Sailfish.Silica 1.0 // for StandardPaths

/*!
    \qmltype License
    \inqmlmodule Opal.About
    \inherits QtObject
    \brief Defines a license.

    Licenses are specified by their \l {https://spdx.org/licenses/}
    {SPDX identifiers}. You do not have to include any license
    texts manually: they may be automatically downloaded if the user requests so,
    and will be cached locally. If a license text is not available locally and
    downloading is not possible, a short notice including a link to the full
    license text will be shown.

    \note automatic downloading is disabled by default to avoid unexpected network
    usage. Do not change the private \l __online property, as this could cause
    costs for the user.

    \b {Required notices:}

    Some licenses require you to include certain notices in a
    prominent place. Use the \l customShortText property for this.
    Some common notices are provided.

    \qml
    licenses: License { spdxId: "GPL-3.0-or-later" } // ~125 KiB
    \endqml

    \sa AboutPageBase::licenses, Attribution, customShortText
*/
QtObject {
    id: root

    /*!
      This property holds the license's SPDX identifier.

      Licenses are specified by their \l {https://spdx.org/licenses/}
      {SPDX identifiers}. Follow the link for a list of supported
      codes.

      License texts will be downloaded automatically. They will be cached
      to reduce bandwidth usage, generally until the device is restarted.

      \required
    */
    property string spdxId

    /*!
      This property holds a very short paragraph summarizing the license.

      Some licenses like the GNU GPL require you to include certain notices
      in a prominent place. Generally, short texts are \e not required.

      Default short texts will be shown automatically for the
      following licenses:

      \table 100 %
      \header
        \li SPDX ID
        \li Default short text
      \row
        \li GPL-*, AGPL-*, LGPL-*
        \li This is free software: you are welcome to redistribute it under certain conditions.
            There is NO WARRANTY, to the extent permitted by law.
      \endtable

      \note these default texts are not translated.
    */
    property string customShortText: ""

    /*!
      This property is \c true when the license text could not be fetched.
    */
    readonly property bool error: __error

    /*!
      This property provides the license's full name.
    */
    readonly property string name: __name

    /*!
      This property provides the license's full text.

      The full text will be empty if it could not be loaded,
      i.e. when \l error is \c true. The license page will then
      show an explanatory text and a link to the full text.
    */
    readonly property string fullText: __fullText

    /*!
      If this is \c true, missing texts will be downloaded from the internet.

      Downloading is disabled by default to avoid unexpected network usage which
      could cause costs for the user.

      Cached license texts will always be loaded locally.
    */
    property bool __online: false

    property string __localUrl: "%1/%2.json".arg(StandardPaths.temporary).arg(spdxId)
    property string __remoteUrl: "https://spdx.org/licenses/%1.json".arg(spdxId)
    property string __name: ""
    property string __fullText: ""
    property bool __error: false
    property bool __initialized: false

    property WorkerScript __worker: WorkerScript {
        source: "private/worker_spdx.js"
        onMessage: {
            if (messageObject.spdxId !== spdxId) return
            __name = messageObject.name
            __fullText = messageObject.fullText
            __error = messageObject.error
            if (customShortText === '') customShortText = messageObject.shortText
        }

        Component.onCompleted: {
            _load()
            __initialized = true
        }
    }

    onSpdxIdChanged: {
        if (__initialized) _load(true)
    }

    on__OnlineChanged: {
        _load()
    }

    function _load(force) {
        if (fullText !== "" && force !== true) return
        if (spdxId === undefined || spdxId === "") {
            __error = true
            console.error("[Opal.About] cannot load license without spdxId")
            return
        }

        __name = ""
        __fullText = ""
        __error = false
        __worker.sendMessage({
            spdxId: spdxId,
            localUrl: __localUrl,
            remoteUrl: __remoteUrl,
            shortText: customShortText,
            online: !!__online
        })
    }
}
