#!/usr/bin/env bash
set -euo pipefail
#####################################################################
#  Liam’s Zsh + Terminator Bootstrap (2025-08-06 – full version)
#####################################################################

STEP(){ printf "\n\033[1;34m==> %s\033[0m\n" "$*"; }
INFO(){ printf "   \033[0;32m✔ %s\033[0m\n" "$*"; }

ZSH_CUSTOM=${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}
FONT_DIR="$HOME/.local/share/fonts"
TERMINATOR_CFG="$HOME/.config/terminator/config"

### Abort if run as root (avoids writing to /root) ---------------------------
if [[ $(id -u) -eq 0 ]]; then
  echo "❌  Run this script as your normal user, NOT with sudo."
  exit 1
fi

#####################################################################
# 1. Packages: Zsh + Terminator + essentials
#####################################################################
STEP "Installing Zsh, Terminator & basic build tools ..."
sudo apt update -qq
sudo apt install -y zsh terminator git curl build-essential

#####################################################################
# 2. Oh-My-Zsh
#####################################################################
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  STEP "Installing Oh My Zsh ..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  INFO "Oh My Zsh already present"
fi

#####################################################################
# 3. Powerlevel10k
#####################################################################
if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
  STEP "Cloning Powerlevel10k ..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"
else
  INFO "Powerlevel10k already cloned"
fi

#####################################################################
# 4. Meslo Nerd Fonts (required by P10k)
#####################################################################
STEP "Installing Meslo Nerd Fonts ..."
mkdir -p "$FONT_DIR"
MESLO_BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"
for style in "Regular" "Bold" "Italic" "Bold Italic"; do
  file="MesloLGS NF ${style}.ttf"
  url="$MESLO_BASE/${file// /%20}"
  if [[ ! -f "$FONT_DIR/$file" ]]; then
    curl -fsSL -o "$FONT_DIR/$file" "$url"
    INFO "Installed $file"
  else
    INFO "$file already present"
  fi
done
fc-cache -f >/dev/null || true

#####################################################################
# 5. Z-sh Plugins (alias-finder intentionally omitted)
#####################################################################
STEP "Cloning plugins ..."
declare -A PLUGS=(
  [zsh-autosuggestions]=https://github.com/zsh-users/zsh-autosuggestions
  [zsh-completions]=https://github.com/zsh-users/zsh-completions
  [zsh-history-substring-search]=https://github.com/zsh-users/zsh-history-substring-search
  [you-should-use]=https://github.com/MichaelAquilina/zsh-you-should-use
  [git-open]=https://github.com/paulirish/git-open
  [fast-syntax-highlighting]=https://github.com/zdharma-continuum/fast-syntax-highlighting
  [fzf-tab]=https://github.com/Aloxaf/fzf-tab
  [zsh-autocomplete]=https://github.com/marlonrichert/zsh-autocomplete
)
for name in "${!PLUGS[@]}"; do
  dest="$ZSH_CUSTOM/plugins/$name"
  if [[ ! -d "$dest" ]]; then
    git clone --depth=1 "${PLUGS[$name]}" "$dest" &>/dev/null
    INFO "Cloned $name"
  else
    INFO "$name already present"
  fi
done

#####################################################################
# 6. Full .zshrc (aliases + cheatsheet intact)
#####################################################################
STEP "Writing full ~/.zshrc ..."
cat > "$HOME/.zshrc" <<"EOF"
##############################################################################
#  Liam’s Optimised .zshrc  – 2025-08-06 (complete)
##############################################################################
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-completions
  zsh-history-substring-search
  you-should-use
  git-open
  fast-syntax-highlighting
  fzf-tab
  zsh-autocomplete
)
source "$ZSH/oh-my-zsh.sh"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh   # Powerlevel10k settings

# ── Fast-syntax-highlighting requires muted widgets ───────────────
zle -A history-incremental-search-backward menu-search
zle -A history-incremental-search-forward  recent-paths

