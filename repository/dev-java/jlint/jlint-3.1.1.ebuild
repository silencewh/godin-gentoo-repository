inherit eutils

DESCRIPTION="Jlint will check your Java code and find bugs."
SRC_URI="mirror://sourceforge/jlint/jlint-${PV}.tar.gz"
HOMEPAGE="http://jlint.sourceforge.net/"
LICENSE="GPL"
SLOT="3.0"
KEYWORDS="~x86"

RDEPEND=""
IUSE=""

S="${WORKDIR}/${P}"

src_unpack() {
    unpack ${A}
    cd ${S}
    epatch "${FILESDIR}"/${P}-compile.patch
}

src_install() {
    exeinto /opt/jlint
    doexe jlint

    dosym /opt/jlint/jlint /opt/bin/jlint || die "Installing launcher symlinks failed."
}
