ARCH_ZUBoard_1CG := aarch64
BSP_ZUBoard_1CG := zuboard_1cg.bsp
BITSTREAM_ZUBoard_1CG := ZUBoardOverlay/ZUBoardOverlay.bit
FPGA_MANAGER_ZUBoard_1CG := 1

# Note: for PYNQ v3.0 mraa & ump packages are out of date and deprecated (not installed)
STAGE4_PACKAGES_ZUBoard_1CG := pynq usb-eth1 ethernet pynq_selftest
STAGE4_PACKAGES_ZUBoard_1CG += xrt python_pmbus led-brightness lis2ds ipycanvas
STAGE4_PACKAGES_ZUBoard_1CG += juliabrot py_boot
