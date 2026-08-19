export TOP=$(pwd)
export TEGRA_TOP=$(pwd)
export TARGET_PRODUCT=t186ref_int
export TOOLCHAIN_PREFIX=arm-none-eabi-
. tmake/scripts/envsetup.sh
choose embedded-foundation t186ref none release external
source foundation-t194/mk_blob.sh
