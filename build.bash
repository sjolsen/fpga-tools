#!/bin/bash

set -euo pipefail

THIS_SCRIPT="$(realpath "$0")"
THIS_DIR="$(dirname "$THIS_SCRIPT")"

PREFIX=/opt/fpga

in-dir() {
    mkdir -p "$1"
    pushd "$1"
    shift
    "$@"
    popd
}

build-yosys() {
    in-dir "$THIS_DIR"/yosys-build make -f "$THIS_DIR"/yosys/Makefile -j"$(nproc)"
}

install-yosys() {
    in-dir "$THIS_DIR"/yosys-build make -f "$THIS_DIR"/yosys/Makefile PREFIX="$PREFIX" install
}

build-trellis() {
    in-dir "$THIS_DIR"/trellis-build cmake -DCMAKE_INSTALL_PREFIX="$PREFIX" -S "$THIS_DIR"/prjtrellis/libtrellis -B .
    in-dir "$THIS_DIR"/trellis-build make -j"$(nproc)"
}

install-trellis() {
    in-dir "$THIS_DIR"/trellis-build make install
}

build-nextpnr() {
    in-dir "$THIS_DIR"/nextpnr-build cmake -D{CMAKE,TRELLIS}_INSTALL_PREFIX="$PREFIX" -DARCH=ecp5 -S "$THIS_DIR"/nextpnr -B .
    in-dir "$THIS_DIR"/nextpnr-build make -j"$(nproc)"
}

install-nextpnr() {
    in-dir "$THIS_DIR"/nextpnr-build make install
}

build-openFPGALoader() {
    in-dir "$THIS_DIR"/openFPGALoader-build cmake -DCMAKE_INSTALL_PREFIX="$PREFIX" -S "$THIS_DIR"/openFPGALoader -B .
    in-dir "$THIS_DIR"/openFPGALoader-build make -j"$(nproc)"
}

install-openFPGALoader() {
    in-dir "$THIS_DIR"/openFPGALoader-build make install
}

"$@"
