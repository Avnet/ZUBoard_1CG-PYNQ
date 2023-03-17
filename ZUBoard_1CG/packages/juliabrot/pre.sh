#!/bin/bash

set -x
set -e

target=$1
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Add zuboard 1cg custom notebook, move it in qemu.sh to final destination
sudo cp $script_dir/juliabrot-zoom.ipynb $target/home/xilinx/
