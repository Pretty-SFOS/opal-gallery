//@ This file is part of opal-about.
//@ https://github.com/Pretty-SFOS/opal-about
//@ SPDX-FileCopyrightText: 2021 Mirian Margiani
//@ SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0

/*!
    \qmltype DonationService
    \inqmlmodule Opal.About
    \inherits QtObject
    \brief Defines a way for users to donate to the project.

    Donation services are defined as part of the \c donations
    group in \l AboutPageBase.

    \qml
        donations.text: donations.defaultTextCoffee
        donations.services: DonationService {
            name: "LiberaPay"
            url: "liberapay.com"
        }
    \endqml

    \sa AboutPageBase::donations, DonationsGroup
*/
QtObject {
    /*!
      This property holds the name of this service.

      The service will be identified through its name. Users
      normally don't see the URL (\l url).

      \required
    */
    property string name

    /*!
      This property holds the URL of this service.

      The URL should lead directly to a donation page,
      \e not to the main page of the provider.

      \required
    */
    property string url
}
