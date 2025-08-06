
# 🛠️ Shell Setup Bootstrap
_A one-shot installer for an opinionated Z-shell + Terminator workstation on any Debian / Ubuntu–based distro._

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](#license)

---

## ✨ What it does

* Installs **Zsh** and makes it your login shell  
* Installs **Oh-My-Zsh**, **Powerlevel10k** and Meslo Nerd Fonts  
* Pulls a curated plugin set: autosuggestions, completions, history-search, fzf-tab, fast-syntax-highlighting, etc.  
* Drops a fully-commented **`.zshrc`** with  
  * Solarized colour palette  
  * >50 handy aliases  
  * interactive emoji **cheatsheet**  
* Installs **Terminator**, sets it as the default `x-terminal-emulator`, and pre-loads a transparent Solarized-Dark profile  
* All idempotent — run it again, it just prints ✅ and exits.

---

## 🚀 Quick install (1-liner)

> _Requires `curl` and sudo rights._

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/myceliam/ShellScripts/main/shellsetup.sh)
