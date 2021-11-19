#!/bin/bash
#
# This file is part of Opal Gallery.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# SPDX-FileCopyrightText: 2021 Mirian Margiani
#

# TODO error checking and handling

cQML_MODULES=(about tabbar)
missing=()

for module in "${cQML_MODULES[@]}"; do
    if [[ ! -d "../opal-$module" ]]; then
        missing+=("$module")
    fi
done

if (( ${#missing[@]} > 0 )); then
    echo "Please clone the following repositories next to opal-gallery (../opal-...):"
    printf -- "- https://github.com/Pretty-SFOS/opal-%s\n" "${missing[@]}"
    exit 128
fi

base="$(pwd)"
rm -rf "$base/qml/modules/Opal"* && mkdir -p "$base/qml/modules"
rm -rf "$base/libs/opal-translations" && mkdir -p "$base/libs/opal-translations"
rm -rf "$base/qml/module-pages" && mkdir -p "$base/qml/module-pages"

list_elements=()

for module in "${cQML_MODULES[@]}"; do
    cd "$base"
    cd "../opal-$module"

    echo "importing module $module..."

    # ./release-module.sh -b _for_gallery
    # TODO extract build/_for_gallery.tar.gz instead of copying files manually

    if [[ ! -d Opal || ! -f doc/gallery.qml || ! -x release-module.sh ]]; then
        echo "error: module '$module' is missing required files"
        continue
    fi

    if [[ -d translations ]]; then
        cp -r translations "$base/libs/opal-translations/opal-$module"
    fi

    cp -r Opal "$base/qml/modules"
    rm -rf "$base/qml/module-pages/opal-$module"
    mkdir -p "$base/qml/module-pages/opal-$module"
    cp "doc/gallery.qml" "$base/qml/module-pages/opal-$module/$(./release-module.sh -c nameStyled).qml"

    extras=($(./release-module.sh -c extraGalleryPages))

    if (( ${#extras[@]} != 0 )) && [[ "${extras[0]}" != none ]]; then
        for x in "${extras[@]}"; do
            cp "doc/gallery/$x" "$base/qml/module-pages/opal-$module/"
        done
    fi

    # enable empty dummy page to be used directly from module example pages
    _b="$(pwd)"
    cd "$base/qml/module-pages/opal-$module/"
    ln -s ../../pages/EmptyDummyPage.qml EmptyDummyPage.qml
    cd "$_b"

    mapfile -t maintainers <<<"$(./release-module.sh -c maintainers | tr ':' '\n')"
    mapfile -t authors <<<"$(./release-module.sh -c authors | tr ':' '\n')"
    mapfile -t attributions <<<"$(./release-module.sh -c attribution)"

    for peop in "${!authors[@]}"; do
        v="${authors[$peop]}"
        authors[$peop]="${v//\'/\\\'}"  # escape apostrophes
    done

    for peop in "${!maintainers[@]}"; do
        v="${maintainers[$peop]}"
        maintainers[$peop]="${v//\'/\\\'}"  # escape apostrophes

        for author in "${!authors[@]}"; do
            if [[ "${maintainers[$peop]}" == "${authors[$author]}" ]]; then
                authors[$author]=''  # remove duplicate
            fi
        done
    done

    list_elements+=("\
        {
            title: \"$(./release-module.sh -c fullNameStyled)\",
            description: QT_TRANSLATE_NOOP(\"ModuleDescriptions\", \"$(./release-module.sh -c description)\"),
            appVersion: \"$(./release-module.sh -c version)\",
            mainAttributions: [$(printf -- "'%s'," "${attributions[@]}" | sed -Ee "s/''//g;s/[,]+/,/g;s/,$//")],
            maintainers: [$(printf -- "'%s'," "${maintainers[@]}" | sed -Ee "s/''//g;s/[,]+/,/g;s/,$//")],
            contributors: [$(printf -- "'%s'," "${authors[@]}" | sed -Ee "s/''//g;s/[,]+/,/g;s/,$//")],
            mainLicenseSpdx: \"$(./release-module.sh -c mainLicenseSpdx)\",
            sourcesUrl: \"https://github.com/Pretty-SFOS/opal-$module\",
            examplePage: \"opal-$module/$(./release-module.sh -c nameStyled).qml\"
        },")
    cd "$base"
done

cd "$base"
echo "configuring qml/harbour-opal-gallery.qml..."
cat <(awk '/>>> GENERATED LIST OF MODULES/ {s=1;print $0;} !s' qml/harbour-opal-gallery.qml) \
    <(printf "%s\n" "${list_elements[@]}" | head -n -1; echo '        }') \
    <(awk '/<<< GENERATED LIST OF MODULES/ {s=1;} s' qml/harbour-opal-gallery.qml) \
        | sponge qml/harbour-opal-gallery.qml
