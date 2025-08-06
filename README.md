
# 🛠️ Shell Setup Bootstrap
_A one-shot installer for zsh, oh my zsh, nerd fonts, oh my zsh plugins + Terminator workstation on any Debian / Ubuntu–based distro._

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](#license)

---

## ✨ Features

* Installs **Zsh** & sets it as your login shell  
* Installs **Oh My Zsh**, **Powerlevel10k**, Meslo Nerd Fonts  
* Pulls plugins: autosuggestions, completions, history-substring-search, fast-syntax-highlighting, fzf-tab, zsh-autocomplete, you-should-use, git-open  
* Generates a fully-loaded **`.zshrc`** (Solarized palette, > 50 aliases, emoji cheatsheet)  
* Installs **Terminator**, registers it as the default `x-terminal-emulator`, pre-loads a transparent Solarized-Dark profile  
* Idempotent – re-running just prints ✅ and exits

---

## 🚀 Quick install

 * Copy the code below into your console and watch the magic happen!
 
 ---

```bash
sudo apt update && sudo apt install -y curl
bash <(curl -fsSL https://raw.githubusercontent.com/myceliam/ShellScripts/main/shellsetup.sh)
```

---

## Contributions

* Any contributions or suggestions are welcome.

---