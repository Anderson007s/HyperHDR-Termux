
#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "[*] Instalando dependências (Termux)..."
pkg update -y
pkg install -y git cmake ninja clang make pkg-config \
  qt5-base qt5-tools qt5-serialport \
  openssl zstd sqlite libjpeg-turbo

echo "[*] Preparando build..."
rm -rf build
mkdir -p build
cd build

echo "[*] Configurando CMake..."
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release \
  -DENABLE_SPIDEV=OFF \
  -DENABLE_SPI_FTDI=OFF \
  -DENABLE_WS281XPWM=OFF \
  -DENABLE_RPI_WS281X=OFF \
  -DENABLE_V4L2=OFF \
  -DENABLE_PIPEWIRE=OFF \
  -DENABLE_X11=OFF \
  -DENABLE_FRAMEBUFFER=OFF

echo "[*] Compilando..."
ninja -j"$(nproc)"

echo "[OK] Build finalizado: $SCRIPT_DIR/build/bin/hyperhdr"
