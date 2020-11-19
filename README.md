# Gentoo lx-brand Image Builder

This is a collection of scripts used for creating an lx-brand [Gentoo
Linux][gentoo] image.

## Requirements

In order to use these scripts you'll need:

- Gentoo Linux running in a VM (required for the `install` script).
- A SmartOS (or SDC headnode) install (required for the `create-lx-image`
  script)

Note that the `install` script will fail if run in an lx-brand environment.

## Usage

### 1. Install Gentoo Linux into a tarball

Run `./install` under Gentoo to install Gentoo Linux in a given directory.  This
will create a tarball of the installation in your working directory (named
`<image name>-<YYMMDD>.tar.gz`).

See `./install -h` for detailed usage.

Dependencies:

    xbps-install git
    xbps-install wget
    xbps-install xz
    git submodule update --init # needed for guesttools

Example:

    # ./install -a x86_64 -d gentoo-install -m https://alpha.de.repo.gentoolinux.org -i gentoo -p 'Gentoo Linux'


### 2. Create a VM image

Copy the tarball generated in step 1 to a SmartOS machine or SDC headnode and
run `./create-lx-image` to create the image.

See `./create-lx-image -h` for detail usage.

Example:

    # ./create-lx-image -t ~/gentoo-20200408.tar.gz -k 5 -m "$(uname -v | cut -d_ -f2)" -i gentoo -d 'Gentoo 64-bit lx-brand image.'

[gentoo]: https://gentoolinux.org
