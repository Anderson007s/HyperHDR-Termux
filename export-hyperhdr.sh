#!/data/data/com.termux/files/usr/bin/bash

DEST="$HOME/hyperhdr-standalone"

mkdir -p "$DEST"

cp -r ~/HyperHDR/build/bin "$DEST/"
cp -r ~/HyperHDR/build/lib "$DEST/"

cp ~/HyperHDR/start-hyperhdr.sh "$DEST/"

tar -czvf hyperhdr-termux.tar.gz hyperhdr-standalone

echo "✔ Exportado para hyperhdr-termux.tar.gz"
