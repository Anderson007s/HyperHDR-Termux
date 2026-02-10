# HyperHDR-Termux

Build do **HyperHDR** adaptado para rodar no **Termux (Android)**, focado em uso **headless** (sem interface gráfica).

Este projeto resolve problemas comuns de compilação no Termux moderno:
- Qt5 quebrado → **Qt6**
- CMake ≥ 4
- FlatBuffers funcionando corretamente

---

## 📱 Requisitos

- Android com **Termux** atualizado
- Espaço livre em disco (~1 GB para build)
- Conexão estável (primeira compilação demora)

---

## 🔧 Instalação (Automática – Recomendada)

### 1️⃣ Atualize o Termux

> **Obrigatório** para evitar erros de dependência

```bash
pkg update -y
pkg upgrade -y
```
## 2️⃣ Instale o Git
```bash
pkg install -y git
```

## 3️⃣ Clone o repositório
```bash
git clone https://github.com/Anderson007s/HyperHDR-Termux.git
cd HyperHDR-Termux
```

## 4️⃣ Execute o instalador
```bash
chmod +x install-termux.sh
./install-termux.sh
```
⏳ A compilação pode levar vários minutos na primeira vez.


## ▶️ Executar o HyperHDR

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
http://127.0.0.1:8090
Ou use o IP do aparelho na rede (ex.: http://SEU_IP:8090).
