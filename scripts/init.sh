#!/usr/bin/env bash
# dotfiles セットアップスクリプト
# 冪等性あり: 何度実行しても安全

set -euo pipefail

# --- ヘルパー関数 ---

log()  { echo "  $*"; }
info() { echo; echo "=== $* ==="; }
ok()   { echo "  [スキップ] $* は導入済みです"; }

# シンボリックリンクを安全に作成（既存ファイルを上書き）
symlink() {
  local src="$1" dst="$2"
  ln -fs "$src" "$dst"
  log "リンク: $dst -> $src"
}

# brew パッケージをインストール（インストール済みはスキップ）
brew_install() {
  local pkg="$1"
  if brew list --formula "$pkg" &>/dev/null 2>&1; then
    ok "brew: $pkg"
  else
    log "brew install $pkg ..."
    brew install "$pkg"
  fi
}

# --- 引数チェック ---
if [ $# -ne 1 ]; then
  echo "使い方: $0 <os>" >&2
  echo "例:     $0 mac" >&2
  exit 1
fi

OS=$(echo "$1" | tr '[:upper:]' '[:lower:]')
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "dotfiles セットアップ開始"
echo "  OS      : $OS"
echo "  リポジトリ: $ROOT_DIR"

# ============================================================
# OS 別パッケージインストール
# ============================================================

if [ "mac" = "$OS" ]; then

  info "Homebrew"
  if ! command -v brew &>/dev/null; then
    log "Homebrew をインストール中..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    ok "Homebrew"
  fi
  # Apple Silicon / Intel 両対応
  eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null \
    || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null \
    || true

  info "基本ツール (Homebrew)"
  brew_install wget
  brew_install coreutils
  brew_install go
  brew_install peco
  brew_install colordiff

  info "AI開発環境ツール (Homebrew)"
  brew_install tmux
  brew_install lazygit
  brew_install fzf
  brew_install bat

  info "開発言語ツール (Homebrew)"
  brew_install direnv
  brew_install uv

  info "pyenv"
  if command -v pyenv &>/dev/null; then
    ok "pyenv"
  elif [ -d "$HOME/.pyenv" ]; then
    ok "pyenv (~/.pyenv)"
  else
    log "pyenv をインストール中..."
    git clone https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
  fi

elif [ "centos" = "$OS" ]; then

  info "CentOS パッケージインストール"
  sudo yum -y groupinstall "Development Tools"
  sudo yum -y install readline-devel zlib-devel bzip2-devel sqlite-devel openssl-devel
  sudo yum -y install tmux zsh tig emacs
  sudo usermod -s /bin/zsh "$(whoami)"

elif [ "ubuntu" = "$OS" ]; then

  info "Ubuntu パッケージインストール"
  sudo apt-get -y install tmux zsh tig emacs
  sudo usermod -s /bin/zsh "$(whoami)"

else
  echo "不明な OS: $OS" >&2
  echo "対応OS: mac / centos / ubuntu" >&2
  exit 1
fi

# ============================================================
# 共通セットアップ（全 OS）
# ============================================================

info "Git 設定"
git config --global user.name  "tstomoki"
git config --global user.email "tstomoki4@gmail.com"
git config --global core.editor "vim"
git config --global color.ui true
git config --global core.quotepath false
log "完了"

info "Git サブモジュール"
git -C "$ROOT_DIR" submodule update --init --recursive
log "完了"

info "dotfiles を ~/.dotfiles に同期"
mkdir -p "$HOME/.dotfiles"
# --delete は使わず追記方向で同期（既存の手動設定を消さない）
rsync -a --exclude='.git' "$ROOT_DIR/" "$HOME/.dotfiles/"
log "完了"

info "シンボリックリンク作成"
symlink "$HOME/.dotfiles/zsh/zshrc_mac"                       "$HOME/.zshrc"
symlink "$HOME/.dotfiles/tmux/.tmux.conf"                     "$HOME/.tmux.conf"
symlink "$HOME/.dotfiles/tig/tigrc"                           "$HOME/.tigrc"

info "スクリプトへの実行権限付与"
chmod +x "$HOME/.dotfiles/tmux/scripts/tmux-file-picker.sh"
log "完了"

# ============================================================
# 完了メッセージ
# ============================================================
echo
echo "=============================="
echo "  セットアップ完了！"
echo "=============================="
echo
echo "次のコマンドで設定を反映してください:"
echo
echo "  source ~/.zshrc"
echo
echo "tmux セッションが起動中の場合は追加で:"
echo
echo "  tmux source-file ~/.tmux.conf"
echo
echo "使い方:"
echo "  ai_dev        : 3ペインレイアウト起動（左: claude / 右上,右下: 空）"
echo "  Ctrl+g        : lazygit ポップアップ"
echo "  Ctrl+f        : ファイルピッカー（選択で @パス をプロンプトに挿入）"
