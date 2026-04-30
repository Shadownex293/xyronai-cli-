#!/usr/bin/env node
// XYRON AI CLI — by ShadowNex
// github.com/ShadowNex/xyronai

import { createInterface } from 'readline';

// ── Config — GANTI ini setelah deploy ke Vercel ──────────────
const SERVER_URL  = 'https://xyronai.vercel.app/api/chat'; // ganti domain lo
const CLI_TOKEN   = 'GANTI_DENGAN_CLI_SECRET_TOKEN_LO';    // sama dengan di env Vercel

// ── ANSI Colors ──────────────────────────────────────────────
const t = process.stdout.isTTY;
const c = {
  reset:   t?'\x1b[0m':'',   bold:    t?'\x1b[1m':'',
  dim:     t?'\x1b[2m':'',   cyan:    t?'\x1b[36m':'',
  green:   t?'\x1b[32m':'',  yellow:  t?'\x1b[33m':'',
  magenta: t?'\x1b[35m':'',  red:     t?'\x1b[31m':'',
  gray:    t?'\x1b[90m':'',
};

const MODELS = {
  v1: 'XYRON V1', v2: 'XYRON V2',
  v3: 'XYRON V3', v4: 'XYRON V4',
};

// ── Request ke server Vercel lo ──────────────────────────────
async function sendChat(message, model, history) {
  const res = await fetch(SERVER_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-cli-token': CLI_TOKEN,
    },
    body: JSON.stringify({
      message,
      model: `xyron-${model}`,
      history,
    }),
  });

  if (res.status === 401) throw new Error('Token CLI tidak valid. Hubungi admin.');
  if (res.status === 503) throw new Error('CLI belum diaktifkan di server.');
  if (!res.ok) throw new Error(`Server error: ${res.status}`);

  const data = await res.json();
  if (data.error) throw new Error(data.error);
  return data.result;
}

// ── UI Helpers ───────────────────────────────────────────────
function printBanner() {
  console.log(`
${c.cyan}${c.bold}__  ____   ______   ___  _   _    _    ___       ____ _     ___
\ \/ /\ \ / /  _ \ / _ \| \ | |  / \  |_ _|     / ___| |   |_ _|
 \  /  \ V /| |_) | | | |  \| | / _ \  | |_____| |   | |    | |
 /  \   | | |  _ <| |_| | |\  |/ ___ \ | |_____| |___| |___ | |
/_/\_\  |_| |_| \_\___/|_| \_/_/   \_\___|     \____|_____|___|

              CLI Tool  — by ShadowNex${c.reset}
${c.gray}Ketik ${c.yellow}/help${c.gray} untuk bantuan | ${c.yellow}/exit${c.gray} untuk keluar${c.reset}
`);
}

function printHelp() {
  console.log(`
${c.bold}Perintah:${c.reset}
  ${c.yellow}/model${c.reset}       → lihat model aktif
  ${c.yellow}/model v1${c.reset}    → ganti ke XYRON V1 (default)
  ${c.yellow}/model v2${c.reset}    → ganti ke XYRON V2
  ${c.yellow}/model v3${c.reset}    → ganti ke XYRON V3
  ${c.yellow}/model v4${c.reset}    → ganti ke XYRON V4
  ${c.yellow}/clear${c.reset}       → hapus riwayat chat
  ${c.yellow}/history${c.reset}     → lihat riwayat
  ${c.yellow}/exit${c.reset}        → keluar

${c.bold}Non-interactive:${c.reset}
  ${c.green}xyron "pertanyaan"${c.reset}
  ${c.green}xyron -m v2 "pertanyaan"${c.reset}
`);
}

function printModels(cur) {
  console.log(`\n${c.bold}Model tersedia:${c.reset}`);
  for (const [k, label] of Object.entries(MODELS)) {
    const active = k === cur ? ` ${c.green}← aktif${c.reset}` : '';
    console.log(`  ${c.yellow}${k}${c.reset}  ${c.bold}${label}${c.reset}${active}`);
  }
  console.log();
}

