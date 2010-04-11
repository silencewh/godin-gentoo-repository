EAPI="2"

DESCRIPTION="Maven bash command-line completions"
HOMEPAGE="http://maven.apache.org/"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="app-shells/bash-completion"

src_install() {
    dodir usr/share/bash-completion
    cp "${FILESDIR}/maven" "${D}usr/share/bash-completion" || die "failed to install maven module"
}

pkg_postinst() {
    # can't use bash-completion.eclass.
    elog "To enable command-line completion for maven, run:"
    elog
    elog "  eselect bashcomp enable maven"
    elog
    elog "to install locally, or"
    elog
    elog "  eselect bashcomp enable --global maven"
    elog
    elog "to install system-wide."
}
