.PHONY: all yosys trellis nextpnr openFPGALoader

all: yosys trellis nextpnr openFPGALoader

yosys trellis nextpnr openFPGALoader:
	./build.bash build-$@
	sudo ./build.bash install-$@

nextpnr: trellis
