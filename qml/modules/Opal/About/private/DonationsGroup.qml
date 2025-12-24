//@ This file is part of opal-about.
//@ https://github.com/Pretty-SFOS/opal-about
//@ SPDX-FileCopyrightText: 2021 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import ".."

/*!
    \qmltype DonationsGroup
    \inqmlmodule Opal.About.private
    \inherits QtObject
    \brief Defines a way for users to donate to the project.

    This property group holds a list of donation services
    and an accompanying text. Some texts are provided
    for your convenience. The default text is \l defaultTextGeneral.

    If neither a text nor any services are defined, the
    donations section will be hidden.

    \qml
        donations.text: donations.defaultTextCoffee
        donations.services: DonationService {
            name: "LiberaPay"
            url: "liberapay.com"
        }
    \endqml

    \sa AboutPageBase::donations, InfoSection
*/
QtObject {
    /*!
      This property provides a default text asking for donations.

      \quotation
        If you want to support my work, you can buy me a cup of coffee.
      \endquotation
    */
    readonly property string defaultTextCoffee: qsTranslate("Opal.About.Common", "If you want to support my work, you can buy me a cup of coffee.")

    /*!
      This property provides a default text asking for donations.

      You should define more than one service when using this text.

      \note this is the default text.

      \quotation
        You can support this project by contributing, or by donating using any of these services.
      \endquotation
    */
    readonly property string defaultTextGeneral: qsTranslate("Opal.About.Common", "You can support this project by contributing, or by donating using any of these services.")

    /*!
      This property provides a default text, explicitly asking
      for contributions instead of donations.

      It is recommended not to define any services when using this text.

      \quotation
        Your contributions to translations or code would be most welcome.
      \endquotation.
    */
    readonly property string defaultTextContribInstead: qsTranslate("Opal.About.Common", "Your contributions to translations or code would be most welcome.")

    /*!
      This property holds the accompanying text.

      The text will be shown above the list of services, in
      an automatically created info section on the main "About" page.

      If no text is specified, \l defaultTextGeneral will be used.
    */
    property string text: ""

    /*!
      This property holds a list of donation services.

      The list is optional. For example, it is not needed when using the
      \l defaultTextContribInstead default text.
    */
    property list<DonationService> services
}
