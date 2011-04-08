# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

LANGS="ar br cs de es fr gl it lt nl pl pt ru si tr zh zh_CN"
inherit qt4-r2 rpm

DESCRIPTION="A KDE dropbox client"
HOMEPAGE="http://kdropbox.deuteros.es/"
SRC_URI="mirror://sourceforge/kdropbox/kfilebox-${PV}/Source/kfilebox-${PV}-29.1.src.rpm"

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=kde-base/kdelibs-4.4.5
	"
RDEPEND="${DEPEND}"

src_unpack () {
    rpm_src_unpack ${A}
    cd "${S}"
    EPATCH_SOURCE="${WORKDIR}" EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" epatch
}

src_install() {
	dobin bin/kfilebox
	MAKEOPTS="${MAKEOPTS} -j1" qt4-r2_src_install

	for lang in ${LANGS}; do
		if ! hasq ${lang} ${LINGUAS}; then
			rm -rf "${D}"/usr/share/locale/${lang}
		fi
	done
}
