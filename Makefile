# Makefile for mkimage-profile-embedded
#
# Copyright (C) 2020 by the Evgeny Sinelnikov <sin@altlinux.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

CONFIGDIR = /usr/share/mkimage

include $(CONFIGDIR)/config.mk

GLOBAL_TARGET = aarch64
GLOBAL_HSH_USE_QEMU = aarch64
GLOBAL_HSH_APT_CONFIG = apt.conf
IMAGE_PACKAGES = ./packages
OUTDIR = output/images

MKI_PACK_RESULTS = tar:rootfs.tar

#MIRROR = http://ftp.altlinux.org/pub/distributions/ALTLinux/p9/branch
MIRROR = http://mirror.yandex.ru/altlinux/p9/branch

include $(CONFIGDIR)/targets.mk

all: build-image pack-image

prepare: apt.conf

sources.list:
	echo > sources.list
	echo "rpm $(MIRROR) $(GLOBAL_TARGET) classic" >> sources.list
	echo "rpm $(MIRROR) noarch classic" >> sources.list

apt.conf: sources.list
	echo > apt.conf
	echo 'Dir::Etc::SourceParts "/var/empty";' >> apt.conf
	echo 'Dir::Etc::SourceList "$(CURDIR)/sources.list";' >> apt.conf
