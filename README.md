# HyperHDR-Termux

Build e execução do HyperHDR no **Termux** (Android) em modo **headless** (sem Qt/GUI).

## Requisitos
- Termux atualizado

## Instalação (Termux)
1) Clone o repositório:
```bash
git clone https://github.com/Anderson007s/HyperHDR-Termux.git
cd HyperHDR-Termux
```

2) Rode o instalador do Termux:
```bash
chmod +x install-termux.sh
./install-termux.sh
```

## Build manual
Se quiser compilar manualmente:
```bash
./build.sh clean
```

## Rodar (Termux)
Rodar em foreground (debug):
```bash
./run-hyperhdr.sh fg
```

Rodar em background:
```bash
./run-hyperhdr.sh bg
```

Logs:
```bash
./run-hyperhdr.sh logs
```

Parar:
```bash
./run-hyperhdr.sh stop
```


## Acesso Web UI
Normalmente:
http://127.0.0.1:8090�
Ou use o IP do aparelho na rede (ex.: http://SEU_IP:8090).
