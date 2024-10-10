/*
 * This file is part of harbour-opal-gallery.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2023 Mirian Margiani
 */

#include <QtQuick>
#include <sailfishapp.h>
#include "requires_defines.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    app->setOrganizationName("harbour-opal-gallery"); // needed for Sailjail
    app->setApplicationName("harbour-opal-gallery");

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->engine()->addImportPath(SailfishApp::pathTo("qml/modules").toString());
    view->engine()->addImportPath(SailfishApp::pathTo("qml/common").toString());
    view->rootContext()->setContextProperty("APP_VERSION", QString(APP_VERSION));
    view->rootContext()->setContextProperty("APP_RELEASE", QString(APP_RELEASE));

    view->setSource(SailfishApp::pathToMainQml());
    view->show();
    return app->exec();
}
