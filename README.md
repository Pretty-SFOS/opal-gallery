# Opal

Opal is a collection of pretty QML components for SailfishOS, building on top
of Sailfish's Silica components.

This repository contains everything needed to package Opal and all its components.

If you want to create new applications using Opal, follow the steps below. If
you want to use applications using Opal, you should not have to do anything. You
can download and install a prebuilt package from OpenRepos (TBD).

## Using Opal

If Opal is installed correctly, you can use it by importing the modules you want
to use. For the About page component, you would have to write:

    import Opal.About 1.0

## Modules

Refer to `qml/harbour-opal.qml` for a list of modules.

## Development

1. Clone this repository e.g. to `src/opal/opal`
2. Clone all module repositories next to the main repository, e.g. `src/opal/<...>`
3. Open the main project in the Sailfish OS IDE
4. Build an RPM package and install it on the target device
5. TBD: setup Opal to be used within QtCreator for other projects

Installing the RPM package will install the Opal Gallery application which
showcases all modules. The module examples can be used as a starting point for
new applications.

If you only want to use certain modules, you can disable the rest by commenting
the respective `include` lines in `harbour-opal.pro`. This way, you do not have
to clone all module repositories.

### Adding new modules

TBD.

1. Create a new repository named `opal-<...>`
2. Create the same structure as in `opal-about` (changing the relevant parts)
3. Write an entry for the new module in `qml/harbour-opal.qml`
4. Create one or more example pages for the new module in `qml/module-pages`

### Adding plugins

TBD.

## License

Currently, all code in this repository is released under the GNU GPL v3 or later.
All modules have their own licensing. Please refer to the respective repositories.

```
Copyright (C) 2020  Mirian Margiani

harbour-opal is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

harbour-opal is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with harbour-opal.  If not, see <http://www.gnu.org/licenses/>.
```

