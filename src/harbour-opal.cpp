/*
 * This file is part of harbour-opal.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020 Mirian Margiani
 */

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include "requires_defines.h"

int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/harbour-opal.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //   - SailfishApp::pathToMainQml() to get a QUrl to the main QML file
    //
    // To display the view, call "show()" (will show fullscreen on device).
    //
    // return SailfishApp::main(argc, argv);

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->engine()->addImportPath(SailfishApp::pathTo("qml/modules").toString());
    view->rootContext()->setContextProperty("APP_VERSION", QString(APP_VERSION));
    view->rootContext()->setContextProperty("APP_RELEASE", QString(APP_RELEASE));
    view->setSource(SailfishApp::pathToMainQml());
    view->show();
    return app->exec();
}
