#!/bin/sh
# ============================================================
#  XYRON AI — Install Script
#  by ShadowNex
#
#  Usage:
#    curl -fsSL https://raw.githubusercontent.com/ShadowNex/xyronai/main/install.sh | sh
#    wget -qO- https://raw.githubusercontent.com/ShadowNex/xyronai/main/install.sh | sh
# ============================================================

set -e

# Ganti ini sesuai username & repo GitHub lo
GITHUB_USER="ShadowNex"
GITHUB_REPO="xyronai"
GITHUB_BRANCH="main"
CLI_FILE="cli/xyron.mjs"
RAW_URL="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$GITHUB_BRANCH/$CLI_FILE"

CYAN='\033[36m'
GREEN='\033[32m'
RED='\033[31m'
YELLOW='\033[33m'
BOLD='\033[1m'
RESET='\033[0m'

echo ""
echo "${CYAN}${BOLD}╔══════════════════════════════════════╗"
echo "║     XYRON AI — Installer             ║"
echo "║     by ShadowNex                     ║"
echo "╚══════════════════════════════════════╝${RESET}"
echo ""

# ── Cek Node.js ──────────────────────────────────────────────
if ! command -v node >/dev/null 2>&1; then
  echo "${RED}✗ Node.js tidak ditemukan!${RESET}"
  echo ""
  echo "Install dulu:"
  echo "  ${YELLOW}Termux :${RESET} pkg install nodejs"
  echo "  ${YELLOW}Ubuntu :${RESET} sudo apt install nodejs"
  echo "  ${YELLOW}macOS  :${RESET} brew install node"
  echo ""
  exit 1
fi

NODE_VER=$(node -e "process.stdout.write(process.version.slice(1).split('.')[0])")
if [ "$NODE_VER" -lt 18 ]; then
  echo "${RED}✗ Node.js versi $NODE_VER terlalu lama. Butuh Node.js 18+${RESET}"
  echo ""
  echo "  ${YELLOW}Termux :${RESET} pkg upgrade nodejs"
  exit 1
fi
echo "${GREEN}✓ Node.js $(node --version) ditemukan${RESET}"

# ── Tentuin install dir ──────────────────────────────────────
# Termux → $PREFIX/bin | Linux/macOS → /usr/local/bin atau ~/bin
if [ -d "/data/data/com.termux" ]; then
  INSTALL_DIR="$PREFIX/bin"
  IS_TERMUX=1
elif [ -w "/usr/local/bin" ]; then
  INSTALL_DIR="/usr/local/bin"
  IS_TERMUX=0
else
  INSTALL_DIR="$HOME/.local/bin"
  IS_TERMUX=0
  mkdir -p "$INSTALL_DIR"
fi

INSTALL_PATH="$INSTALL_DIR/xyron"
echo "${GREEN}✓ Install dir: $INSTALL_DIR${RESET}"

# ── Download CLI ─────────────────────────────────────────────
echo ""
echo "⬇  Mendownload XYRON AI CLI..."

if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$RAW_URL" -o "$INSTALL_PATH"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$INSTALL_PATH" "$RAW_URL"
else
  echo "${RED}✗ curl atau wget tidak ditemukan!${RESET}"
  echo "  ${YELLOW}Termux:${RESET} pkg install curl"
  exit 1
fi

chmod +x "$INSTALL_PATH"
echo "${GREEN}✓ XYRON AI CLI berhasil diinstall!${RESET}"

# ── Cek PATH ─────────────────────────────────────────────────
echo ""
if ! command -v xyron >/dev/null 2>&1; then
  echo "${YELLOW}⚠  '$INSTALL_DIR' belum ada di PATH lo.${RESET}"
  echo ""
  if [ "$IS_TERMUX" = "0" ]; then
    echo "Tambah ini ke ~/.bashrc atau ~/.zshrc:"
    echo "  ${CYAN}export PATH=\"\$HOME/.local/bin:\$PATH\"${RESET}"
    echo ""
    echo "Lalu jalanin:"
    echo "  ${CYAN}source ~/.bashrc${RESET}"
  fi
  echo ""
  echo "Atau jalanin langsung:"
  echo "  ${CYAN}node $INSTALL_PATH${RESET}"
else
  echo "${GREEN}✓ Perintah 'xyron' siap dipakai!${RESET}"
fi

echo ""
echo "${CYAN}${BOLD}Cara pakai:${RESET}"
echo "  ${CYAN}xyron${RESET}                    → interactive chat"
echo "  ${CYAN}xyron \"tanya apa aja\"${RESET}   → langsung tanya"
echo "  ${CYAN}xyron -m v2 \"pertanyaan\"${RESET} → pilih model"
echo "  ${CYAN}xyron --help${RESET}             → bantuan"
echo ""
echo "${YELLOW}Selamat menggunakan XYRON AI! 🤖${RESET}"
echo ""
