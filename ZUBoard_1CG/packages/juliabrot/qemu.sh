#! /bin/bash

set -x
set -e

# Pull in env vars like PYNQ_JUPYTER_NOTEBOOKS to this script
. /etc/environment
for f in /etc/profile.d/*.sh; do source $f; done

cd $PYNQ_JUPYTER_NOTEBOOKS
git clone https://github.com/FredKellerman/PYNQ-juliabrot -b v1.0.3
cd PYNQ-juliabrot
rm -rf .git
rm .gitignore
echo "https://github.com/FredKellerman/PYNQ-juliabrot" > github-url.txt
# Add zuboard 1cg custom notebook over top of generic one
mv -f /home/xilinx/juliabrot-zoom.ipynb $PYNQ_JUPYTER_NOTEBOOKS/PYNQ-juliabrot/
chown -R xilinx:xilinx ./
