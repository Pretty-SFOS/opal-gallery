#
# This file is part of Opal Gallery.
#
# SPDX-FileCopyrightText: 2020-2021 Mirian Margiani
# SPDX-License-Identifier: GPL-3.0-or-later
#

# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-opal
CONFIG += sailfishapp

# ---
# Opal gallery configuration
# ---

SOURCES += src/harbour-opal.cpp

DISTFILES += qml/harbour-opal.qml \
    qml/cover/CoverPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/AboutOpalPage.qml \
    qml/pages/AboutModulePageBase.qml \
    qml/module-pages/About.qml \
    qml/module-pages/EmptyDummyPage.qml \
    rpm/harbour-opal.changes.in \
    rpm/harbour-opal.changes.run.in \
    rpm/harbour-opal.spec \
    rpm/harbour-opal.yaml \
    translations/*.ts \
    harbour-opal.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-opal-de.ts \
    translations/harbour-opal-en.ts

# Select Opal modules
CONFIG += opal-about
include(libs/opal-use-modules.pri)

# Note: version number is configured in yaml
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += APP_RELEASE=\\\"$$RELEASE\\\"
include(libs/opal-cached-defines.pri)
