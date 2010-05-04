# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

SLOT="$(get_major_version)"
RDEPEND=">=virtual/jdk-1.6"

MY_PN="WebStorm"
MY_PV="95.57"

RESTRICT="mirror strip"
QA_TEXTRELS="opt/${P}/bin/libbreakgen.so"

DESCRIPTION="WebStorm"
HOMEPAGE="http://jetbrains.com/webstorm/"
SRC_URI="http://download.jetbrains.com/webide/${MY_PN}-EAP-${MY_PV}.tar.gz"
LICENSE="IntelliJ-IDEA"
IUSE=""
KEYWORDS="~x86"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_install() {
	local dir="/opt/${P}"
	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}/bin/webide.sh"
	local exe=${PN}-${SLOT}
	local icon=${exe}.png
	newicon "bin/webide.png" ${icon}
	dodir /usr/bin
	cat > "${D}/usr/bin/${exe}" <<-EOF
#!/bin/sh
/opt/${P}/bin/webide.sh \$@
EOF
	fperms 755 /usr/bin/${exe}
	make_desktop_entry ${exe} "WebStorm ${PV}" ${icon} "Development;IDE"
}
