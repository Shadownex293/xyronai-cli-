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

GITHUB_USER="Shadownex293"
GITHUB_REPO="xyronai-cli-"
GITHUB_BRANCH="main"
CLI_FILE="cli/xyron.mjs"
RAW_URL="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$GITHUB_BRANCH/$CLI_FILE"

C_CYAN="\033[36m"
C_GREEN="\033[32m"
C_RED="\033[31m"
C_YELLOW="\033[33m"
C_BOLD="\033[1m"
C_RESET="\033[0m"

pln() { printf "$@\n"; }

# ── Banner ───────────────────────────────────────────────────
printf "\n"
printf "${C_CYAN}${C_BOLD}__  ____   ______   ___  _   _    _    ___       ____ _     ___\n"
printf "\\ \\/ /\\ \\ / /  _ \\ / _ \\| \\ | |  / \\  |_ _|     / ___| |   |_ _|\n"
printf " \\  /  \\ V /| |_) | | | |  \\| | / _ \\  | |_____| |   | |    | |\n"
printf " /  \\   | | |  _ <| |_| | |\\  |/ ___ \\ | |_____| |___| |___ | |\n"
printf "/_/\\_\\  |_| |_| \\_\\\\___/|_| \\_/_/   \\_\\___|     \\____|_____|___|\n"
printf "${C_RESET}\n"
printf "${C_BOLD}              XYRONAI CODEX  —  by ShadowNex${C_RESET}\n"
printf "\n"

# ── Cek Node.js ──────────────────────────────────────────────
if ! command -v node >/dev/null 2>&1; then
  pln "${C_RED}✗ Node.js tidak ditemukan!${C_RESET}"
  printf "\n"
  pln "Install dulu:"
  pln "  ${C_YELLOW}Termux :${C_RESET} pkg install nodejs"
  pln "  ${C_YELLOW}Ubuntu :${C_RESET} sudo apt install nodejs"
  pln "  ${C_YELLOW}macOS  :${C_RESET} brew install node"
  printf "\n"
  exit 1
fi

NODE_VER=$(node -e "process.stdout.write(process.version.slice(1).split('.')[0])")
if [ "$NODE_VER" -lt 18 ]; then
  pln "${C_RED}✗ Node.js versi $NODE_VER terlalu lama. Butuh Node.js 18+${C_RESET}"
  pln "  ${C_YELLOW}Termux :${C_RESET} pkg upgrade nodejs"
  exit 1
fi
pln "${C_GREEN}✓ Node.js $(node --version) ditemukan${C_RESET}"

# ── Tentuin install dir ──────────────────────────────────────
if [ -d "/data/data/com.termux" ]; then
  INSTALL_DIR="$PREFIX/bin"
elif [ -w "/usr/local/bin" ]; then
  INSTALL_DIR="/usr/local/bin"
else
  INSTALL_DIR="$HOME/.local/bin"
  mkdir -p "$INSTALL_DIR"
fi

INSTALL_PATH="$INSTALL_DIR/xyron"
pln "${C_GREEN}✓ Install dir: $INSTALL_DIR${C_RESET}"

# ── Download CLI ─────────────────────────────────────────────
printf "\n"
pln "⬇  Mendownload XYRON AI CLI..."
printf "\n"

if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$RAW_URL" -o "$INSTALL_PATH"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$INSTALL_PATH" "$RAW_URL"
else
  pln "${C_RED}✗ curl atau wget tidak ditemukan!${C_RESET}"
  pln "  ${C_YELLOW}Termux:${C_RESET} pkg install curl"
  exit 1
fi

chmod +x "$INSTALL_PATH"
pln "${C_GREEN}✓ XYRON AI CLI berhasil diinstall!${C_RESET}"

# ── Cek PATH ─────────────────────────────────────────────────
printf "\n"
if ! command -v xyron >/dev/null 2>&1; then
  pln "${C_YELLOW}⚠  Tambah ini ke ~/.bashrc atau ~/.zshrc:${C_RESET}"
  pln "   ${C_CYAN}export PATH=\"\$HOME/.local/bin:\$PATH\"${C_RESET}"
  printf "\n"
  pln "Lalu jalanin: ${C_CYAN}source ~/.bashrc${C_RESET}"
  printf "\n"
  pln "Atau langsung jalanin:"
  pln "   ${C_CYAN}node $INSTALL_PATH${C_RESET}"
else
  pln "${C_GREEN}✓ Perintah 'xyron' siap dipakai!${C_RESET}"
fi

printf "\n"
pln "${C_BOLD}Cara pakai:${C_RESET}"
pln "  ${C_CYAN}xyron${C_RESET}                     → interactive chat"
pln "  ${C_CYAN}xyron \"tanya apa aja\"${C_RESET}    → langsung tanya"
pln "  ${C_CYAN}xyron -m v2 \"pertanyaan\"${C_RESET}  → pilih model"
pln "  ${C_CYAN}xyron --help${C_RESET}              → bantuan"
printf "\n"
pln "${C_YELLOW}Selamat menggunakan XYRON AI! 🤖${C_RESET}"
printf "\n"
