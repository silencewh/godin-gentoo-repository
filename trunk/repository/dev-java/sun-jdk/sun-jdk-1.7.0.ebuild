# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit versionator java-vm-2 eutils pax-utils

#UPDATE="$(get_version_component_range 4)"
#UPDATE="${UPDATE#0}"
#MY_PV="$(get_version_component_range 2)u${UPDATE}"
MY_PV="7"
X86_AT="jdk-${MY_PV}-linux-i586.tar.gz"
AMD64_AT="jdk-${MY_PV}-linux-x64.tar.gz"

if use x86; then
	AT=${X86_AT}
elif use amd64; then
	AT=${AMD64_AT}
fi

JCE_DIR="UnlimitedJCEPolicy"
JCE_FILE="${JCE_DIR}JDK7.zip"
JCE_URI="http://download.oracle.com/otn-pub/java/jce/7/${JCE_FILE}"

DESCRIPTION="Sun's Java SE Development Kit"
HOMEPAGE="http://java.sun.com/javase/"
SRC_URI="x86? ( ${X86_AT} )
		amd64? ( ${AMD64_AT} )
	jce? ( ${JCE_URI} )"
SLOT="1.7"
LICENSE="BCL-JAVASE"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip fetch"
IUSE="X alsa derby doc examples jce nsplugin odbc"

#QA_TEXTRELS_x86="opt/${P}/jre/lib/i386/motif21/libmawt.so
#	opt/${P}/jre/lib/i386/libdeploy.so
#	opt/${P}/jre/lib/i386/client/libjvm.so
#	opt/${P}/jre/lib/i386/server/libjvm.so"
QA_DT_HASH="opt/${P}/.*"

DEPEND="jce? ( app-arch/unzip )"
RDEPEND="${DEPEND}
	doc? ( =dev-java/java-sdk-docs-1.7.0* )
	sys-libs/glibc
	alsa? ( media-libs/alsa-lib )
	X? (
			x11-libs/libXext
			x11-libs/libXi
			x11-libs/libXp
			x11-libs/libXtst
			amd64? ( x11-libs/libXt )
			x11-libs/libX11
	)
	odbc? ( dev-db/unixODBC )"

JAVA_PROVIDE="jdbc-stdext jdbc-rowset"

S="${WORKDIR}/jdk${PV}"

pkg_nofetch() {
	einfo "Please download ${AT} from:"
	einfo "http://www.oracle.com/technetwork/java/javase/downloads/java-se-jdk-7-download-432154.html"
	einfo "and move it to ${DISTDIR}"

	if use jce; then
		einfo "Also download ${JCE_FILE} from:"
		einfo ${JCE_URI}
		einfo "and move it to ${DISTDIR}"
	fi

}

src_prepare() {
	if use jce; then
		mv "${WORKDIR}"/${JCE_DIR} "${S}"/jre/lib/security/ || die "mv failed"
	fi
}

src_compile() {
	# Set PaX markings on all JDK/JRE executables to allow code-generation on
	# the heap by the JIT compiler. This needs to be done before CDS - #215225
	pax-mark m $(list-paxables "${S}"{,/jre}/bin/*)

	# see bug #207282
	einfo "Creating the Class Data Sharing archives"
	if use x86; then
		"${S}"/bin/java -client -Xshare:dump || die
	fi
	"${S}"/bin/java -server -Xshare:dump || die
}

src_install() {
	local dirs="bin include jre lib man"

	use derby && dirs="${dirs} db"

	dodir /opt/${P}

	cp -pPR $dirs "${D}/opt/${P}/" || die "failed to copy"
	dodoc COPYRIGHT || die
	dohtml README.html || die

	cp -pP src.zip "${D}/opt/${P}/" || die

	if use examples; then
		cp -pPR demo sample "${D}/opt/${P}/" || die
	fi

	if use jce; then
		cd "${D}/opt/${P}/jre/lib/security"
		dodir /opt/${P}/jre/lib/security/strong-jce
		mv "${D}"/opt/${P}/jre/lib/security/US_export_policy.jar \
			"${D}"/opt/${P}/jre/lib/security/strong-jce || die
		mv "${D}"/opt/${P}/jre/lib/security/local_policy.jar \
			"${D}"/opt/${P}/jre/lib/security/strong-jce || die
		dosym /opt/sun-jce-bin-1.6.0/jre/lib/security/${JCE_DIR}/US_export_policy.jar /opt/${P}/jre/lib/security/
		dosym /opt/sun-jce-bin-1.6.0/jre/lib/security/${JCE_DIR}/local_policy.jar /opt/${P}/jre/lib/security/
	fi

	if use nsplugin; then
		local plugin_dir="ns7-gcc29"
		if has_version '>=sys-devel/gcc-3' ; then
			plugin_dir="ns7"
		fi

		# Godin: start of patch
		if use x86 ; then
			install_mozilla_plugin /opt/${P}/jre/lib/i386/libnpjp2.so
			install_mozilla_plugin /opt/${P}/jre/plugin/i386/$plugin_dir/libjavaplugin_oji.so old_oji
		else
			install_mozilla_plugin /opt/${P}/jre/lib/amd64/libnpjp2.so
		fi
		#install_mozilla_plugin /opt/${P}/jre/lib/${ARCH}/libnpjp2.so
		# Godin: end of patch
	fi

	# create dir for system preferences
	dodir /opt/${P}/jre/.systemPrefs
	# Create files used as storage for system preferences.
	touch "${D}"/opt/${P}/jre/.systemPrefs/.system.lock
	chmod 644 "${D}"/opt/${P}/jre/.systemPrefs/.system.lock
	touch "${D}"/opt/${P}/jre/.systemPrefs/.systemRootModFile
	chmod 644 "${D}"/opt/${P}/jre/.systemPrefs/.systemRootModFile

	if [[ -f "${D}"/opt/${P}/jre/plugin/desktop/sun_java.desktop ]]; then
		# install control panel for Gnome/KDE
		# The jre also installs these so make sure that they do not have the same
		# Name
		sed -e "s/\(Name=\)Java/\1 Java Control Panel for Sun JDK ${SLOT}/" \
			-e "s#Exec=.*#Exec=/opt/${P}/jre/bin/ControlPanel#" \
			-e "s#Icon=.*#Icon=/opt/${P}/jre/plugin/desktop/sun_java.png#" \
			"${D}"/opt/${P}/jre/plugin/desktop/sun_java.desktop > \
			"${T}"/sun_jdk-${SLOT}.desktop

		domenu "${T}"/sun_jdk-${SLOT}.desktop
	fi

	# bug #56444
	insinto /opt/${P}/jre/lib/
	newins "${FILESDIR}"/fontconfig.Gentoo.properties fontconfig.properties

	set_java_env
	java-vm_revdep-mask
}
