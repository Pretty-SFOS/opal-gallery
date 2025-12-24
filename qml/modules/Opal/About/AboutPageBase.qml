//@ This file is part of opal-about.
//@ https://github.com/Pretty-SFOS/opal-about
//@ SPDX-FileCopyrightText: 2020-2025 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../LinkHandler" as L
import "private/functions.js" as Func
import "private"
import "."

/*!
    \qmltype AboutPageBase
    \inqmlmodule Opal.About
    \inherits Page
    \brief Provides the base for custom About pages.

    The \c AboutPageBase is the basis for custom app info pages. App
    info pages normally contain information about the app's version,
    authors, and licensing.

    This component allows for the inclusion of standard info blocks
    for one or more licenses, authors, and contributors. You can add an
    arbitrary number of additional custom info sections.

    \section2 Licenses and Attribution

    Open-source licenses are specified by their \l {https://spdx.org/licenses/}
    {SPDX identifiers}. Follow the link for a list of valid strings.
    Custom licenses can be defined manually but are strongly discouraged.
    The license list (\l licenses) holds all licenses that are directly
    used in the project. Refer to the \l License component for more information.

    If your app relies on third-party services, e.g. data providers
    or for cloud functionalities, you should include a dedicated info
    section for each service that requires the user to accept Terms of Use
    or attribution. You can add links or open custom pages via the \c buttons
    property of \l InfoSection. Refer to \l InfoSection and \l extraSections
    for more information.

    Use the \l attributions property to define attributions that are
    necessary but don't need a dedicated info section on the main page.

    \section2 Donations

    Users can be asked for donations using the \l donations group. Some default
    texts are already provided. Set a list of \l DonationService elements
    on the \l {DonationsGroup::services}{donations.services} property.

    It is also possible to explicitly ask for \e no donations by using
    the \l DonationsGroup::defaultTextContribInstead text.

    The section will be hidden if neither a text nor services are defined.

    \section2 Changelogs

    You can optionally provide a changelog that can be accessed inside the app
    to notify users of important changes.

    Keep in mind that this is a user-facing changelog, so keep it simple and
    highlight only the most notable changes in a few short paragraphs. Bullet
    points are discouraged as they don't look good if a single list item extends
    more than one line.

    Changelogs can either be defined inline or in a separate QML file.
    Prefer a separate file if your changelogs get large, or if you want to
    reuse them in multiple components (like on the “About” page through
    \l {changelogList} as well as on startup in \l ChangelogNews).

    Use the \l changelogItems property to quickly define changelogs for
    a few versions inline. Use the \l changelogList property to set
    a reference to a separate QML file providing a \l ChangelogList item.

    \note the two options \l changelogItems and \l changelogList cannot
    be used at the same time. If both are defined, \l changelogItems will
    take precedence.

    Use the \l ChangelogNews component to automatically show the latest
    changes on the first start after the app has been updated. This component
    has to be used from the main \l ApplicationWindow. See \l ChangelogNews
    for details.

    \section2 Example Page

    The code below demonstrates an app info page for a simple project.
    One-person projects without other contributors can omit setting the
    \l contributionSections property. \c Opal.About is automatically added
    to the \l attributions list. Declare third-party libraries and other
    acknowledgements in this list.

    \qml
        import QtQuick 2.0
        import Sailfish.Silica 1.0
        import Opal.About 1.0

        AboutPageBase {
            id: root
            allowedOrientations: Orientation.All

            appName: qsTr("MyApp")
            appIcon: Qt.resolvedUrl("../images/harbour-myapp.png")
            appVersion: APP_VERSION
            appRelease: APP_RELEASE
            description: qsTr("This is a short description of the app.")
            sourcesUrl: "https://git.example.org/myapp"
            translationsUrl: "https://hosted.weblate.org/projects/example/"

            authors: ["2020-%1 Jane Doe".arg((new Date()).getFullYear())]
            licenses: License { spdxId: "GPL-3.0-or-later" }

            changelogItems: [
                // add new items at the top of the list
                ChangelogItem {
                    version: "1.0.0-1"
                    date: "2020-01-01"   // optional
                    author: "Jane Doe"   // optional
                    paragraphs: "A short paragraph describing this initial version."
                }
            ]

            donations.text: donations.defaultTextCoffee
            donations.services: DonationService {
                name: "Liberapay"
                url: "https://liberapay.com/example"
            }

            attributions: [
                Attribution {
                    name: "Example Library"
                    entries: ["1950-2000 Jane Doe Sr.", "2000-2050 Jane Doe Jr."]
                    licenses: License { spdxId: "CC0-1.0" }
                }
            ]

            contributionSections: [
                ContributionSection {
                    // title: qsTr("Development") -- automatically added for the top section
                    groups: [
                        ContributionGroup {
                            title: qsTr("Programming")
                            entries: ["Jane Doe", "John Doe"] // it is not necessary to repeat names
                                                              // already listed in mainAttributions/authors
                        },
                        ContributionGroup {
                            title: qsTr("Icon Design")
                            entries: ["Jim Doe"]
                        }
                    ]
                },
                ContributionSection {
                    title: qsTr("Translations")
                    groups: [
                        ContributionGroup {
                            title: qsTr("English")
                            entries: ["Jake Doe"]
                        },
                        ContributionGroup {
                            title: qsTr("German")
                            entries: ["Max Mustermann"]
                        }
                    ]
                }
            ]
        }
    \endqml

    \section2 Custom Page Elements

    It is possible to add custom page elements to the end of the
    page by explicitly parenting them to the page's \l flickable property.
    You can, for example, add a pulley menu by setting its \c parent
    property to \c {root.flickable}:

    \qml
    PullDownMenu {
        parent: root.flickable
        MenuItem {
            text: qsTr("Open a page")
            onClicked: pageStack.push(Qt.resolvedUrl("Page.qml"))
        }
    }
    \endqml

    \section2 Translations

    The module provides all translations needed for the most common use-cases.
    Pre-translated strings include a range of language names as needed in
    the contributions info, strings for attribution of third-party libraries,
    and more. All common translations that are not directly used in this module
    are provided in the \c {Opal.About.Common} translation context. After
    translations have been merged you can go through your strings and
    mark all translations provided by \c lupdate's "same text" heuristic as
    "accepted". If you forget this step, these translations won't be used.

    You can use Qt's \c qsTranslate function and provide the context manually
    if you want to explicitly use a pre-translated string. This should not be
    necessary, though.

    \sa License, InfoSection, Attribution, ContributionSection, ContributionGroup, donations
*/
Page {
    id: page

    /*!
      This property sets the app's name which will be displayed together with
      its logo and version string.

      \required
      \sa appVersion, appRelease
    */
    property string appName: ""

    /*!
      This property specifies the path to the app's logo.

      It is recommended to include the icon in your app's data directory.
      You can specify a full path to shared system files alternatively.

      \qml
      appIcon: Qt.resolvedUrl("../images/harbour-myapp.png")
      appIcon: "/usr/share/icons/hicolor/172x172/apps/harbour-myapp.png"
      \endqml

      Setting this property is not strictly required but highly recommended.

      \note you can use \opsnip {render-icons} to easily render SVG icon
      source to any destination.
    */
    property string appIcon: ""

    /*!
      This property holds the app's version number.

      Use for example \c APP_VERSION if configured via C++.

      \note you can use \opsnip {cached-defines} for passing options from
      YAML to QML.

      \required
      \sa appRelease
    */
    property string appVersion: ""

    /*!
      This property holds the app's release number.
      Use for example \c APP_RELEASE if configured via C++

      \note you can use \opsnip {cached-defines} for passing options from
      YAML to QML.

      Setting this property is not required. It will only be shown
      if its value is not \c 1.

      \sa appVersion
    */
    property string appRelease: "1"

    /*!
      This property holds the app's release type.

      Some apps may be published in different flavours, e.g. in a version
      for OpenRepos and a slightly different version for the official store.

      Setting this property is optional.

      \sa appVersion, appRelease
    */
    property string appReleaseType: ""

    /*!
      This property holds a styled text description of the app.

      Sailfish-themed styling is applied by default. You can include
      links in text using \c {<a>} tags if needed. Depending on your
      use case it might be more appropriate to use a custom info
      section with a button though.

      \sa extraSections, InfoSection
    */
    property string description: ""

    /*!
      This property holds a list of the app's author(s) and/or maintainer(s).

      The names in this list will be shown on the main "about" page, and
      again at the top of the contributors page with the title "Development".

      It is possible to assign a single string value instead of a list
      to this property.

      \note if the first group in \l contributionSections is also titled
      "Development", it will be merged automatically.

      \note people's names should not be translated.

      \required
      \sa authors, contributionSections, attributions
    */
    property var mainAttributions: []

    /*!
      This is a convenience property to be used instead of the \l mainAttributions property.

      The entries of this property will be prepended to all entries of
      \l mainAttributions.

      It is possible to assign a single string value instead of a list
      to this property.

      \e{See \l mainAttributions for details.}

      \required
      \sa mainAttributions
    */
    property var authors: []

    /*!
      This property holds a cleaned list of main attributions.

      The list is combined from the \l mainAttributions and \l authors properties.

      \sa authors, mainAttributions
      \internal
    */
    property var __effectiveMainAttribs: Func.makeStringListConcat(authors, mainAttributions, false)

    /*!
      This property specifies where users can get the app's source code.

      If your app is open-source software it is recommended to include a
      link to a publicly accessible source code repository. This helps
      potential contributors. If you don't want to setup a public
      code repository you can add a custom info section with contact details.

      \note some open-source licenses require you to provide your app's source code.
    */
    property string sourcesUrl: ""

    /*!
      This property specifies where users can contribute to the app's translations.

      Helping with translations is a good way for non-technical users to contribute
      to open source projects they enjoy. Giving them the chance to do so gives
      warm and fuzzy feelings to everyone involved.

      \note \l {https://weblate.com} {Weblate} is an open source tool for
      translations. The community behind it provides a free service for
      applicable open source projects.
    */
    property string translationsUrl: ""

    /*!
      This property specifies where users can find more information about the app.

      This may be a dedicated homepage, a forum thread, or another online space
      for information and/or feedback. A dedicated homepage is not required.
    */
    property string homepageUrl: ""

    /*!
      This property holds a list of changelog sections, one per released version.

      It is not required to provide a changelog in-app. Most apps only provide
      a changelog through their release channels (e.g. on OpenRepos) or in the
      published RPM package. Other apps don't provide a changelog at all.

      \note Keep in mind that this is a user-facing changelog, so keep it simple and
      highlight only the most notable changes in a few short paragraphs.

      The list should be sorted chronologically, with the most recent entry at
      the top so that users don't have to scroll to the bottom to find the most
      relevant information.

      \note If your changelogs get large, prefer using the \l changelogList
      property for performance reasons.

      See the \l ChangelogItem documentation for details.

      \sa ChangelogItem, changelogList, ChangelogList, ChangelogNews
    */
    property list<ChangelogItem> changelogItems

    /*!
      This property holds a reference to an externally defined changelog.

      Use the \l changelogItems property to quickly define changelogs for
      a few versions inline. As the list of changelogs gets longer, consider
      moving it to a separate QML file to improve performance of the main
      “About” page.

      \note Define the changelog separately and use this property if you want
      to automatically show recent changes on startup. See \l ChangelogNews.

      Define a reference to the changelog:

      \qml
      changelogList: Qt.resolvedUrl("MyChangelog.qml")
      \endqml

      Define the changelog separately:

      \qml
      ChangelogList {
          ChangelogItem {
              // ...
          }

          ChangelogItem {
              // ...
          }
      }
      \endqml

      See the \l ChangelogList documentation for details.

      \sa ChangelogList, ChangelogItem, changelogItems, ChangelogNews
    */
    property url changelogList

    /*!
      This property holds a list of relevant licenses.

      The very first licenses in this list is interpreted as the main
      license of the project and its name will be shown directly on the
      About page. If more than one license is specified, all
      additional licenses will be shown when clicking on the license
      section.

      Licenses are specified by their \l {https://spdx.org/licenses/}
      {SPDX identifiers}. You don't have to include any license
      texts manually: users can download them automatically and the files will
      be cached locally. If a license text is not available locally and downloading
      is not possible, a short notice including a link to the full
      license text will be shown.

      \b {Required notices:}

      Some licenses require you to include certain notices in a
      prominent place. Use the \l License::customShortText property for this.
      Follow the link for a list of default short texts that will be shown
      automatically for a few licenses.

      \sa License, allowDownloadingLicenses
    */
    property list<License> licenses

    /*!
      This property defines whether to enable downloading licenses.

      By default, this setting will be enabled depending on whether network
      access is available. If this is enabled, users can request downloading
      licenses texts directly in the app. If it is disabled, users can open
      the license text in the web browser.

      \note fetching license texts always requires manual action from the user.

      \b {Internet access:}

      Your app must have the \c Internet permission in its Sailjail
      profile to be able to download license texts. It is generally advised to
      use as few permissions as possible, so do not ask for network access
      only for this feature.

      \b {Options:}

      \table
        \header
            \li Mode
            \li Description
        \row
            \li \c NetworkMode.auto (default)
            \li Allow downloading licenses if network access is available.
        \row
            \li \c NetworkMode.enabled
            \li Always allow downloading licenses, even if not currently
                connected to a network. Use this if your app needs network
                access anyway.
        \row
            \li \c NetworkMode.disabled
            \li Always forbid downloading licenses. Use this if your app
                does not have the \c Internet permission and never will.
      \endtable

      \defaultValue NetworkMode.auto

      \sa licenses, License
    */
    property var allowDownloadingLicenses: NetworkMode.auto
    // NOTE this is var instead of int to keep backwards compatibility.
    // It was bool before.

    /*!
      This property holds a list of attributions, e.g. to third-party libraries.

      This list is intended for listing names not involved in development,
      and for attributions to third-party libraries and the respective licenses.
      For example, some Creative Commons licenses require attribution.

      \note GPL software like Opal.About and other Opal modules must be listed here.
      Enable \l autoAddOpalAttributions to automatically add attributions for all
      Opal modules used in your project.

      \note Use contribution sections for listing contributors.
      See \l contributionSections.

      \sa Attribution, contributionSections, autoAddOpalAttributions
    */
    property list<Attribution> attributions

    /*!
      This property defines whether attributions for Opal modules are included automatically.

      If this property is set to \c true, all \c {Opal*Attribution.qml} components
      in the \c {qml/modules/Opal/Attributions} directory are loaded automatically
      and added to the list of attributions.

      If it is set to \c false, you must manually include appropriate attributions.

      \note this feature only works if the provided module attribution files
      are properly installed to \c {qml/modules/Opal/Attributions}. If your modules
      are installed to a non-standard location, you must add attributions manually.

      \note this feature is enabled by default since version 3.0.0.

      \defaultValue true

      \sa attributions
    */
    property bool autoAddOpalAttributions: true

    /*!
      This property group holds a list of possible ways to donate to the project.

      Users can be asked for donations using the \l donations group. Some default
      texts are already provided. Set a list of \l DonationService elements
      on the \l {DonationsGroup::services}{donations.services} property.

      It is also possible to explicitly ask for \e no donations by using
      the \l DonationsGroup::defaultTextContribInstead text.

      The section will be hidden if neither a text nor services are defined.

      \qml
        donations.text: donations.defaultTextCoffee
        donations.services: DonationService {
            name: "LiberaPay"
            url: "liberapay.com"
        }
      \endqml

      \sa DonationService, DonationsGroup
    */
    readonly property DonationsGroup donations: DonationsGroup { }

    /*!
      This property holds a list of additional custom info sections.

      Custom sections will be shown below the authors/contributors section
      and above the donations and license sections.

      Multiple buttons can be added using \l InfoButton elements.

      \qml
        extraSections: InfoSection {
            title: qsTr("Data")
            text: qsTr("Lorem ipsum dolor sit amet et cetera ad libitum plurum sid alum.")
            buttons: InfoButton {
                text: qsTr("Terms of Use")
                onClicked: openOrCopyUrl("https://example.org")
            }
        }
      \endqml

      \sa InfoSection, InfoButton, donations, translationsUrl, sourcesUrl, openOrCopyUrl
    */
    property list<InfoSection> extraSections

    /*!
      This property holds the list of your apps contributors.

      You can leave this property empty if you are the only contributor.
      When this list is not empty, a page showing all contributions can
      be openend by clicking on the default author/maintainer section.

      The contributors page component is configured through this property
      and should not be used directly.

      The very first section is automatically added and contains the list
      of names specified in the \l mainAttributions property. The title
      of this section is "Development" (optionally translated).

      \note If the first section in the \l contributionSections list is titled
      "Development" too (or has no title), it will be merged with the
      automatically inserted top section.

      \note Third-party libraries and licenses can be specified using
      the \l attributions property.

      \qml
          contributionSections: [
              ContributionSection {
                  // title: qsTr("Development")
                  groups: [
                      ContributionGroup {
                          title: qsTr("Programming")
                          entries: "..."
                      },
                      ContributionGroup {
                          title: qsTr("Icon Design")
                          entries: ["...", "..."]
                      }
                  ]
              },
              ContributionSection {
                  title: qsTr("Translations")
                  groups: ContributionGroup {
                      title: qsTr("English")
                      entries: ["...", "..."]
                  }
              }
          ]
      \endqml

      \sa ContributionSection, ContributionGroup, attributions
    */
    property list<ContributionSection> contributionSections

    /*!
      This property references the page's main flickable.

      You can add custom page elements to the end of the
      page by explicitly parenting them to this property.
      You can, for example, add a pulley menu by setting its \c parent
      property to \c {root.flickable}:

      \qml
      PullDownMenu {
          parent: root.flickable
          MenuItem {
              text: qsTr("Open a page")
              onClicked: pageStack.push(Qt.resolvedUrl("Page.qml"))
          }
      }
      \endqml

      \sa SilicaFlickable, PullDownMenu
    */
    property alias flickable: _flickable

    /*!
      This property references the page's header item.
      \sa PageHeader
      \internal
    */
    property alias _pageHeaderItem: _pageHeader

    /*!
      This property references the app icon item.
      \sa Image
      \internal
    */
    property alias _iconItem: _icon

    /*!
      This property references the development info section.
      \sa InfoSection
      \internal
    */
    property alias _develInfoSection: _develInfo

    /*!
      This property references the license info section.
      \sa InfoSection
      \internal
    */
    property alias _licenseInfoSection: _licenseInfo

    /*!
      This property references the donations info section.
      \sa InfoSection
      \internal
    */
    property alias _donationsInfoSection: _donationsInfo

    /*!
      This property holds attribution info about the app itself as a \c Attribution object.
      \sa Attribution
      \internal
    */
    readonly property Attribution _effectiveSelfAttribution: Attribution {
        name: appName
        entries: __effectiveMainAttribs
        licenses: page.licenses
        homepage: homepageUrl
        sources: sourcesUrl
    }

    /*!
      This function shows a page that lets the user preview
      an external link (\a externalUrl) before either copying it to the clipboard
      or opening it externally. The \a title argument is optional.

      It simply uses \c {Opal.LinkHandler}. You can also use this module
      directly for more advanced settings.

      \sa Qt::openUrlExternally
    */
    function openOrCopyUrl(externalUrl, title) {
        L.LinkHandler.openOrCopyUrl(externalUrl, title)
    }

    allowedOrientations: Orientation.All

    SilicaFlickable {
        id: _flickable
        contentHeight: column.height
        anchors.fill: parent
        VerticalScrollDecorator { }

        onContentHeightChanged: {
            if (_flickable.contentHeight > page.height &&
                    _flickable.contentHeight - _pageHeader.origHeight +
                    Theme.paddingMedium < page.height) {
                var to = (page.height - (_flickable.contentHeight-_pageHeader.origHeight)) / 2 + Theme.paddingMedium
                if (to < paddingAnim.to) paddingAnim.to = to
                // console.count("[About] shrink: "+paddingAnim.to+" "+_pageHeader.origHeight+" p:"+page.height+" f:"+flickable.contentHeight)
                hideAnim.restart()
            } /* else {
                console.count("[About] no shrink: "+_pageHeader.height)
            } */
        }

        Column {
            id: column
            width: parent.width
            spacing: 1.5*Theme.paddingLarge

            PageHeader {
                id: _pageHeader
                property real origHeight: height
                title: qsTranslate("Opal.About", "About")
                Component.onCompleted: origHeight = height

                ParallelAnimation {
                    id: hideAnim
                    FadeAnimator {
                        target: _pageHeader
                        to: 0.0
                        duration: 80
                    }
                    SmoothedAnimation {
                        id: paddingAnim
                        target: _pageHeader
                        property: "height"
                        to: _pageHeader.origHeight
                        duration: 80
                    }
                }
            }

            Image {
                id: _icon
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.itemSizeExtraLarge
                height: Theme.itemSizeExtraLarge
                fillMode: Image.PreserveAspectFit
                source: appIcon
                verticalAlignment: Image.AlignVCenter
            }

            Column {
                width: parent.width - 2*Theme.horizontalPageMargin
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingSmall

                Label {
                    width: parent.width
                    visible: appName !== ""
                    text: appName
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeLarge
                    horizontalAlignment: Text.AlignHCenter
                }

                Label {
                    width: parent.width
                    visible: String(appVersion) !== ""
                    text: qsTranslate("Opal.About", "Version %1").
                        arg(Func.formatAppVersion(appVersion, appRelease, appReleaseType))
                    wrapMode: Text.Wrap
                    color: Theme.secondaryHighlightColor
                    font.pixelSize: Theme.fontSizeMedium
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 2*Theme.horizontalPageMargin
                text: description
                onLinkActivated: openOrCopyUrl(link)
                wrapMode: Text.Wrap
                textFormat: Text.StyledText
                horizontalAlignment: Text.AlignHCenter
                linkColor: palette.secondaryColor
                palette.primaryColor: Theme.highlightColor
            }

            InfoSection {
                id: _develInfo
                width: parent.width
                title: qsTranslate("Opal.About", "Development")
                enabled: autoAddOpalAttributions ||
                         contributionSections.length > 0 ||
                         attributions.length > 0
                text: __effectiveMainAttribs.join(', ')
                showMoreLabel: qsTranslate("Opal.About", "show contributors")
                onClicked: {
                    pageStack.animatorPush("private/ContributorsPage.qml", {
                                               'appName': appName,
                                               'sections': contributionSections,
                                               'attributions': attributions,
                                               'mainAttributions': __effectiveMainAttribs,
                                               'allowDownloadingLicenses': allowDownloadingLicenses,
                                               'autoAddOpalAttributions': autoAddOpalAttributions
                                           })
                }

                buttons: [
                    InfoButton {
                        text: qsTranslate("Opal.About", "Homepage")
                        onClicked: openOrCopyUrl(homepageUrl, text)
                        enabled: homepageUrl !== ''
                    },
                    InfoButton {
                        text: qsTranslate("Opal.About", "Changelog")
                        onClicked: pageStack.animatorPush(
                            Qt.resolvedUrl("private/ChangelogPage.qml"),
                            {appName: appName, changelogItems: changelogItems,
                             changelogList: changelogList})
                        enabled: changelogItems.length > 0 || changelogList != ""
                    },
                    InfoButton {
                        text: qsTranslate("Opal.About", "Translations")
                        onClicked: openOrCopyUrl(translationsUrl, text)
                        enabled: translationsUrl !== ''
                    },
                    InfoButton {
                        text: qsTranslate("Opal.About", "Source Code")
                        onClicked: openOrCopyUrl(sourcesUrl, text)
                        enabled: sourcesUrl !== ''
                    }
                ]
            }

            Column {
                width: parent.width
                spacing: parent.spacing
                children: extraSections
            }

            InfoSection {
                id: _donationsInfo
                visible: donations.services.length > 0 || donations.text !== ''
                width: parent.width
                title: qsTranslate("Opal.About", "Donations")
                enabled: false
                text: donations.text === '' ? donations.defaultTextGeneral :
                                              donations.text
                __donationButtons: donations.services
            }

            InfoSection {
                id: _licenseInfo
                width: parent.width
                title: qsTranslate("Opal.About", "License")
                enabled: licenses.length > 0
                onClicked: pageStack.animatorPush("private/LicensePage.qml", {
                    'mainAttribution': _effectiveSelfAttribution,
                    'attributions': attributions,
                    'allowDownloadingLicenses': allowDownloadingLicenses,
                    'enableSourceHint': true,
                    'includeOpal': autoAddOpalAttributions
                })
                text: enabled === false ?
                          "This component has been improperly configured. Please report this bug." :
                          ((licenses[0].name !== "" && licenses[0].error !== true) ?
                               licenses[0].name : licenses[0].spdxId)
                smallPrint: licenses[0].customShortText
                showMoreLabel: qsTranslate("Opal.About", "show license(s)", "", licenses.length+attributions.length)
                clip: true
                Behavior on height { SmoothedAnimation { duration: 80 } }
            }

            Item {
                id: bottomVerticalSpacing
                width: parent.width
                height: Theme.paddingMedium
            }
        }
    }

    Component.onCompleted: {
        // This is a workaround for a bug in Silica.
        // We set the default allowed orientations to "All" to fix
        // switching pages in horizontal mode using pageStack.animatorPush.
        // FIXME Find a better way to fix this.
        if (__silica_applicationwindow_instance &&
                __silica_applicationwindow_instance.hasOwnProperty('_defaultPageOrientations')) {
            __silica_applicationwindow_instance._defaultPageOrientations = Orientation.All
        }
    }
}
