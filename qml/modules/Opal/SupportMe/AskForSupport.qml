//@ This file is part of opal-supportme.
//@ https://github.com/Pretty-SFOS/opal-supportme
//@ SPDX-FileCopyrightText: 2024-2025 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

/*!
    \qmltype AskForSupport
    \inqmlmodule Opal.SupportMe
    \inherits QtObject
    \brief Regularily invite users to support the project.

    It is difficult to engage users to actually contribute
    to open source projects. With this component, you can
    regularily remind users of the different ways to support
    you (the developer) or the project through contributions.

    The module provides a simple API to define your own content.
    You can get started quickly by copying the example below,
    or by copying from other apps that use this module.

    Example:

    \qml
    // file: harbour-myapp.qml
    ApplicationWindow {
        id: app
        initialPage: Qt.resolvedUrl("pages/FirstPage.qml")

        AskForSupport {
            contents: Component {
                MySupportDialog {}
            }
        }
    }

    // file: MySupportDialog.qml
    import QtQuick 2.0
    import Opal.SupportMe 1.0

    SupportDialog {
        SupportAction {
            icon: SupportIcon.Liberapay
            title: qsTr("Donate on %1").arg("Liberapay")
            description: qsTr("Pay the amount of a cup of coffee, a slice " +
                              "of pizza, or a ticket to the theater.")
            link: "https://liberapay.com/example"
        }

        SupportAction {
            icon: SupportIcon.Weblate
            title: qsTr("Translate on %1").arg("Weblate")
            description: qsTr("Help with translating this app in as many " +
                              "languages as possible.")
            link: "https://hosted.weblate.org/projects/example"
        }

        SupportAction {
            icon: SupportIcon.Git
            title: qsTr("Develop on %1").arg("Codeberg")
            description: qsTr("Support with maintenance and packaging, " +
                              "write code, or provide valuable bug reports.")
            link: "https://git.example.org/example"
        }

        DetailsDrawer {
            title: qsTr("Why should you care?")

            DetailsParagraph {
                text: qsTr("This project is built with love and passion by a " +
                           "single developer in their spare time, and is provided " +
                           "to you free of charge.")
            }

            DetailsParagraph {
                text: qsTr("I develop Free Software because I am convinced that " +
                           "it is the ethical thing to do - and it is a fun hobby. " +
                           "However, developing software takes a lot of time and effort. " +
                           "As Sailfish and living in general costs money, I need your " +
                           "support to be able to spend time on non-paying projects " +
                           "like this.")
            }
        }

        DetailsDrawer {
            title: qsTr("Why donate?")

            DetailsParagraph {
                text: qsTr("If you can afford it, donating is the easiest way " +
                           "to ensure that I can continue working on apps " +
                           "for Sailfish. Any amount is appreciated, be it a cup " +
                           "of coffee, a slice of pizza, or more.")
            }
        }
    }
    \endqml

    The module is built with performance in mind. Any impact on
    app startup times should be minimal.

    \sa contents, interval, SupportDialog
*/
Item {
    id: root

    /*!
      This property defines whether the popup is used at all.

      Set this to \c false to completely disable the popup. This
      can be useful for managing outreach campaigns.

      \defaultValue true
    */
    property bool enabled: true

    /*!
      This property defines whether to show the popup on first start.

      Usually, the popup is only shown after the user has started the
      app a few times. Remember that this popup is intended to be
      respectful of the user and to be as little annoying as possible.

      \defaultValue false
    */
    property bool showOnInitialStart: false

    /*!
      This property defines when the request is shown.

      An internal counter keeps track of how many times the
      app has been started. If the counter reaches the
      interval, the popup is shown and the counter resets.

      \defaultValue 15 (every 15th start)
    */
    property int interval: 15

    /*!
      This property defines when the request is shown as a reminder.

      If the user has requested not to be asked again, the
      reminder is still shown if the app has been opened
      this many times.

      This is not intended to annoy the user but to allow
      for changes in opinion and/or ability.

      \important this value should be high enough that it
      is not a nuisance but rather a helpful reminder
      for users that don't want to be bugged with requests.

      \defaultValue 150 (every 150th start)
    */
    property int longInterval: 150

    /*!
      Define your custom call for contributions here.

      You must assign a \c Component containing a \l SupportDialog
      here. If this is missing, a very bare-bones reminder
      and "thank you" will be shown.

      See the main documentation (\l AskForSupport) for an
      example dialog that you can freely adapt to your needs.

      \sa SupportDialog, SupportAction, DetailsDrawer, DetailsParagraph
    */
    property Component contents: Component {
        SupportDialog {
            DetailsDrawer {
                DetailsParagraph {
                    text: qsTr("Please take a moment to consider " +
                               "if you can contribute to this project " +
                               "in one way or another.")
                }
            }
        }
    }

    /*!
      This property holds an optional custom \c dconf path for settings.

      It is usually unnecessary to use this property. However, if you
      want to use multiple popups, you must define a custom config path
      for each of them to give them distinct places to store their settings.

      By default, settings are stored in \c dconf at:
      \c{/settings/opal/opal-supportme/support-overlay/<organization name>/<app name>/}
    */
    property string customConfigPath: ""

    /*!
      This private property holds the application name.

      The value is provided through the application profile.
      See the \l {https://github.com/sailfishos/sailjail-permissions#sailfish-os-application-sandboxing-and-permissions}
      {Sailjail documentation} for details.
      for details.

      \internal
    */
    property string _applicationName: Qt.application.name

    /*!
      This private property holds the organization name.

      The value is provided through the application profile.
      See the \l {https://github.com/sailfishos/sailjail-permissions#sailfish-os-application-sandboxing-and-permissions}
      {Sailjail documentation} for details.
      for details.

      \internal
    */
    property string _organizationName: Qt.application.organization

    readonly property bool __askAgain: !!configLoader.item ?
        configLoader.item.askAgain : true
    readonly property int __lastAskedAt: !!configLoader.item ?
        configLoader.item.lastAskedAt : -1
    readonly property int __startCount: !!configLoader.item ?
        configLoader.item.startCount : (showOnInitialStart ? interval : -1)
    readonly property string __configPath: "/settings/opal/opal-supportme/" +
        "support-overlay/%1/%2".arg(_organizationName).arg(_applicationName)
    readonly property string __effectiveConfigPath: customConfigPath || __configPath

    property int __ready: (configLoader.status === Loader.Ready ? 1 : 0)
    property int __maxReady: 1

    function show() {
        showTimer.stop()
        pageStack.completeAnimation()

        var dialog = pageStack.push(contents)

        if (!!dialog) {
            dialog.done.connect(function(){ _markAsSeen() })
            dialog.dontAskAgain.connect(function(){ _dontAskAgain() })
        }
    }

    function _markAsSeen() {
        configLoader.item.lastAskedAt = __startCount
    }

    function _dontAskAgain() {
        _markAsSeen()
        configLoader.item.askAgain = false
    }

    Component.onCompleted: {
        if (!enabled) return

        if (!customConfigPath && (!_applicationName || !_organizationName)) {
            var prefix = !!objectName ? objectName + ": " : ""
            console.warn("[Opal.SupportMe] %1both application name and organisation name ".arg(prefix) +
                         "must be set in order to use the support overlay")
            console.warn("[Opal.SupportMe] %1note that these properties are also required ".arg(prefix) +
                         "for Sailjail sandboxing")
            console.warn("[Opal.SupportMe] %1see: https://github.com/sailfishos/".arg(prefix) +
                         "sailjail-permissions#desktop-file-changes")
        }
    }

    on__ReadyChanged: {
        if (!enabled || __ready < __maxReady) return

        configLoader.item.startCount += 1

        if (   (__askAgain && __startCount >= __lastAskedAt + interval)
            || (!__askAgain && __startCount >= __lastAskedAt + longInterval)) {
            var prefix = !!objectName ? objectName + ": " : ""
            console.log("[Opal.SupportMe] %1showing support popup now".arg(prefix))
            console.log("[Opal.SupportMe] %3starts: %1 | last asked: %2".arg(
                            __startCount).arg(__lastAskedAt).arg(prefix))
            showTimer.start()
        }
    }

    Loader {
        id: configLoader
        sourceComponent: enabled && !!__effectiveConfigPath ?
                             configComponent : null
        asynchronous: true
    }

    Timer {
        id: showTimer
        interval: 8  // ease conflicts with Opal.About's changelog popup which uses 10
        repeat: true
        running: false
        onTriggered: {
            if (pageStack.busy || pageStack.depth === 0) return
            show()
        }
    }

    Component {
        id: configComponent

        ConfigurationGroup {
            path: root.__effectiveConfigPath
            property bool askAgain: true
            property int lastAskedAt: 0
            property int startCount: 0
        }
    }
}
