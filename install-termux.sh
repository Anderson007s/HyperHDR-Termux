#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/Anderson007s/HyperHDR-Termux.git}"
TARGET_DIR="${TARGET_DIR:-$HOME/HyperHDR-Termux}"
PREFIX_BIN="/data/data/com.termux/files/usr/bin"
CMD_LINK="$PREFIX_BIN/hyperhdr-termux"

ts() { date +"%Y%m%d-%H%M%S"; }

echo "[*] HyperHDR Termux Installer"
echo "    Repo:   $REPO_URL"
echo "    Pasta:  $TARGET_DIR"
echo

# 0) Backup/limpeza de instalação antiga
if [ -d "$TARGET_DIR" ]; then
  BACKUP_DIR="${TARGET_DIR}.backup.$(ts)"
  echo "[*] Instalacao anterior encontrada."
  echo "    Movendo para backup: $BACKUP_DIR"
  mv "$TARGET_DIR" "$BACKUP_DIR"
fi

# Remove comando global antigo se existir
if [ -L "$CMD_LINK" ] || [ -f "$CMD_LINK" ]; then
  echo "[*] Removendo comando antigo: $CMD_LINK"
  rm -f "$CMD_LINK"
fi

# 1) Atualizar Termux e instalar dependencias (somente o essencial)
echo "[*] Atualizando pacotes..."
pkg update -y && pkg upgrade -y

echo "[*] Instalando dependencias essenciais..."
pkg install -y git cmake ninja clang make pkg-config binutils || true

# (Opcional) acesso ao armazenamento (não falha se usuário negar)
if [ ! -d "$HOME/storage" ]; then
  echo "[i] (Opcional) Configurando acesso ao armazenamento: termux-setup-storage"
  termux-setup-storage >/dev/null 2>&1 || true
fi

# 2) Clonar repo
echo "[*] Clonando repositorio..."
git clone --depth=1 "$REPO_URL" "$TARGET_DIR"

cd "$TARGET_DIR"

# 3) Permissoes
echo "[*] Ajustando permissoes..."
chmod +x ./*.sh 2>/dev/null || true
find . -type f -name "*.sh" -exec chmod +x {} \; || true

# 4) Build
if [ -f "./build.sh" ]; then
  echo "[*] Compilando (./build.sh)..."
  ./build.sh
else
  echo "[ERRO] build.sh nao encontrado no repositorio."
  echo "       Verifique se o GitHub tem build.sh na raiz."
  exit 1
fi

# 5) Criar comando global que roda de QUALQUER pasta
echo "[*] Criando comando global: hyperhdr-termux"
cat > "$CMD_LINK" <<EOF
#!/data/data/com.termux/files/usr/bin/bash
set -e
DIR="$TARGET_DIR"
exec "\$DIR/run-hyperhdr.sh"
EOF
chmod +x "$CMD_LINK"

echo
echo "[OK] Instalacao finalizada!"
echo "[*] Para rodar de qualquer lugar:"
echo "    hyperhdr-termux"
echo
echo "[*] Para rodar pela pasta do projeto:"
echo "    cd $TARGET_DIR && ./run-hyperhdr.sh"

