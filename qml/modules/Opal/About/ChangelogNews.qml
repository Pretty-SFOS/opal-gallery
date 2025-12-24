//@ This file is part of opal-about.
//@ https://github.com/Pretty-SFOS/opal-about
//@ SPDX-FileCopyrightText: 2023 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.2
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import "private/functions.js" as Func
import "private"

/*!
    \qmltype ChangelogNews
    \inqmlmodule Opal.About
    \inherits QtObject
    \brief Automatically shows latest changes when the app starts.

    \note See the main documentation at \l AboutPageBase for details about
    the different ways to include changelogs.

    Add this component as a direct child of the main \l ApplicationWindow
    to automatically show latest changes from the changelog when the app
    starts.

    Nothing will be shown if the app is started for the first time or if
    there are no changes since it last ran, i.e. if the app has not been
    updated.

    Example:

    \qml
    // file: harbour-myapp.qml
    ApplicationWindow {
        id: app
        initialPage: Qt.resolvedUrl("pages/FirstPage.qml")

        ChangelogNews {
            changelogList: Qt.resolvedUrl("Changelog.qml")
        }
    }
    \endqml

    Changelog items can be defined inline or in a separate component.
    It is recommended to keep them in a separate component so that the
    changelog can be made available on the “About” page as well.

    \sa changelogList, AboutPageBase::changelogList, AboutPageBase::changelogItems, changelogItems
*/
Item {
    id: root

    /*!
      This property holds a list of changelog sections, one per released version.

      See the main documentation at \l AboutPageBase::changelogItems for details.

      \sa AboutPageBase::changelogItems, AboutPageBase::changelogList
    */
    property list<ChangelogItem> changelogItems

    /*!
      This property holds a reference to an externally defined changelog.

      See the main documentation at \l AboutPageBase::changelogList for details.

      \sa AboutPageBase::changelogItems, AboutPageBase::changelogList
    */
    property url changelogList

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

    readonly property string __lastVersion: !!configLoader.item ?
        configLoader.item.lastVersion : ""
    readonly property string __configPath: "/settings/opal/opal-about/" +
        "changelog-overlay/%1/%2".arg(_organizationName).arg(_applicationName)

    property list<ChangelogItem> __filteredItems
    property int __ready: (configLoader.status === Loader.Ready ? 1 : 0) +
                          (itemsLoader.effectiveItems.length > 0 ? 1 : 0)

    function show() {
        showTimer.stop()
        pageStack.completeAnimation()
        pageStack.push(dialogComponent)
    }

    function _markAsRead() {
        if (__filteredItems.length === 0) {
            return
        }

        var latestChangelogVersion = __filteredItems[0].version
        configLoader.item.lastVersion = latestChangelogVersion
    }

    Component.onCompleted: {
        if (!_applicationName || !_organizationName) {
            console.warn("[Opal.About] both application name and organisation name " +
                         "must be set in order to use the changelog overlay")
            console.warn("[Opal.About] note that these properties are also required " +
                         "for Sailjail sandboxing")
            console.warn("[Opal.About] see: https://github.com/sailfishos/" +
                         "sailjail-permissions#desktop-file-changes")
        }
    }

    on__ReadyChanged: {
        if (__ready < 2 || itemsLoader.effectiveItems.length === 0 ||
                __filteredItems.length > 0) return

        if (!!__lastVersion) {
            var loadedItems = []

            for (var i in itemsLoader.effectiveItems) {
                if (itemsLoader.effectiveItems[i] === null) {
                    // Due to a bug in QmlLive, items are empty when running
                    // with QmlLive. We skip loading to avoid warnings.
                    continue
                }

                var v = itemsLoader.effectiveItems[i].version

                if (v === __lastVersion) {
                    break
                }

                console.log("[Opal.About] showing changelog for:", v)
                loadedItems.push(itemsLoader.effectiveItems[i])
            }

            if (loadedItems.length > 0) {
                __filteredItems = loadedItems
                showTimer.start()
            } else {
                // keep all items so that the list is not empty
                // in case show() is called manually
                __filteredItems = itemsLoader.effectiveItems
            }
        } else {
            __filteredItems = itemsLoader.effectiveItems
            _markAsRead()
            __ready = -1
        }
    }

    Loader {
        id: configLoader
        sourceComponent: !!_applicationName && !!_organizationName ?
                             configComponent : null
        asynchronous: true
    }

    ChangelogItemsLoader {
        id: itemsLoader
        changelogItems: root.changelogItems
        changelogList: root.changelogList
    }

    Timer {
        id: showTimer
        interval: 10
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
            path: root.__configPath
            property string lastVersion: ""
        }
    }

    Component {
        id: dialogComponent

        Dialog {
            allowedOrientations: Orientation.All
            onDone: _markAsRead()

            ChangelogView {
                anchors.fill: parent

                changelogItems: root.__filteredItems

                header: PageHeader {
                    title: qsTranslate("Opal.About", "News")
                    description: qsTranslate(
                        "Opal.About", "Changes since version %1").arg(__lastVersion)
                    descriptionWrapMode: Text.Wrap
                }
            }
        }
    }
}
