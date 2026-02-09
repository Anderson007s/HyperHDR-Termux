# HyperHDR no Termux – Instalação


## 1. Copiar o backup

Transfira o arquivo do projeto (`HyperHDR-Termux.tar.gz`) para o novo dispositivo.  
Exemplo: o arquivo foi salvo em `~/storage/downloads/HyperHDR-Termux.tar.gz`.

## 2. Extrair o Arquivo

Abra o Termux no dispositivo e execute:

```bash
# Vá para a pasta onde salvou o backup
cd ~/storage/downloads

# Extraia o arquivo
tar -xzvf HyperHDR-Termux.tar.gz

# Entre na pasta do projeto
cd HyperHDR-Termux
```

## 3. Dar permissões aos scripts

Para garantir que os scripts possam ser executados:

```bash
# Torna todos os scripts .sh executáveis
chmod +x *.sh

# Aplica recursivamente em todos os subdiretórios
find . -type f -name "*.sh" -exec chmod +x {} \;
```

## 4. Instalar dependências (se necessário)

Antes de compilar, certifique-se de que o Termux tem os pacotes essenciais:

```bash
pkg update && pkg upgrade -y
pkg install git cmake build-essential clang make -y
```

## 5. Compilar o HyperHDR

No diretório do projeto:

```bash
./build.sh
```

Aguarde até a compilação terminar.

## 6. Executar o HyperHDR

Para iniciar o HyperHDR:

```bash
./run-hyperhdr.sh
```
