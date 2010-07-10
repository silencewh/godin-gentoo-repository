#!/bin/sh

usage() {
    echo "$(basename "$0") package"
    exit 1;
}

if [ $# -ne 1 ]; then
    usage "$0";
fi

DIR="$(dirname "$0")"

appareo --manifest \
    --extra-repository-dir /var/paludis/repositories/gentoo/ \
    --download-dir /usr/portage/distfiles/ \
    --repository-dir $DIR/../repository \
    -P ${1}
