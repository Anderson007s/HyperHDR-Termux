#!/data/data/com.termux/files/usr/bin/bash

#!/bin/bash
# export-hyperhdr.sh - Exporta o projeto HyperHDR-Termux para backup

# Nome do arquivo de backup
BACKUP_FILE="hyperhdr-termux.tar.gz"

# Pasta temporária para organizar os arquivos
TEMP_DIR="hyperhdr-termux-export"

# Cria a pasta temporária
mkdir -p $TEMP_DIR

# Copia os scripts principais
cp run-hyperhdr.sh build.sh $TEMP_DIR/

# Copia todas as pastas essenciais
cp -r sources include cmake scripts resources tests external $TEMP_DIR/

# Copia arquivos de configuração e documentação
cp CMakeLists.txt README.md LICENSE CHANGELOG.md BUILDING.md HyperhdrConfig.h.in $TEMP_DIR/

# Cria o arquivo tar.gz
tar -czvf $BACKUP_FILE $TEMP_DIR

# Remove a pasta temporária
rm -rf $TEMP_DIR

echo "✔ Exportação concluída: $BACKUP_FILE"
