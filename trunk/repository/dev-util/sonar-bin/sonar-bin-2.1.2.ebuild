inherit java-pkg-2

DESCRIPTION="Sonar is an open platform to manage code quality."
HOMEPAGE="http://sonarsource.org/"
LICENSE="LGPL-3"
MY_PV="${PV/_rc/RC}"
MY_P="sonar-${MY_PV}"
SRC_URI="http://dist.sonar.codehaus.org/${MY_P}.zip"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="~x86"
IUSE="postgres"

S="${WORKDIR}/${MY_P}"

RDEPEND=">=virtual/jdk-1.5
            postgres? ( virtual/postgresql-server )"

INSTALL_DIR="/opt/sonar"

pkg_setup() {
    #enewgroup <name> [gid]
    enewgroup sonar
    #enewuser <user> [uid] [shell] [homedir] [groups] [params]
    enewuser sonar -1 /bin/bash /opt/sonar "sonar,postgres"
}

src_unpack() {
    unpack ${A}
    cd "${S}"

    use postgres && epatch "${FILESDIR}"/${MY_P}-postgres.patch

    # TODO remove unneded files

    # Fix permissions
    chmod -R a-x,a+X conf data extensions extras lib war COPYING
}

src_install() {
    insinto ${INSTALL_DIR}
    doins -r bin conf data extensions extras lib logs war COPYING

    newinitd "${FILESDIR}/init.sh" sonar

    fowners -R sonar:sonar ${INSTALL_DIR}
    fperms 755 "${INSTALL_DIR}/bin/linux-x86-32/sonar.sh"
    fperms 755 "${INSTALL_DIR}/bin/linux-x86-32/wrapper"
}
