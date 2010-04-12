inherit eutils

DESCRIPTION="JBoss Application Server"
HOMEPAGE="http://www.jboss.org/jbossas/"
SRC_URI="mirror://sourceforge/jboss/jboss-${PV}.GA-jdk6.zip"

LICENSE="LGPL-2.1"
SLOT="4.2.3"
KEYWORDS="x86"

IUSE="doc"

RDEPEND=">=virtual/jdk-1.6"
DEPEND="${RDEPEND}"

S="${WORKDIR}/jboss-${PV}.GA"

INSTALL_DIR="/opt/${PF}"

src_unpack() {
    unpack ${A}
    cd ${S}
}

src_install() {
    dodir ${INSTALL_DIR}

    exeinto ${INSTALL_DIR}/bin
    doexe bin/run.sh bin/shutdown.sh bin/twiddle.sh

    insinto ${INSTALL_DIR}/bin
    doins bin/run.jar bin/shutdown.jar bin/twiddle.jar
    doins bin/run.conf

    insinto ${INSTALL_DIR}
    doins -r client lib server
    use doc && doins -r docs
}
