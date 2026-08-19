#!/usr/bin/env bash
# Build the Rust examples of ohos-native-bindings and copy the produced
# .so / index.d.ts artifacts into this ArkTS host project.
#
# Usage:
#   scripts/sync-rust.sh              # build every demo
#   scripts/sync-rust.sh arkui vsync  # build only the given example dirs
#
# The bindings repo is located via (in order):
#   1. $OHOS_NATIVE_BINDINGS
#   2. parent of this repo's git root (submodule layout: <bindings>/examples-ui)
#   3. sibling directory ../ohos-native-bindings
set -euo pipefail

DEMO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LIBS_DIR="$DEMO_ROOT/entry/libs/arm64-v8a"
TYPES_DIR="$DEMO_ROOT/entry/src/main/ets/types"

# --- locate the bindings repo -------------------------------------------------
find_bindings() {
  local candidate
  if [ -n "${OHOS_NATIVE_BINDINGS:-}" ]; then
    candidate="$OHOS_NATIVE_BINDINGS"
    if [ -f "$candidate/Cargo.toml" ] && [ -d "$candidate/examples" ]; then
      echo "$candidate"
      return 0
    fi
    echo "error: OHOS_NATIVE_BINDINGS=$candidate does not look like the bindings repo" >&2
    return 1
  fi
  local git_root
  git_root="$(cd "$DEMO_ROOT" && git rev-parse --show-toplevel 2>/dev/null || echo "$DEMO_ROOT")"
  # submodule layout: <bindings-repo>/examples-ui/<this repo>
  candidate="$(dirname "$git_root")"
  if [ -f "$candidate/Cargo.toml" ] && [ -d "$candidate/examples" ]; then
    echo "$candidate"
    return 0
  fi
  # sibling layout: ohos-rs/ohos-native-bindings-demos next to ohos-rs/ohos-native-bindings
  candidate="$DEMO_ROOT/../ohos-native-bindings"
  if [ -f "$candidate/Cargo.toml" ] && [ -d "$candidate/examples" ]; then
    echo "$candidate"
    return 0
  fi
  echo "error: cannot locate the ohos-native-bindings repo." >&2
  echo "  Set OHOS_NATIVE_BINDINGS=<path>, or clone the bindings repo next to this" >&2
  echo "  repo, or check this repo out as a submodule of the bindings repo." >&2
  return 1
}

BINDINGS="$(find_bindings)"
echo "bindings repo: $BINDINGS"

# --- pick demos ----------------------------------------------------------------
ALL_DEMOS=(ark_web arkui display_soloist hilog ime jsvm net_connection pasteboard raw sensor vibrator vsync xcomponent)
if [ $# -gt 0 ]; then
  DEMOS=("$@")
else
  DEMOS=("${ALL_DEMOS[@]}")
fi

mkdir -p "$LIBS_DIR" "$TYPES_DIR"

failed=()
for demo in "${DEMOS[@]}"; do
  example_dir="$BINDINGS/examples/$demo"
  if [ ! -d "$example_dir" ]; then
    echo "error: no such example: $demo ($example_dir missing)" >&2
    failed+=("$demo")
    continue
  fi

  echo "==> [$demo] ohrs build"
  if ! (cd "$example_dir" && ohrs build -a arm64 >/dev/null); then
    echo "error: ohrs build failed for $demo" >&2
    failed+=("$demo")
    continue
  fi

  # The .so name derives from the cargo package name ('-' becomes '_'),
  # not from the directory name (e.g. examples/arkui builds libexample.so).
  so_file="$(find "$example_dir/dist/arm64-v8a" -maxdepth 1 -name '*.so' | head -1 || true)"
  if [ -z "$so_file" ]; then
    echo "error: no .so produced for $demo in $example_dir/dist/arm64-v8a" >&2
    failed+=("$demo")
    continue
  fi

  cp "$so_file" "$LIBS_DIR/"
  cp "$example_dir/dist/index.d.ts" "$TYPES_DIR/$demo.d.ts"
  echo "    $(basename "$so_file") -> entry/libs/arm64-v8a/"
  echo "    index.d.ts       -> entry/src/main/ets/types/$demo.d.ts"
done

if [ ${#failed[@]} -gt 0 ]; then
  echo "FAILED demos: ${failed[*]}" >&2
  exit 1
fi

echo "done: ${#DEMOS[@]} demo(s) synced."
