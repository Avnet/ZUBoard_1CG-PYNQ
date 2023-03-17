#!/bin/bash

set -x
set -e

target=$1
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Enabled plugins for JupyterLab
sudo cp $script_dir/boot.py $target/boot/boot.py
sudo chmod +x $target/boot/boot.py
