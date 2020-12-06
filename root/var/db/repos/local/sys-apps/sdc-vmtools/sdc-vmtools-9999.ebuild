# Copyright 2020 Joyent, Inc.

EAPI=7

inherit git-r3

DESCRIPTION="SmartOS lx-brand Guest Tools"
HOMEPAGE="https://github.com/joyent/sdc-vmtools-lx-brand"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

BDEPEND="dev-vcs/git"
DEPEND=""
RDEPEND="app-misc/jq"

EGIT_REPO_URI=${EGIT_REPO_URI:-"https://github.com/ismell/sdc-vmtools-lx-brand.git"}
SRC_URI=""

src_install() {
	# This is how we tell the script which distro we are running
	mkdir -p "${D}/etc"
	touch "${D}/etc/gentoo-release"

	/bin/bash -x ./install.sh -i "${D}"

	rm "${D}/etc/gentoo-release"
	popd
}