function spinner(msg) {
  if (!process.stdout.isTTY) { process.stdout.write(msg + '...\n'); return () => {}; }
  const f = ['⠋','⠙','⠹','⠸','⠼','⠴','⠦','⠧','⠇','⠏'];
  let i = 0;
  const id = setInterval(() => {
    process.stdout.write(`\r${c.cyan}${f[i++%f.length]}${c.reset} ${c.dim}${msg}${c.reset}`);
  }, 80);
  return () => { clearInterval(id); process.stdout.write('\r\x1b[K'); };
}

// ── Parse args ───────────────────────────────────────────────
function parseArgs() {
  const args = process.argv.slice(2);
  let model = 'v1', query = null;
  for (let i = 0; i < args.length; i++) {
    if ((args[i] === '-m' || args[i] === '--model') && MODELS[args[i+1]]) {
      model = args[++i];
    } else if (args[i] === '--help' || args[i] === '-h') {
      printHelp(); process.exit(0);
    } else if (!args[i].startsWith('-')) {
      query = args[i];
    }
  }
  return { model, query };
}

// ── Single query mode ────────────────────────────────────────
async function runSingle(model, query) {
  const stop = spinner(`${MODELS[model]} sedang berpikir`);
  try {
    const result = await sendChat(query, model, []);
    stop();
    console.log(`\n${c.cyan}${c.bold}XYRON${c.reset} ${c.gray}[${MODELS[model]}]${c.reset}\n`);
    console.log(result);
    console.log();
  } catch (err) {
    stop();
    console.error(`${c.red}✗ ${err.message}${c.reset}`);
    process.exit(1);
  }
}

// ── Interactive mode ─────────────────────────────────────────
async function runInteractive(initModel) {
  printBanner();
  let model = initModel, history = [];

  const rl = createInterface({ input: process.stdin, output: process.stdout, terminal: t });
  rl.on('close', () => { console.log(`\n${c.gray}Sampai jumpa! 👋${c.reset}\n`); process.exit(0); });

  const prompt = () => process.stdout.write(
    `${c.magenta}${c.bold}You${c.reset} ${c.gray}[${MODELS[model]}]${c.reset} › `
  );

  prompt();
  rl.on('line', async (line) => {
    const input = line.trim();
    if (!input) { prompt(); return; }

    if (input === '/exit' || input === '/quit') { rl.close(); return; }
    if (input === '/help') { printHelp(); prompt(); return; }
    if (input === '/model') { printModels(model); prompt(); return; }
    if (input === '/clear') {
      history = [];
      console.log(`${c.green}✓ Riwayat dihapus${c.reset}\n`);
      prompt(); return;
    }
    if (input === '/history') {
      if (!history.length) { console.log(`${c.gray}Belum ada riwayat.${c.reset}\n`); }
      else history.forEach((m, i) => {
        const who = m.role === 'user' ? `${c.magenta}You${c.reset}` : `${c.cyan}XYRON${c.reset}`;
        console.log(`  ${c.gray}${i+1}.${c.reset} ${who}: ${m.content.slice(0,80)}${m.content.length>80?'…':''}`);
      });
      console.log(); prompt(); return;
    }
    if (input.startsWith('/model ')) {
      const k = input.slice(7).trim();
      if (MODELS[k]) { model = k; console.log(`${c.green}✓ Ganti ke ${MODELS[k]}${c.reset}\n`); }
      else console.log(`${c.red}Model '${k}' tidak ada. Pilihan: ${Object.keys(MODELS).join(', ')}${c.reset}\n`);
      prompt(); return;
    }
    if (input.startsWith('/')) {
      console.log(`${c.red}Perintah tidak dikenal. Ketik /help${c.reset}\n`);
      prompt(); return;
    }

    rl.pause();
    const stop = spinner(`${MODELS[model]} sedang berpikir`);
    try {
      const result = await sendChat(input, model, history);
      stop();
      history.push({ role: 'user', content: input });
      history.push({ role: 'assistant', content: result });
      if (history.length > 20) history = history.slice(-20);
      console.log(`\n${c.cyan}${c.bold}XYRON${c.reset} ${c.gray}[${MODELS[model]}]${c.reset}\n`);
      console.log(result);
      console.log();
    } catch (err) {
      stop();
      console.error(`${c.red}✗ ${err.message}${c.reset}\n`);
    }
    rl.resume();
    prompt();
  });
}

// ── Main ─────────────────────────────────────────────────────
const { model, query } = parseArgs();
if (query) runSingle(model, query);
else runInteractive(model);
