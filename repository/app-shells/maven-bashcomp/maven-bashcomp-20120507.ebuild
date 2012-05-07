EAPI="2"

inherit eutils

DESCRIPTION="Maven bash command-line completions"
HOMEPAGE="http://maven.apache.org/"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="app-shells/bash-completion
         dev-java/maven-bin"

src_prepare() {
    cp "${FILESDIR}/bash_completion.bash" "${WORKDIR}"
    epatch "${FILESDIR}/gentoo.patch"
}

src_install() {
    insinto /usr/share/bash-completion
    newins bash_completion.bash maven
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
