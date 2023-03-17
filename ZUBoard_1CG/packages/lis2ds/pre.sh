#!/bin/bash

set -x
set -e

target=$1
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#sudo cp -f $script_dir/xrt_setup.sh $target/etc/profile.d
cd $BUILD_ROOT/${PYNQ_BOARD}/petalinux_project
petalinux-build -c lis2ds
sudo cp -rf $BUILD_ROOT/${PYNQ_BOARD}/petalinux_project/build/tmp/sysroots-components/*/lis2ds/usr $target
sudo cp -rf $BUILD_ROOT/${PYNQ_BOARD}/petalinux_project/build/tmp/sysroots-components/*/lis2ds/lib $target/usr/

