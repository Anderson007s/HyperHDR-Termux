#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# HyperHDR-Termux installer for Termux (HEADLESS / NO QT)
# Author: Anderson Carlos
#
# Fixes:
#  - Avoids qt5-base / qt5-tools / qt5-serialport
#  - Uses headless build (Qt disabled)
#  - Disables SPI providers (ProviderSpiGeneric link errors)
#  - Works with modern CMake on Termux

REPO_URL="https://github.com/andersoncarlos/HyperHDR-Termux.git"
PROJECT_DIR="$HOME/HyperHDR-Termux"

echo "[*] Updating Termux packages..."
pkg update -y && pkg upgrade -y

echo "[*] Installing build dependencies (Qt disabled)..."

PKGS=(
  git
  cmake
  ninja
  make
  clang
  pkg-config
  python
  perl
  openssl
  zlib
  libusb
  ffmpeg
  libjpeg-turbo
  libpng
  freetype
  harfbuzz
  binutils
)

MISSING=()

for p in "${PKGS[@]}"; do
  echo "  - $p"
  if ! pkg install -y "$p"; then
    echo "    [!] Failed to install: $p (continuing)"
    MISSING+=("$p")
  fi
done

echo
echo "[*] Cloning or updating HyperHDR-Termux..."

if [[ -d "$PROJECT_DIR/.git" ]]; then
  echo "  - Repository exists, pulling latest changes..."
  git -C "$PROJECT_DIR" pull --rebase
else
  git clone --depth=1 "$REPO_URL" "$PROJECT_DIR"
fi

echo
echo "[*] Building HyperHDR (headless)..."
cd "$PROJECT_DIR"

if [[ ! -x "./build.sh" ]]; then
  echo "[!] build.sh not found or not executable."
  echo "    Make sure build.sh exists in the repository."
  exit 1
fi

./build.sh clean

echo
echo "[*] HyperHDR-Termux installation completed successfully."

if (( ${#MISSING[@]} > 0 )); then
  echo
  echo "[!] Some packages failed to install:"
  printf ' - %s\n' "${MISSING[@]}"
  echo "    Tip: run 'termux-change-repo' and choose a fast mirror."
fi
