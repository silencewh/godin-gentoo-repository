inherit eutils

DESCRIPTION="Maven Repository Manager"
HOMEPAGE="http://nexus.sonatype.org/"
LICENSE="GPL-3"
SRC_URI="http://nexus.sonatype.org/downloads/nexus-oss-webapp-${PV}-bundle.zip"
KEYWORDS="~x86"
SLOT="1.6"
IUSE=""

S="${WORKDIR}"

RDEPEND=">=virtual/jdk-1.5"

INSTALL_DIR="/opt/nexus"

WEBAPP_DIR="${INSTALL_DIR}/nexus-oss-webapp-${PV}"

pkg_setup() {
    #enewgroup <name> [gid]
    enewgroup nexus
    #enewuser <user> [uid] [shell] [homedir] [groups] [params]
    enewuser nexus -1 /bin/bash /opt/nexus "nexus"
}

src_unpack() {
    unpack ${A}
    cd "${S}"

#    epatch "${FILESDIR}/${P}.patch"
}

src_install() {
    insinto ${INSTALL_DIR}
    doins -r nexus-oss-webapp-${PV}

    newinitd "${FILESDIR}/init-${SLOT}.sh" nexus-${SLOT}

    fowners -R nexus:nexus ${INSTALL_DIR}
    fperms 755 "${INSTALL_DIR}/nexus-oss-webapp-${PV}/bin/jsw/linux-x86-32/nexus"
    fperms 755 "${INSTALL_DIR}/nexus-oss-webapp-${PV}/bin/jsw/linux-x86-32/wrapper"
}
