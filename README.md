<!--
SPDX-FileCopyrightText: 2021 Mirian Margiani
SPDX-License-Identifier: GFDL-1.3-or-later
-->

# Opal

Opal is a collection of pretty QML components for SailfishOS, building on top
of Sailfish's Silica components.

This repository contains the Opal Gallery application which showcases all
modules. The module examples can be used as a starting point for new
applications.

You can find documentation on how to use Opal in other applications
[in the main repo](https://github.com/Pretty-SFOS/opal). If you want to use
applications using Opal, you should not have to do anything.


## Development

1. Clone this repository e.g. to `src/opal/opal`
2. Run [fetch-modules.sh](fetch-modules.sh) to fetch the latest module sources, clone required
   module repositories as requested
3. Open the project file [harbour-opal-gallery.pro](harbour-opal-gallery.pro) in the Sailfish OS IDE
4. Build an RPM package and install it on the target device


### Adding new modules

Please refer to [the main repo](https://github.com/Pretty-SFOS/opal) for
documentation on how to setup new modules.

Module metadata and examples live in the respective repositories. After the new
module is properly prepared, register it in [fetch-modules.sh](fetch-modules.sh).
Run the script to include the new module in Opal Gallery.


## License

The Opal Gallery application is released under the GNU GPL v3 or later.

    harbour-opal-gallery is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    harbour-opal-gallery is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with harbour-opal-gallery.  If not, see <http://www.gnu.org/licenses/>.

All Opal [modules](https://github.com/Pretty-SFOS/opal/blob/main/README.md) have
their own licensing. You can find more information about each module by opening
their "About" pages in the Gallery app, or simply refer to the respective
repositories.

All documentation is released under the terms of the
[GFDL-1.3-or-later](https://spdx.org/licenses/GFDL-1.3-or-later.html).

    Permission is granted to copy, distribute and/or modify this document
    under the terms of the GNU Free Documentation License, Version 1.3
    or any later version published by the Free Software Foundation;
    with the Invariant Sections being [none yet], with the Front-Cover Texts
    being [none yet], and with the Back-Cover Texts being [none yet].
    You should have received a copy of the GNU Free Documentation License
    along with this document.  If not, see <http://www.gnu.org/licenses/>.
