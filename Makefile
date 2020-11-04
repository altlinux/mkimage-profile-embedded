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

PROJECT = mkimage-profile-embedded
VERSION = 2020.11
EXTRAVERSION =
MPE_CONFIG = .config

all: build-image pack-image
.PHONY: all

include scripts/kconfig.Makefile

MKI_CONFIGDIR = /usr/share/mkimage

include $(MKI_CONFIGDIR)/config.mk

-include $(MPE_CONFIG)

include scripts/utils.Makefile

MPE_MIRROR_TOP_URL := $(call qstrip,$(CONFIG_MPE_MIRROR_TOP_URL))
MPE_PLATFORM := $(call qstrip,$(CONFIG_MPE_PLATFORM))
MPE_ARCH := $(call qstrip,$(CONFIG_MPE_ARCH))
HOST_ARCH := $(shell uname -m)
ifneq ($(MPE_ARCH),$(HOST_ARCH))
GLOBAL_TARGET = $(MPE_ARCH)
ifneq ($(MPE_ARCH),i586)
GLOBAL_HSH_USE_QEMU = $(MPE_ARCH)
endif
ifeq ($(MPE_ARCH),armh)
GLOBAL_HSH_USE_QEMU = arm
endif
endif
ifeq ($(MPE_PLATFORM),sisyphus)
MIRROR_URL = $(MPE_MIRROR_TOP_URL)/Sisyphus
else
MIRROR_URL = $(MPE_MIRROR_TOP_URL)/$(MPE_PLATFORM)/branch
endif

GLOBAL_HSH_APT_CONFIG = output/apt.conf
SOURCES_LIST = output/sources.list
IMAGE_PACKAGES = ./packages
OUTDIR = output/images

MKI_PACK_RESULTS = tar:rootfs.tar

include $(MKI_CONFIGDIR)/targets.mk

prepare: $(OUTDIR) $(GLOBAL_HSH_APT_CONFIG)

$(OUTDIR):
	mkdir -p "$(CURDIR)/$(OUTDIR)"

$(SOURCES_LIST): $(MPE_CONFIG)
	echo > $(SOURCES_LIST)
	echo "rpm $(MIRROR_URL) $(MPE_ARCH) classic" >> $(SOURCES_LIST)
	echo "rpm $(MIRROR_URL) noarch classic" >> $(SOURCES_LIST)

$(GLOBAL_HSH_APT_CONFIG): $(SOURCES_LIST)
	echo > $(GLOBAL_HSH_APT_CONFIG)
	echo 'Dir::Etc::SourceParts "/var/empty";' >> $(GLOBAL_HSH_APT_CONFIG)
	echo 'Dir::Etc::SourceList "$(CURDIR)/$(SOURCES_LIST)";' >> $(GLOBAL_HSH_APT_CONFIG)

.PHONY: clean
clean:
	rm -f "$(CURDIR)/$(OUTDIR)/rootfs.tar"

.PHONY: distclean
distclean: clean
	rm -rf "$(CURDIR)/output" "$(CURDIR)/include"
