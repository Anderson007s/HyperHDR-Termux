#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# HyperHDR-Termux build helper (headless)
# Fix: disable SPI providers to avoid ProviderSpiGeneric undefined symbols
# Also: CMake compatibility fix for old subprojects
#
# Usage:
#   ./build.sh          # build (incremental)
#   ./build.sh clean    # wipe build dir and rebuild
#   ./build.sh run      # build + run hyperhdr (if present)

MODE="${1:-build}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${ROOT_DIR}/build"

need_pkg() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing command: $1"
    echo "Install with: pkg install -y $2"
    exit 1
  }
}

need_pkg cmake cmake
need_pkg ninja ninja
need_pkg clang clang
need_pkg pkg-config pkg-config

if [[ "$MODE" == "clean" ]]; then
  echo "[*] Cleaning build dir..."
  rm -rf "$BUILD_DIR"
fi

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "[*] Configuring (Release, headless, SPI disabled)..."
cmake .. -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
  -DENABLE_QT=OFF -DENABLE_QT5=OFF \
  -DENABLE_X11=OFF \
  -DENABLE_SPIDEV=OFF \
  -DENABLE_SPI_FTDI=OFF

echo "[*] Building..."
ninja -j"$(nproc)"

echo "[*] Build finished."

if [[ "$MODE" == "run" ]]; then
  # Try common output locations
  BIN_CANDIDATES=(
    "$BUILD_DIR/bin/hyperhdr"
    "$BUILD_DIR/hyperhdr"
    "$BUILD_DIR/bin/hyperhdrd"
    "$BUILD_DIR/hyperhdrd"
  )

  for b in "${BIN_CANDIDATES[@]}"; do
    if [[ -x "$b" ]]; then
      echo "[*] Running: $b"
      exec "$b"
    fi
  done

  echo "[!] Built successfully, but couldn't find an executable to run."
  echo "    Check build output under: $BUILD_DIR"
fi
