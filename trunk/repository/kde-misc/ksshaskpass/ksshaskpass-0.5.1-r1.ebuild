# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

KDE_MINIMAL="4.1"
inherit kde4-base

DESCRIPTION="KDE implementation of ssh-askpass with Kwallet integration."
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=50971&forumpage=0"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/50971-${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kdeprefix"
RDEPEND="net-misc/openssh"

CFG="ksshaskpass.sh"

src_prepare() {
	kde4-base_src_prepare

	if use kdeprefix; then
		KDE_ENV_STARTUPDIR="${KDEDIR}/env"
		KDE_ENV_SHUTDOWNDIR="${KDEDIR}/shutdown"
	else
		KDE_ENV_STARTUPDIR="/etc/kde/env"
		KDE_ENV_SHUTDOWNDIR="/etc/kde/shutdown"
	fi
}

src_install() {
	kde4-base_src_install

	cat <<-EOF > "${T}/${CFG}"
export SSH_ASKPASS="${PREFIX}/bin/ksshaskpass"
EOF
	insinto "$KDE_ENV_STARTUPDIR"
	doins "${T}/${CFG}" || die "doins ${CFG} failed"
}


pkg_postinst() {
	kde4-base_pkg_postinst


	elog
	elog "In order to have ksshagent start at kde startup,"
	elog "edit ${KDE_ENV_STARTUPDIR}/agent-startup.sh and uncomment"
	elog "the lines enabling ssh-agent."
	elog
	elog "If you do so, do not forget to uncomment the respective"
	elog "lines in ${KDE_ENV_SHUTDOWNDIR}/agent-shutdown.sh to"
	elog "properly kill the agent when the session ends."
	elog
	elog "${PN}-${PV} has been installed as your default askpass application in KDE4 session."
	elog "If it's not desired, point the one you want to use in ${KDE_ENV_STARTUPDIR}/${CFG}"
	elog
}
