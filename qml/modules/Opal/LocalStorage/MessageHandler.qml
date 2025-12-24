//@ This file is part of opal-localstorage.
//@ https://github.com/Pretty-SFOS/opal-localstorage
//@ SPDX-License-Identifier: GPL-3.0-or-later
//@ SPDX-FileCopyrightText: 2018-2025 Mirian Margiani

import QtQuick 2.0
import Sailfish.Silica 1.0
import "private"
import "."

/*!
    \qmltype MessageHandler
    \inqmlmodule Opal.LocalStorage
    \since version 0.2.0

    \brief Handle database errors and other signals.

    The \c MessageHandler serves as a gateway for signals sent from
    your database implementation that should be handled in the GUI.

    By default, it automatically shows popups when fatal database
    errors occur. For example, when the loaded database has an
    unexpected version or when migration fails.

    \section2 Usage

    To handling message with the message handler, add it to your main
    QML file.

    \qml
    // ...
    import Opal.LocalStorage 1.0 as L

    ApplicationWindow {
        // ...

        L.MessageHandler {}
    }
    \endqml

    \section2 Custom signals

    Custom events can be sent from your database script using the
    \l Database::notify and \l Database::notifyEnd functions.

    These events will trigger the \l userSignalReceived signal which
    you can handle:

    \qml
    MessageHandler {
        onUserSignalReceived: {
            switch (event) {
            case "my-event":
                showOverlay(handle, "You won!",
                            "You won the lottery. Wow.")
                break
            case "end":
                hideOverlay(handle)
                break
            default:
                console.warn("bug: unknown event received:", event, JSON.stringify(data))
                break
        }
    }
    \endqml

    \sa LocalStorage, Database
*/
Item {
    id: root

    // Handle this to handle custom user events.
    /*
        onUserSignalReceived: {
            switch (event) {
            default:
                console.log("EVENT", event, handle, busy, JSON.stringify(data))
            }
        }
    */

    /*!
      This signal is triggered when the storage backend sends an event.

      See \l MessageHandler for an example how to handle this signal.

      See \l Database::notify for a description of the parameters.

      \sa MessageHandler, Database::notify, Database::notifyEnd
    */
    signal userSignalReceived(var event, var handle, var busy, var data)

    // Registry of all currently visible overlays:
    // {event: overlay object}
    property var __events: ({})

    // All user events are registered here:
    // {event: 1}
    // This is used to determine whether an "end" event should
    // be handled internally or by the user.
    property var __userEvents: ({})

    // Logging category prefix.
    readonly property string _lc: "[Opal.LocalStorage] MessageHandler:"

    // Internal signal called by the storage script.
    signal __databaseSignalReceived(var event, var handle, var busy, var data)

    /*!
      This function shows a blocking overlay for an event.

      The overlay will block all user interaction with the app
      until it is hidden again using the \l hideOverlay function.

      The event's \a handle must be provided so the overlay can
      be hidden again. Subsequent calls to this function will
      overlay overlays over laying overlays.

      While an overlay with a certain \a handle is already visible,
      it will not be shown again.

      Define the strings \a title and \a description to include
      content in overlay. If \a busy is \c true, the overlay will
      include a busy spinner.

      \sa hideOverlay
    */
    function showOverlay(handle, title, description, busy) {
        var obj = overlayComponent.createObject(
            __silica_applicationwindow_instance,
            {text: title, hintText: description, busy: busy})

        if (obj === null) {
            console.error(_lc, "failed to show status overlay!")
        } else {
            obj.show()
        }

        if (__events.hasOwnProperty(handle)) {
            console.warn(_lc, "replacing event with handle", handle)
            _hideOverlay(handle)
        }

        __events[handle] = obj
    }

    /*!
      This function hides an overlay for an event.

      Call this to hide the overlay for event an event with
      the handle \a handle that was previously shown using
      \l showOverlay.

      \sa hideOverlay
    */
    function hideOverlay(handle) {
        if (__events.hasOwnProperty(handle)) {
            __events[handle].hide(true)
            delete __events[handle]
        }
    }

    // TODO
    function allowDismissOverlay(handle) {
        // TODO
    }

    // Register the internal event signal with the storage script.
    function _register(force) {
        if (!force && !!LocalStorage._DB_STATUS_SIGNAL) {
            console.warn(_lc, "database status signal already set!")
        } else {
            LocalStorage._DB_STATUS_SIGNAL = __databaseSignalReceived
        }
    }

    visible: false
    parent: __silica_applicationwindow_instance

    on__DatabaseSignalReceived: {
        if (/^user-/.test(handle)) {
            __userEvents[handle] = 1
            userSignalReceived(event, handle, busy, data)
            return
        }

        function _show(title, hint) {
            showOverlay(handle, title, hint, busy)
        }

        switch (event) {
        case "end":
            if (!__userEvents.hasOwnProperty(handle)) {
                hideOverlay(handle)
            }
            break
        case "init":
        case "upgrade":
            // these events should be quick and don't need an overlay
            break
        case "query-failed":
            // TODO this event should probably show a message that can
            // be dismissed. Maybe it needs more manual control?
            break
        case "upgrade-failed":
            _show(qsTranslate("Opal.LocalStorage", "Database upgrade failed"),
                  "<p>"+qsTranslate("Opal.LocalStorage",
                              "An error occurred while upgrading " +
                              "the database from version %1 to version %2. " +
                              "Please report this issue.").
                  arg(data.from).arg(data.to) +
                  "</p><p><font size='2'><br><b>" +
                  qsTranslate("Opal.LocalStorage", "Developer information:") +
                  "</b><br>
                    %1<br>
                    Stack:<br>%2
                  </font></p>
                  ".arg(data.exception).arg(data.exception.stack.split('\n').join('<br><br>'))
                  )
            break
        case "invalid-version":
            _show(qsTranslate("Opal.LocalStorage", "Invalid database version"),
                  qsTranslate("Opal.LocalStorage",
                              "The app cannot start because " +
                              "the database has version %1 " +
                              "but only version %2 is supported.").
                  arg(data.got).arg(data.expected))
            break
        case "maintenance":
            _show(qsTranslate("Opal.LocalStorage", "Database Maintenance"),
                  qsTranslate("Opal.LocalStorage", "Please be patient and allow up to 30 seconds for this."))
            break
        default:
            _show(qsTranslate("Opal.LocalStorage", "Database issue"),
                  "<p>"+qsTranslate("Opal.LocalStorage", "An unexpected issue occurred in the database. Try restarting the app.") +
                  "</p><p><font size='2'>
                   <br><b>" +
                  qsTranslate("Opal.LocalStorage", "Developer information:")
                  + "</b><br>
                   Event: %1<br>
                   Data: %2
                   </font></p>".arg(event).arg(JSON.stringify(data)))
            break
        }
    }

    Component {
        id: overlayComponent
        BlockingOverlay {}
    }

    Component.onCompleted: {
        _register()
    }
}
