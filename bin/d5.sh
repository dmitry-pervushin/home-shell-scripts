#!/bin/bash
D5=/home/dimka/projects/nvidia/D5
SRC=/home/dimka/0002
BOARD=lindau-t186

install() {
  pushd $(pwd) > /dev/null
  sudo rm -rf ${D5}

  mkdir -p ${D5}/i
  cd ${D5}/i
  7z x ${SRC}/drive-t186ref-foundation*pdk.7z.001
  7z x ${SRC}/drive-t186ref-linux*pdk.7z.001

  mkdir -p ${D5}/w
  cd ${D5}/w
  export _NV_INSTALL_LICENSE_BYPASS_="Destination Tegra Dominance"
  for run in *foundation*-toolchain.run \
           *foundation*-release-pdk.run \
           *foundation*-oss-src.run \
           *linux*-initramfs.run \
           *linux*-rootfs.run \
           *linux*-oss-minimal-pdk.run \
           *linux*-oss-src.run \
           *linux*-nv-minimal-pdk.run; do
     yes '' | bash ${D5}/i/${run}
  done
  echo "Everything is ready in ${D5}/w"
  popd > /dev/null
}

native() {
  pushd $(pwd) > /dev/null
  cd ${D5}/w
  cd drive*foundation

  cd utils/scripts/bootburn
  bash bootburn.sh -b ${BOARD} -l -k ${D5}/w/drive-t186ref-foundation/utils/scripts/bootburn/$1
  popd > /dev/null
}

native_rt() {
  native quickboot_qspi_rt_linux_initramfs.cfg
}

native_emmc() {
  native quickboot_qspi_linux_fs_16GB.cfg
}

virtualized() {
  pushd $(pwd) > /dev/null
  cd ${D5}/w
  cd drive*foundation

  make -f Makefile.bind BOARD=${BOARD} PCT=$1
  cd utils/scripts/bootburn
  bash bootburn.sh -b ${BOARD}
  popd > /dev/null
}

hv1() {
  virtualized linux-ebp
}

hv2() {
  virtualized linux-ebp-vsc
}

bb-initdir() {
  pushd $(pwd) > /dev/null
  cd ${D5}/w
  cd drive-t186ref-linux_src/yocto
  rm pdk || true
  tar zxf nvidia-layer.tgz
  ln -sf ../.. pdk
  popd > /dev/null
}

bb() {
  pushd $(pwd) > /dev/null
  cd ${D5}/w
  cd drive-t186ref-linux_src/yocto
  export TEMPLATECONF=$PWD/layers/meta-drive5/conf
  source oss/genivi-7/poky/oe-init-build-env
  bitbake $*
  popd > /dev/null
}

install_ebp() {
  cp -v \
      ~/projects/nvidia/v5/linux/out/embedded-linux-t186ref-release/nvidia/kernel_early_boot/kernel/arch/arm64/boot/Image \
      ${D5}/w/drive-t186ref-linux/kernel/Image.ebp

  cp -v \
      ~/projects/nvidia/v5/foundation/embedded/tools/boards/t186ref/tegra-early-boot-rootfs.cpio \
      ${D5}/w/drive-t186ref-linux/kernel/tegra-early-boot-rootfs-tegra-t18x.cpio
}

$*
