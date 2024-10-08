#!/bin/bash
#
# This file is part of Opal Gallery.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# SPDX-FileCopyrightText: 2021-2023 Mirian Margiani
#

# TODO error checking and handling

cQML_MODULES=(
    about
    supportme
    delegates
    dragdrop
    smartscrollbar
    infocombo
    combodata
    menuswitch
    linkhandler
)
missing=()

for module in "${cQML_MODULES[@]}"; do
    if [[ ! -d "../opal-$module" ]]; then
        missing+=("$module")
    fi
done

if [[ ! -d ../opal ]]; then
    echo "Please clone the Opal development repository next to opal-gallery (../opal):"
    echo
    printf -- "\t%s\n" "cd $(dirname "$(pwd)")"
    printf -- "\t%s\n" "git clone https://github.com/Pretty-SFOS/opal"
    echo
    exit 128
fi

if (( ${#missing[@]} > 0 )); then
    echo "Please clone the following repositories next to opal-gallery (../opal-...):"
    echo
    printf -- "\t%s\n" "cd $(dirname "$(pwd)")"
    printf -- "    git clone https://github.com/Pretty-SFOS/opal-%s && \\\\\n" "${missing[@]}"
    echo "        echo 'all repositories cloned'"
    echo
    exit 128
fi

base="$(pwd)"
rm -rf "$base/qml/modules/Opal"* && mkdir -p "$base/qml/modules"
rm -rf "$base/libs/opal-translations" && mkdir -p "$base/libs/opal-translations"
rm -rf "$base/qml/module-pages" && mkdir -p "$base/qml/module-pages"

list_elements=()
details_elements=()
attribution_elements=()

for module in "${cQML_MODULES[@]}"; do
    # shellcheck disable=SC2164
    cd "$base"
    # shellcheck disable=SC2164
    cd "../opal-$module"

    fullNameStyled="$(./release-module.sh -c fullNameStyled)"
    nameStyled="$(./release-module.sh -c nameStyled)"

    echo "importing module $fullNameStyled ($module)..."

    if [[ ! -d Opal || ! -f doc/gallery.qml || ! -x release-module.sh ]]; then
        echo "error: module '$module' is missing required files  (/Opal /doc/gallery.qml or /release-module.sh)"
        continue
    fi

    # -- import module release bundle
    ./release-module.sh --no-minify -b _for_gallery

    tar -C "$base" --strip-components=1 -xzvf ./build/_for_gallery.tar.gz "opal-$(./release-module.sh -c name)/libs"
    tar -C "$base" --strip-components=1 -xzvf ./build/_for_gallery.tar.gz "opal-$(./release-module.sh -c name)/qml"

    mkdir -p "$base/qml/module-pages/opal-$module/gallery"
    cp "doc/gallery.qml" "$base/qml/module-pages/opal-$module/gallery.qml"
    # sed -i "s/qsTr(/qsTranslate(\"${fullNameStyled//\//\\\/}.Gallery\", /g" "$base/qml/module-pages/opal-$module/gallery.qml"
    sed -i "s/qsTr(/qsTranslate(\"${nameStyled//\//\\\/}\", /g" "$base/qml/module-pages/opal-$module/gallery.qml"

    mapfile -t extras <<<"$(./release-module.sh -c extraGalleryPages | tr ' ' '\n')"

    if (( ${#extras[@]} != 0 )) && [[ "${extras[0]}" != none ]]; then
        for x in "${extras[@]}"; do
            infile="doc/gallery/$x"
            outfile="$base/qml/module-pages/opal-$module/gallery/$x"

            [[ -z "$x" || ! -f "$infile" ]] && continue

            cp "$infile" "$outfile"

            # FIXME Workaround for ListModel not supporting qsTranslate():
            #       skip all files that are called SomethingModel.qml
            if [[ "$x" == *.qml || "$x" == *.js ]] && [[ "$x" != *Model.qml ]]; then
                extraModule="$(basename "$x")"
                extraModule="${extraModule%.qml}"
                extraModule="${extraModule%.js}"

                sed -i "s/qsTr(/qsTranslate(\"${fullNameStyled//\//\\\/}.$extraModule.Gallery\", /g" "$outfile"
            fi
        done
    fi

    rmdir --ignore-fail-on-non-empty "$base/qml/module-pages/opal-$module/gallery"

    # enable empty dummy page to be used directly from module example pages
    _b="$(pwd)"
    # shellcheck disable=SC2164
    cd "$base/qml/module-pages/opal-$module/"
    ln -s ../../pages/EmptyDummyPage.qml EmptyDummyPage.qml
    # shellcheck disable=SC2164
    cd "$_b"

    mapfile -t maintainers <<<"$(./release-module.sh -c maintainers | tr ':' '\n')"
    mapfile -t authors <<<"$(./release-module.sh -c authors | tr ':' '\n')"
    mapfile -t attributions <<<"$(./release-module.sh -c attribution | tr ':' '\n')"

    for peop in "${!authors[@]}"; do
        v="${authors[$peop]}"
        # shellcheck disable=SC2004
        authors[$peop]="${v//\'/\\\'}"  # escape apostrophes
    done

    for peop in "${!attributions[@]}"; do
        v="${attributions[$peop]}"
        # shellcheck disable=SC2004
        attributions[$peop]="${v//\'/\\\'}"  # escape apostrophes
    done

    for peop in "${!maintainers[@]}"; do
        v="${maintainers[$peop]}"
        # shellcheck disable=SC2004
        maintainers[$peop]="${v//\'/\\\'}"  # escape apostrophes

        for author in "${!authors[@]}"; do
            if [[ "${maintainers[$peop]}" == "${authors[$author]}" ]]; then
                # shellcheck disable=SC2004
                authors[$author]=''  # remove duplicate
            fi
        done
    done

    details_elements+=("\
        \"$(./release-module.sh -c fullName)\": {
            appName: \"$(./release-module.sh -c fullNameStyled)\",
            description: QT_TRANSLATE_NOOP(\"ModuleDescriptions\", \"$(./release-module.sh -c description)\"),
            appVersion: \"$(./release-module.sh -c version)\",
            mainAttributions: [$(printf -- "'%s'," "${attributions[@]}" | sed -Ee "s/''//g;s/[,]+/,/g;s/,$//")],
            maintainers: [$(printf -- "'%s'," "${maintainers[@]}" | sed -Ee "s/''//g;s/[,]+/,/g;s/,$//")],
            contributors: [$(printf -- "'%s'," "${authors[@]}" | sed -Ee "s/''//g;s/[,]+/,/g;s/,$//")],
            mainLicenseSpdx: \"$(./release-module.sh -c mainLicenseSpdx)\",
            sourcesUrl: \"https://github.com/Pretty-SFOS/opal-$module\"
        },")

    list_elements+=("\
        ListElement {
            key: \"$(./release-module.sh -c fullName)\"
            title: \"$(./release-module.sh -c fullNameStyled)\"
            description: QT_TRANSLATE_NOOP(\"ModuleDescriptions\", \"$(./release-module.sh -c description)\")
            mainLicenseSpdx: \"$(./release-module.sh -c mainLicenseSpdx)\"
            examplePage: \"opal-$module/gallery.qml\"
            section: \"released\"
        }")

    fullNameStyled="$(./release-module.sh -c fullNameStyled)"
    attribution_elements+=("\
        ${fullNameStyled//./}Attribution {},")

    mkdir -p "$base/dist/screenshots-weblate/opal-$module"

    shopt -s nullglob
    for i in doc/screenshot-*.webp; do
        cp "$i" "$base/dist/screenshots-weblate/opal-$module"
    done

    rmdir --ignore-fail-on-non-empty "$base/dist/screenshots-weblate/opal-$module"

    # shellcheck disable=SC2164
    cd "$base"
done

# shellcheck disable=SC2164
cd "$base"
echo "configuring qml/harbour-opal-gallery.qml..."
cat <(awk '/>>> GENERATED LIST OF MODULE DETAILS/ {s=1;print $0;} !s' qml/harbour-opal-gallery.qml) \
    <(printf "%s\n" "${details_elements[@]}" | head -n -1; echo '        }') \
    <(awk '/<<< GENERATED LIST OF MODULE DETAILS/ {s=1;} s' qml/harbour-opal-gallery.qml) \
        | sponge qml/harbour-opal-gallery.qml

cat <(awk '/>>> GENERATED LIST OF MODULES/ {s=1;print $0;} !s' qml/harbour-opal-gallery.qml) \
    <(printf "%s\n" "${list_elements[@]}" | head -n -1; echo '        }') \
    <(awk '/<<< GENERATED LIST OF MODULES/ {s=1;} s' qml/harbour-opal-gallery.qml) \
        | sponge qml/harbour-opal-gallery.qml

echo "configuring qml/pages/AboutOpalPage.qml..."
cat <(awk '/>>> GENERATED LIST OF ATTRIBUTIONS/ {s=1;print $0;} !s' qml/pages/AboutOpalPage.qml) \
    <(printf "%s\n" "${attribution_elements[@]}" | sed -Ee '$ s/},/}/g') \
    <(awk '/<<< GENERATED LIST OF ATTRIBUTIONS/ {s=1;} s' qml/pages/AboutOpalPage.qml) \
        | sponge qml/pages/AboutOpalPage.qml

# shellcheck disable=SC2164
cd "$base/libs"
echo "merging translations..."
./opal-merge-translations.sh ../translations

# shellcheck disable=SC2164
cd "$base"
echo "updating translations..."
lupdate-qt5 qml src -ts translations/*.ts
lupdate-qt5 -noobsolete qml src -ts translations/*.ts
