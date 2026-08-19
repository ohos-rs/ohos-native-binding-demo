#!/usr/bin/env -S just --justfile

# Default: show available targets
_default:
    @just --list -u

# Build the Rust examples in the bindings repo and sync .so/.d.ts into this
# project. Optional args select specific example dirs (default: all).
#   just sync-rust
#   just sync-rust arkui vsync
sync-rust *demos:
    ./scripts/sync-rust.sh {{demos}}

# Package the debug hap with arkdown.
build-hap:
    arkdown build --project . --target hap --mode debug

# Install the built hap to the connected device.
install:
    hdc install -r entry/build/default/outputs/default/entry-default-signed.hap

# Launch the app on the connected device.
start:
    hdc shell "aa start -a EntryAbility -b com.richerfu.h_openconnect"

# Full pipeline: rust sync -> hap -> install -> launch.
run *demos: sync-rust(demos) build-hap install start

# Format all ArkTS sources with oxk.
format:
    pnpm exec oxk format entry/

# Lint all ArkTS sources with oxk (warnings report, errors fail).
lint:
    pnpm exec oxk lint entry/

# Run all prek hooks (format + lint + artifact guard) on every file.
check:
    pnpm exec prek run --all-files

# Remove build outputs.
clean:
    rm -rf entry/build .hvigor oh_modules entry/oh_modules node_modules
