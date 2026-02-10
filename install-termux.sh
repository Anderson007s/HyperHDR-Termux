#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# HyperHDR-Termux installer for Termux (Qt6 build)
# Author: Anderson Carlos
#
# Fixes/Goals:
#  - Installs Qt6 from x11-repo (termux-x11)
#  - Uses Qt6 build (keeps "no GUI" features disabled via build flags)
#  - Avoids obsolete qt5-* package names
#  - Handles clean install and updates
#  - Works with modern CMake on Termux

REPO_URL="https://github.com/Anderson007s/HyperHDR-Termux.git"
PROJECT_DIR="$HOME/HyperHDR-Termux"

echo "[*] Updating Termux packages..."
pkg update -y
pkg upgrade -y

echo "[*] Enabling x11-repo (required for Qt6)..."
pkg install -y x11-repo || true
pkg update -y

echo "[*] Installing build dependencies..."
# Install in one go (faster + fewer apt lock issues)
pkg install -y \
  git \
  cmake \
  ninja \
  make \
  clang \
  pkg-config \
  python \
  perl \
  openssl \
  zlib \
  libusb \
  ffmpeg \
  libjpeg-turbo \
  libpng \
  freetype \
  harfbuzz \
  binutils \
  x11-repo \
  flatbuffers

echo "[*] Installing Qt6..."
pkg install -y qt6-qtbase qt6-qttools

# Optional: provides Qt6 SerialPort on Termux (usually via connectivity)
# If available, install; otherwise ignore.
if pkg search qt6-qtconnectivity >/dev/null 2>&1; then
  pkg install -y qt6-qtconnectivity || true
fi

echo
echo "[*] Cloning or updating HyperHDR-Termux..."
if [[ -d "$PROJECT_DIR/.git" ]]; then
  echo "  - Repository exists, pulling latest changes..."

  # If there are local changes, stash them to avoid pull --rebase failing
  if [[ -n "$(git -C "$PROJECT_DIR" status --porcelain)" ]]; then
    echo "  - Local changes detected, stashing..."
    git -C "$PROJECT_DIR" stash push -m "auto-stash before install update" >/dev/null
    STASHED=1
  else
    STASHED=0
  fi

  git -C "$PROJECT_DIR" pull --rebase

  # Restore stash if we created one
  if [[ "${STASHED}" -eq 1 ]]; then
    echo "  - Restoring stashed changes..."
    git -C "$PROJECT_DIR" stash pop || {
      echo "  [!] Could not auto-apply stash cleanly. Your changes are saved in stash."
      echo "      Run: git -C \"$PROJECT_DIR\" stash list"
    }
  fi
else
  git clone --depth=1 --recurse-submodules "$REPO_URL" "$PROJECT_DIR"
fi

echo
echo "[*] Building HyperHDR (Qt6)..."
cd "$PROJECT_DIR"

if [[ ! -x "./build.sh" ]]; then
  echo "[!] build.sh not found or not executable."
  echo "    Make sure build.sh exists in the repository and has chmod +x."
  exit 1
fi

./build.sh clean

echo
echo "[*] HyperHDR-Termux installation completed successfully."
echo "    Binary should be in: $PROJECT_DIR/build/bin/hyperhdr"
