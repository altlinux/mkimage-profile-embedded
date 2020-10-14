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
