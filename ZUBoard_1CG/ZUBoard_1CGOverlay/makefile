overlay_name := ZUBoard_1CGOverlay
design_name := ZUBoard_1CGOverlay


all: git_bdf block_design bitstream check_timing
	@echo
	@tput setaf 2 ; echo "Built $(overlay_name) successfully!"; tput sgr0;
	@echo

.PHONY: git_bdf
git_bdf:
	@if ! [ -f ./bdf/zub1cg/1.0/board.xml ]; then\
		git clone https://github.com/Avnet/bdf ;\
		cd bdf;\
		git checkout 07b475e;\
	fi

block_design:
	vivado -mode batch -source $(overlay_name).tcl -notrace

bitstream:
	vivado -mode batch -source build_bitstream.tcl -notrace

check_timing:
	vivado -mode batch -source check_timing.tcl -notrace

clean:
	rm -rf $(overlay_name) *.jou *.log NA .Xil