# Extra completions path
fpath+=(${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions/src)

# Manual plugin load order
[[ -f ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]] && \
  source ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
[[ -f ${ZSH_CUSTOM}/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]] && \
  source ${ZSH_CUSTOM}/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
export ZSH_AUTOCOMPLETE_USE_WIDGETS=true
export skip_global_compinit=1

# ── History ───────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS
setopt HIST_FIND_NO_DUPS HIST_IGNORE_SPACE EXTENDED_HISTORY

# ── Aliases ───────────────────────────────────────────────────────
alias sau='sudo apt update'
alias sai='sudo apt install'
alias s='sudo'

alias zshcfg='micro ~/.zshrc'
alias reloadzsh='source ~/.zshrc'

alias update-all='sudo apt update && sudo apt upgrade -y && flatpak update -y && sudo snap refresh'

alias meminfo='free -h'
alias usage='df -h'
alias ports='ss -tulwn'

alias gs='git status'; alias ga='git add'; alias gc='git commit'
alias gp='git push';  alias gl='git pull'

alias msf='msfconsole'
alias flipper='cd ~/FlipperZero'
alias piholelog='less +F /var/log/pihole.log'
alias restartdns='sudo systemctl restart pihole-FTL'
alias ssh-pi='ssh pi@pihole.local'
alias flipper-put='cp *.sub ~/FlipperZero/subghz/'

alias runpy='python3 main.py'
alias vs='code .'

# ── Interactive Emoji Cheatsheet ──────────────────────────────────
cheatsheet() {
  while true; do
    echo
    echo "🌟  CHEATSHEET  🌟"
    echo "  1️⃣  Aliases"
    echo "  2️⃣  Commands"
    echo "  ❌  q  Quit"
    read "choice?Select (1 / 2 / q): "
    echo
    case $choice in
      1)
        cat <<'ALIAS'
🗂️  ALIASES
  sau / sai / s     – apt helper & sudo shortcut
  zshcfg / reloadzsh – edit & reload .zshrc
  update-all        – apt + flatpak + snap upgrade
  meminfo / usage   – RAM & disk
  ports             – open sockets
  gs/ga/gc/gp/gl    – git workflow
  msf               – Metasploit console
ALIAS
        ;;
      2)
        cat <<'CMDS'
🖥️  SYSTEM   : btop, bottom, duf
🌐  NETWORK  : bandwhich, iperf3, ncat
🔍  SEARCH   : rg, fd, fzf
📁  FILES    : nnn, bat, eza
🐳  CONTAINERS: podman, lazydocker
🛰️  TROUBLE  : dog, gping
🔐  RECON    : naabu, httpx
CMDS
        ;;
      q|Q) break ;;
      *)   echo "Choose 1, 2, or q." ;;
    esac
  done
}

# ── Environment ───────────────────────────────────────────────────
export EDITOR='micro'
export LANG='en_GB.UTF-8'
export LC_ALL='en_GB.UTF-8'
export COMPLETION_WAITING_DOTS=true
export PATH="$HOME/.cargo/bin:$HOME/go/bin:$HOME/bin:/usr/local/bin:$PATH"

# ── Misc zsh options ──────────────────────────────────────────────
setopt NO_BEEP AUTO_CD MULTIOS
##############################################################################
# End of .zshrc
##############################################################################
EOF
INFO ".zshrc created / updated"

#####################################################################
# 7. Terminator config
#####################################################################
STEP "Writing Terminator profile ..."
mkdir -p "$(dirname "$TERMINATOR_CFG")"
cat > "$TERMINATOR_CFG" <<"TERMCFG"
[global_config]
[keybindings]
[profiles]
  [[default]]
    background_color = "#002b36"
    background_darkness = 0.94
    background_type = transparent
    font = MesloLGS NF 10
    foreground_color = "#839496"
    palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#002b36:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3"
    use_system_font = False
    bold_is_bright = True
  [[default 2]]
    background_color = "#002b36"
    background_darkness = 0.94
    background_type = transparent
    font = MesloLGS NF 10
    foreground_color = "#839496"
    palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#002b36:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3"
    use_system_font = False
    bold_is_bright = True
[layouts]
  [[default]]
    [[[window0]]]
      type = Window
      parent = ""
    [[[child1]]]
      type = Terminal
      parent = window0
      profile = default
[plugins]
TERMCFG
INFO "Terminator config written"

#####################################################################
# 8. Make Terminator default x-terminal-emulator
#####################################################################
STEP "Setting Terminator as default terminal ..."
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/terminator 60
sudo update-alternatives --set      /usr/bin/x-terminal-emulator /usr/bin/terminator
INFO "Default terminal set"

#####################################################################
# 9. Switch login shell → zsh
#####################################################################
if [[ "$SHELL" != "$(command -v zsh)" ]]; then
  STEP "Changing default login shell to zsh ..."
  chsh -s "$(command -v zsh)"
  INFO "Shell changed (log out/in to take effect)"
fi

STEP "Bootstrap complete!  Open Terminator or run: exec zsh"
