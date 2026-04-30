# XYRON AI CLI

Chat dengan **XYRON AI** langsung dari terminal atau Termux (Android).

> Dibuat oleh **ShadowNex**

---

## Install (1 perintah)

**curl:**
```bash
curl -fsSL https://raw.githubusercontent.com/ShadowNex/xyronai/main/install.sh | sh
```

**wget (Termux):**
```bash
wget -qO- https://raw.githubusercontent.com/ShadowNex/xyronai/main/install.sh | sh
```

---

## Cara Pakai

```bash
# Interactive chat
xyron

# Langsung tanya
xyron "siapa kamu?"

# Pilih model
xyron -m v2 "jelasin black hole"
xyron -m v4 "buatin kode python"
```

## Model Tersedia

| Flag | Model | Info |
|------|-------|------|
| `-m v1` | XYRON V1 | DeepSeek · Stabil (default) |
| `-m v2` | XYRON V2 | GLM-5 · Gratis & Cepat |
| `-m v3` | XYRON V3 | GLM-5 · Eksperimental |
| `-m v4` | XYRON V4 | GPT-5 · COPILOT |

## Perintah (mode interaktif)

```
/model v2    → ganti model
/clear       → hapus riwayat
/history     → lihat riwayat
/help        → bantuan
/exit        → keluar
```

---

## Install di Termux

```bash
pkg install nodejs curl
wget -qO- https://raw.githubusercontent.com/ShadowNex/xyronai/main/install.sh | sh
xyron
```
