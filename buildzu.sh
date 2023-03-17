#!/bin/bash
################################################################################
#
# The following script should work if you have petalinux 2022.1 and Vivado
# 2022.1 in the path.  A few very common utilities are also used.  This will
# build PYNQ v3.0 for ZUBoard-1CG
#
# Adjust file names and paths of shell variables if needed.
#
################################################################################

##################################
# Various path and file settings #
##################################
BOARD_TYPE="ZUBoard_1CG"
START_DIR=$PWD
MAIN_DIR="$START_DIR/$BOARD_TYPE"
PYNQ_GIT_LOCAL_PATH="$START_DIR/PYNQ-git"
SD_IMAGE_FILE="$START_DIR/$BOARD_TYPE-3.0.1.img"
PYNQ_IMAGE_FILE="$PYNQ_GIT_LOCAL_PATH/sdbuild/output/$BOARD_TYPE-3.0.1.img"
PYNQ_GIT_TAG=v3.0.1
PYNQ_GIT_REPO_URL=https://github.com/Xilinx/PYNQ
CUSTOM_BOARDDIR=$START_DIR
SPEC_DIR=specs
SPEC_NAME="$BOARD_TYPE.spec"
OVERLAY_FILE_PATH="$MAIN_DIR/$BOARD_TYPE""Overlay"
OVERLAY_NAME="$BOARD_TYPE""Overlay"
BSP_FILE="zuboard_1cg.bsp"
BSP_FILE_PATH=$MAIN_DIR
BSP_FILE_URL=https://github.com/Avnet/ZUBoard1CG-PYNQ/releases/download/v3.0.1
ROOTFS_TMP_DIR="$START_DIR/rootfs_tmp"
ROOTFS_ZIP_FILE=jammy.aarch64.3.0.1.tar.gz
PREBUILT_IMAGE_ZIP_FILE=pynq-3.0.1.tar.gz
ROOTFS_IMAGE_FILE_URL=https://bit.ly/pynq_aarch64_v3_0_1
PREBUILT_IMAGE_FILE_URL=https://github.com/Xilinx/PYNQ/releases/download/v3.0.1/pynq-3.0.1.tar.gz

##################################
# Fetching and compiling         #
##################################
echo "Status: building from location: $START_DIR"
echo "Status: creating dir "$ROOTFS_TMP_DIR" to store rootfs tarballs"
mkdir -p $ROOTFS_TMP_DIR

if [ -d "$PYNQ_GIT_LOCAL_PATH" ]; then
	echo "Status: PYNQ repo -> already cloned $PYNQ_GIT_LOCAL_PATH"
else
	echo "Status: Fetching PYNQ git $PYNQ_GIT_LOCAL_PATH"
	git clone --branch $PYNQ_GIT_TAG $PYNQ_GIT_REPO_URL $PYNQ_GIT_LOCAL_PATH --single-branch
	echo "Status: PYNQ repo cloned tag: $PYNQ_GIT_TAG"
fi

if ! [ -f "./_modified_pynq_git" ]; then
	echo "Status: Removing boards to speed up build time and eliminate needing hdmi license"
	cd $PYNQ_GIT_LOCAL_PATH
	echo "" > build.sh
	touch ./_modified_pynq_git
	# Modifiy boot.py to load Overlay, mainly to put out the bright LED!
	echo "# Load Overlay to turn off LED" >> ./sdbuild/packages/bootpy/boot.py
	echo "from pynq import Overlay" >> ./sdbuild/packages/bootpy/boot.py
	echo "Overlay('ZUBoard_1CGOverlay.bit')" >> ./sdbuild/packages/bootpy/boot.py
	# The changes must be committed because PYNQ clones local when it builds
	git commit -am 'remove boards'
	echo "Status: Removed other boards"
	cd $START_DIR
else
	echo "Status: Unused board dirs -> removed prior"
fi

# For PYNQ v3.0 these files must be located under the PYNQ git, so save a copy and just softlink
ln -fs $ROOTFS_TMP_DIR/$ROOTFS_ZIP_FILE $PYNQ_GIT_LOCAL_PATH/sdbuild/prebuilt/pynq_rootfs.aarch64.tar.gz
ln -fs $ROOTFS_TMP_DIR/$PREBUILT_IMAGE_ZIP_FILE $PYNQ_GIT_LOCAL_PATH/sdbuild/prebuilt/pynq_sdist.tar.gz

echo "Status: Fetching pre-built rootfs"
wget -c "$ROOTFS_IMAGE_FILE_URL" -O "$ROOTFS_TMP_DIR/$ROOTFS_ZIP_FILE"
if ! [ -f "$ROOTFS_TMP_DIR/$ROOTFS_ZIP_FILE" ]; then
	echo "Error: Image file $ROOTFS_TMP_DIR/$ROOTFS_ZIP_FILE -> does not exist"
	exit -1
fi

echo "Status: Fetching pre-built PYNQ image file"
wget -c "$PREBUILT_IMAGE_FILE_URL" -O "$ROOTFS_TMP_DIR/$PREBUILT_IMAGE_ZIP_FILE"
if ! [ -f "$ROOTFS_TMP_DIR/$PREBUILT_IMAGE_ZIP_FILE" ]; then
	echo "Error: Image file $ROOTFS_TMP_DIR/$PREBUILT_IMAGE_ZIP_FILE -> does not exist"
	exit -1
fi

echo "Status: Fetching pre-built BSP"
wget -c "$BSP_FILE_URL/$BSP_FILE" -O "$BSP_FILE_PATH/$BSP_FILE"
if ! [ -s "$BSP_FILE_PATH/$BSP_FILE" ]; then
	rm -f "$BSP_FILE_PATH/$BSP_FILE"
	echo "Error: Failed to fetch bsp file!"
	exit -1
fi

if [ -f "$OVERLAY_FILE_PATH/$OVERLAY_NAME.bit" -a -f "$OVERLAY_FILE_PATH/$OVERLAY_NAME.hwh" ] ; then
	echo "Status: $OVERLAY_NAME -> .bit and .hwh already exists"
else
	echo "Status: Building default $OVERLAY_NAME Overlay"
	cd "$OVERLAY_FILE_PATH"
	make clean
	make
	if [ -f "$OVERLAY_NAME.bit" -a -f "$OVERLAY_NAME.hwh" ]; then
   	touch "$OVERLAY_FILE_PATH/$OVERLAY_SEMA_NAME"
		echo "Status: Overlay build SUCCESS but did not verify timing, manually check build log!"
	else
		echo "Status: Overlay build FAILURE"
		exit -1
	fi
fi

cd "$PYNQ_GIT_LOCAL_PATH/sdbuild"
sudo make clean
echo "Status: Building PYNQ SD Image & removed prior PYNQ build (if it existed)"
make PREBUILT="$START_DIR/$ROOTFS_TMP_DIR/$ROOTFS_ZIP_FILE" BOARDDIR="$CUSTOM_BOARDDIR"

if [ -f "$PYNQ_IMAGE_FILE" ]; then
	mv -f "$PYNQ_IMAGE_FILE" "$SD_IMAGE_FILE"
	echo "Status: Done building PYNQ image: $SD_IMAGE_FILE"
	# Optional: 7z compression (much better than zip on binaries)
	#7z a -t7z "$SD_IMAGE_FILE.7z" "$SD_IMAGE_FILE" 
else
	echo "Status: PYNQ build FAILED"
	exit -1
fi

exit 0
