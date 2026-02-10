#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$ROOT_DIR/build"
BIN=""
LOG_DIR="$HOME/.hyperhdr"
LOG_FILE="$LOG_DIR/hyperhdr.log"
PID_FILE="$LOG_DIR/hyperhdr.pid"

mkdir -p "$LOG_DIR"

find_binary() {
  local candidates=(
    "$BUILD_DIR/bin/hyperhdrd"
    "$BUILD_DIR/bin/hyperhdr"
    "$BUILD_DIR/hyperhdrd"
    "$BUILD_DIR/hyperhdr"
  )
  for b in "${candidates[@]}"; do
    if [[ -x "$b" ]]; then
      BIN="$b"
      return 0
    fi
  done
  echo "[!] HyperHDR binary not found. Build first with ./build.sh"
  exit 1
}

setup_ld_library_path() {
  # HyperHDR builds private shared libs under build/lib (and sometimes build/bin)
  local paths=()

  [[ -d "$BUILD_DIR/lib" ]] && paths+=("$BUILD_DIR/lib")
  [[ -d "$BUILD_DIR/bin" ]] && paths+=("$BUILD_DIR/bin")
  [[ -d "$ROOT_DIR/lib" ]] && paths+=("$ROOT_DIR/lib")

  # Termux system libs
  paths+=("$PREFIX/lib")

  # Merge with existing LD_LIBRARY_PATH
  local joined
  joined="$(IFS=:; echo "${paths[*]}")"
  export LD_LIBRARY_PATH="${joined}${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

  echo "[*] LD_LIBRARY_PATH set to:"
  echo "    $LD_LIBRARY_PATH"
}

start_fg() {
  echo "[*] Starting HyperHDR (foreground)..."
  exec "$BIN"
}

start_bg() {
  if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    echo "[!] HyperHDR is already running (PID $(cat "$PID_FILE"))."
    exit 0
  fi

  echo "[*] Starting HyperHDR (background)..."
  nohup "$BIN" >> "$LOG_FILE" 2>&1 &
  echo $! > "$PID_FILE"

  echo "[*] HyperHDR started."
  echo "    PID: $(cat "$PID_FILE")"
  echo "    Log: $LOG_FILE"
}

stop_bg() {
  if [[ ! -f "$PID_FILE" ]]; then
    echo "[!] No PID file found. Is HyperHDR running?"
    exit 0
  fi

  PID="$(cat "$PID_FILE")"
  if kill -0 "$PID" 2>/dev/null; then
    echo "[*] Stopping HyperHDR (PID $PID)..."
    kill "$PID"
    rm -f "$PID_FILE"
    echo "[*] Stopped."
  else
    echo "[!] Process not running, cleaning PID file."
    rm -f "$PID_FILE"
  fi
}

status() {
  if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    echo "[*] HyperHDR is running (PID $(cat "$PID_FILE"))."
  else
    echo "[*] HyperHDR is not running."
  fi
}

logs() {
  [[ -f "$LOG_FILE" ]] && tail -f "$LOG_FILE" || echo "[!] Log file not found."
}

find_binary
setup_ld_library_path

case "${1:-fg}" in
  fg) start_fg ;;
  bg) start_bg ;;
  stop) stop_bg ;;
  status) status ;;
  logs) logs ;;
  *)
    echo "Usage:"
    echo "  ./run-hyperhdr.sh fg      # run in foreground"
    echo "  ./run-hyperhdr.sh bg      # run in background"
    echo "  ./run-hyperhdr.sh stop    # stop background process"
    echo "  ./run-hyperhdr.sh status  # check status"
    echo "  ./run-hyperhdr.sh logs    # follow logs"
    exit 1
    ;;
esac
