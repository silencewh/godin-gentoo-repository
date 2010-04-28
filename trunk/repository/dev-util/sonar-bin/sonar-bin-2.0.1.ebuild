inherit java-pkg-2

DESCRIPTION="Sonar is an open platform to manage code quality."
HOMEPAGE="http://sonarsource.org/"
LICENSE="LGPL-3"
SRC_URI="http://dist.sonar.codehaus.org/sonar-${PV}.zip"
SLOT="0"
KEYWORDS="~x86"
IUSE="postgres"

S="${WORKDIR}"

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

    use postgres && epatch "${FILESDIR}"/${P}-postgres.patch

    # TODO remove unneded files

    # Fix permissions
    chmod -R a-x,a+X conf data extensions extras lib war COPYING
}

src_install() {
    insinto ${INSTALL_DIR}
    doins -r sonar-${PV}

    newinitd "${FILESDIR}/init-2.0.1.sh" sonar-2.0.1

    fowners -R sonar:sonar ${INSTALL_DIR}
    fperms 755 "${INSTALL_DIR}/sonar-${PV}/bin/linux-x86-32/sonar.sh"
    fperms 755 "${INSTALL_DIR}/sonar-${PV}/bin/linux-x86-32/wrapper"
}
