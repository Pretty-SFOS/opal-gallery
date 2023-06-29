dnl/// SPDX-FileCopyrightText: 2021-2023 Mirian Margiani
dnl/// SPDX-License-Identifier: GFDL-1.3-or-later

ifdef(${__X_summary}, ${
Opal is a collection of pretty QML components for SailfishOS, building on top
of Sailfish's Silica components.
})dnl

ifdef(${__X_description}, ${
ifdef(${__X_readme}, ${
This repository contains the __name application which showcases all
modules.
The module examples can be used as a starting point for new applications.

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
Run the script to include the new module in __name.
}, ${
__name is an application which showcases all modules.
The module examples can be used as a starting point for new applications.

## Project status

There are currently a handful of finished modules and useful snippets that are
tried and tested in several apps. The “About” page module and the icon rendering
script are very useful for quick development. All modules are fully documented.

## How to use modules

You can find documentation on how to use Opal in other applications in the main
repo on __forge.

All Opal modules have their own licensing. You can find more information about
each module by opening their “About” pages in the __name app, or simply refer
to the respective repositories.
})dnl
})dnl
