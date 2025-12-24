/*
 * This file is part of harbour-opal.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2024-2025 Mirian Margiani
 */

import QtQuick 2.0
import Opal.SupportMe 1.0

SupportDialog {
    SupportAction {
        icon: SupportIcon.Liberapay
        title: qsTranslate("Opal.SupportMe", "Donate on %1").arg("Liberapay")
        description: qsTranslate("Opal.SupportMe", "Pay the amount of a cup of coffee, a slice " +
                          "of pizza, or a ticket to the theater.")
        link: "https://liberapay.com/example"
    }

    SupportAction {
        icon: SupportIcon.Weblate
        title: qsTranslate("Opal.SupportMe", "Translate on %1").arg("Weblate")
        description: qsTranslate("Opal.SupportMe", "Help with translating this app in as many " +
                          "languages as possible.")
        link: "https://hosted.weblate.org/projects/example"
    }

    SupportAction {
        icon: SupportIcon.Git
        title: qsTranslate("Opal.SupportMe", "Develop on %1").arg("Codeberg")
        description: qsTranslate("Opal.SupportMe", "Support with maintenance and packaging, " +
                          "write code, or provide valuable bug reports.")
        link: "https://git.example.org/example"
    }

    DetailsDrawer {
        title: qsTranslate("Opal.SupportMe", "Why should you care?")

        DetailsParagraph {
            text: qsTranslate("Opal.SupportMe", "This project is built with love and passion by a " +
                       "single developer in their spare time, and is provided " +
                       "to you free of charge.")
        }

        DetailsParagraph {
            text: qsTranslate("Opal.SupportMe", "I develop Free Software because I am convinced that " +
                       "it is the ethical thing to do - and it is a fun hobby. " +
                       "However, developing software takes a lot of time and effort. " +
                       "As Sailfish and living in general costs money, I need your " +
                       "support to be able to spend time on non-paying projects " +
                       "like this.")
        }
    }

    DetailsDrawer {
        title: qsTranslate("Opal.SupportMe", "Why donate?")

        DetailsParagraph {
            text: qsTranslate("Opal.SupportMe", "If you can afford it, donating is the easiest way " +
                       "to ensure that I can continue working on apps " +
                       "for Sailfish. Any amount is appreciated, be it a cup " +
                       "of coffee, a slice of pizza, or more.")
        }
    }
}
