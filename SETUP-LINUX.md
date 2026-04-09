# Linux 开发环境配置指南

按照依赖关系排序，确保依次安装。

## 依赖关系图

```
┌─────────────────────────────────────────────────────────────────┐
│                        第一阶段：系统基础                          │
│  系统更新 → 系统依赖 → 网络加速配置                               │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│                        第二阶段：核心运行时                        │
│  Rust → Go → Node.js (fnm)                                      │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│                   第二阶段半：拉取 Dotfiles 仓库                   │
│  Git 安装 → 克隆 dotfiles → Stow 部署配置                        │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│                        第三阶段：基础工具                          │
│  Fish + Starship → Git 配置 → 各类 CLI 工具                      │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│                        第四阶段：AI 工具                          │
│  npm → opencode / gemini-cli                                    │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│                        第五阶段：开发工具                          │
│  编辑器 → 文件管理 → 数据库 → 容器                               │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│                        第六阶段：桌面环境 (可选)                    │
│  Wayland → 输入法 → 状态栏                                       │
└─────────────────────────────────────────────────────────────────┘
```

---

## 第一阶段：系统基础

### 1.1 系统更新

```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade -y

# Fedora
sudo dnf update -y

# Arch
sudo pacman -Syu
```

### 1.2 安装系统基础依赖

```bash
# Ubuntu/Debian
sudo apt install -y \
  curl wget git stow fish tmux \
  build-essential cmake pkg-config \
  libssl-dev \
  sqlite3 libsqlite3-dev \
  libayatana-appindicator3-dev \
  libwebkit2gtk-4.1-dev libgtk-3-dev \
  libxkbcommon0 libinput10 libegl1 libglib2.0-0 \
  fuse libfuse2 \
  dbus-x11

# Fedora
sudo dnf install -y \
  curl wget git stow fish tmux \
  gcc gcc-c++ cmake pkgconfig \
  openssl-devel \
  sqlite sqlite-devel \
  gtk3-devel webkit2gtk-4.1-devel \
  libxkbcommon libinput fuse \
  dbus-x11

# Arch
sudo pacman -Syu
sudo pacman -S \
  curl wget git stow fish tmux \
  base-devel cmake pkgconf \
  openssl sqlite \
  gtk3 webkit2gtk \
  libxkbcommon libinput fuse2 dbus
```

### 1.3 网络加速配置 (中国区)

#### 配置 apt 镜像源

```bash
# Ubuntu - 清华镜像
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo bash -c 'cat > /etc/apt/sources.list << "EOF"
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
EOF'

# Fedora - 清华镜像
sudo sed -i 's|mirrorlist=.*|mirrorlist=https://mirrors.tuna.tsinghua.edu.cn/fedora/$releasever/$basearch/os/|g' /etc/dnf/fedora.repo
sudo sed -i 's|metalink=.*|metalink=https://mirrors.tuna.tsinghua.edu.cn/fedora/repo/metalink|g' /etc/dnf/fedora.repo

# Arch - 清华镜像
sudo bash -c 'echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist'

sudo apt update
```

#### 配置代理 (如有)

```bash
# 编辑 ~/.config/fish/config.fish 添加
# set -gx http_proxy "http://127.0.0.1:7897"
# set -gx https_proxy "http://127.0.0.1:7897"
# set -gx all_proxy "socks5://127.0.0.1:7890"
```

#### 配置 Git 镜像

```bash
git config --global url."https://ghproxy.com/".insteadOf https://github.com/
git config --global url."https://hub.gitmirror.com/".insteadOf https://github.com/
```

---

## 第二阶段：核心运行时

### 2.1 安装 Rust (最重要!)

```bash
# 配置 Rust 镜像 (USTC)
export RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
export RUSTUP_UPDATE_ROOT="https://mirrors.ustc.edu.cn/rust-static/rustup"

# 安装 Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 配置 Cargo 镜像
mkdir -p ~/.cargo
cat > ~/.cargo/config.toml << 'EOF'
[http]
proxy = "127.0.0.1:7897"

[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = "ustc"

[source.ustc]
registry = "https://mirrors.ustc.edu.cn/crates.io-index"

[net]
git-fetch-with-cli = true
EOF

# 验证
source ~/.cargo/env
rustc --version
cargo --version
```

### 2.2 安装 Go

```bash
# 下载 Go (清华镜像)
cd /tmp
wget https://mirrors.tuna.tsinghua.edu.cn/golang/go1.21.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz

# 配置环境变量 (添加到 ~/.config/fish/config.fish)
echo 'set -gx PATH /usr/local/go/bin $PATH' >> ~/.config/fish/config.fish
echo 'set -gx GOPATH $HOME/go' >> ~/.config/fish/config.fish
echo 'set -gx GOPROXY "https://goproxy.cn,direct"' >> ~/.config/fish/config.fish

# 验证
go version
```

### 2.3 安装 Node.js (fnm)

```bash
# 先安装 rust (已完成)
# 安装 fnm
curl -fsSL https://fnm.vercel.app/install | bash

# 在 fish 中初始化
fish
fnm install --latest
fnm default lts-latest

# 验证
node --version
npm --version
```

---

## 第二阶段半：拉取 Dotfiles 仓库

在安装完核心运行时后，应该立即拉取 dotfiles 仓库，这样后续的工具配置都可以使用 stow 进行管理。

### 2.4 拉取 Dotfiles 仓库

```bash
# 进入用户目录
cd ~

# 克隆 dotfiles 仓库 (替换为你的仓库地址)
git clone https://github.com/yourusername/dotfiles.git .dotfiles
# 或使用 GitHub CLI
gh repo clone yourusername/dotfiles .dotfiles

# 使用 Stow 部署配置文件
cd .dotfiles

# 部署所有配置
stow fish tmux helix vim starship jj cargo opencode ghostty television niri waybar fcitx5 television

# 或逐个部署
stow fish
stow tmux
stow helix
# ... 其他模块
```

### 2.5 Stow 常用命令

```bash
# 查看哪些包可以部署
stow --dry-run -v *

# 部署指定包
stow fish

# 删除指定包的符号链接
stow -D fish

# 重新部署 (删除后部署)
stow -R fish
```

### 2.6 验证 dotfiles 链接

```bash
# 检查关键配置是否已链接
ls -la ~/.config/fish     # 应该指向 ~/.dotfiles/fish/.config/fish
ls -la ~/.tmux.conf       # 应该指向 ~/.dotfiles/tmux/.tmux.conf
ls -la ~/.config/helix    # 应该指向 ~/.dotfiles/helix/.config/helix
```

---

## 第三阶段：基础工具

> 注意：以下配置已在第二阶段通过 `stow` 部署完成。如果之前没有使用 stow，可手动执行。

### 3.1 Shell 和提示符

```bash
# 配置已在第二阶段通过 stow 部署
# 如果需要手动配置：
# mkdir -p ~/.config/fish
# ln -sf ~/.dotfiles/fish/.config/fish/config.fish ~/.config/fish/config.fish

# 安装 Starship (依赖 Rust)
cargo install starship --locked

# 启动 fish 测试
fish
```

### 3.2 Tmux

```bash
# 配置已在第二阶段通过 stow 部署
# 如果需要手动配置：
# ln -sf ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
```

### 3.3 Git 和版本控制

```bash
# 配置 Git
git config --global user.name "Levy Gu"
git config --global user.email "32436334@qq.com"
git config --global core.editor helix

# 配置 jj (已在第二阶段通过 stow 部署配置文件)
# 如果需要手动配置：
# mkdir -p ~/.config/jj
# ln -sf ~/.dotfiles/jj/.config/jj/config.toml ~/.config/jj/config.toml

# 安装 jj (依赖 Rust)
cargo install jj --locked
```

### 3.4 批量安装 CLI 工具

```bash
# 这些都通过 cargo 安装 (依赖 Rust)
cargo install \
  yazi \
  eza \
  bat \
  navi \
  television \
  lazygit \
  lazydocker \
  fastfetch \
  tldr \
  gum \
  duf \
  bottom \
  --locked

# 系统包管理器工具
sudo apt install -y fzf ripgrep fd-find btop tree

# 创建别名 (添加到 fish config)
# alias ll="eza -l"
# alias lla="eza -la"
# alias lt="eza -T"
# alias yz="yazi"
```

---

## 第四阶段：AI 工具

### 4.1 配置 npm 镜像 (中国区)

```bash
npm config set registry https://registry.npmmirror.com
npm config set disturl https://npmmirror.com/mirrors/node
```

### 4.2 安装 OpenCode

```bash
# 从官网下载 Linux 版本
# https://opencode.com/download

# 或使用 npm 安装 (如果可用)
# npm install -g opencode

# 配置已在第二阶段通过 stow 部署
# 如果需要手动配置：
# mkdir -p ~/.config/opencode
# ln -sf ~/.dotfiles/opencode/.config/opencode/oh-my-openagent.json ~/.config/opencode/oh-my-openagent.json
```

### 4.3 安装 Gemini CLI

```bash
npm install -g @google/gemini-cli
```

### 4.4 安装其他 AI 工具

```bash
# Claude Code (可选)
# npm install -g @anthropic-ai/claude-code
```

---

## 第五阶段：开发工具

### 5.1 编辑器

```bash
# 安装 Helix
sudo apt install helix
ln -sf ~/.dotfiles/helix/.config/helix ~/.config/helix

# 或从源码编译 (需要 Rust)
# cargo install helix --locked

# 安装 Vim
sudo apt install vim
ln -sf ~/.dotfiles/vim/.vimrc ~/.vimrc
```

### 5.2 Python 环境

```bash
# 安装 uv (依赖 Rust)
cargo install uv --locked

# 安装 Python
sudo apt install python3 python3-pip python3-venv

# 配置 uv 镜像
uv config set mirror https://mirrors.ustc.edu.cn/pypi/web/simple
```

### 5.3 数据库工具

```bash
# SQLite (命令行)
sudo apt install sqlite3

# PostgreSQL
sudo apt install postgresql postgresql-contrib

# Redis
sudo apt install redis-server
```

### 5.4 容器工具

```bash
# Docker
sudo apt install docker.io
sudo systemctl start docker
sudo usermod -aG docker $USER

# Docker Compose
sudo apt install docker-compose
```

---

## 第六阶段：桌面环境 (可选)

### 6.1 窗口管理器 (Niri)

```bash
# Niri 需要 Wayland 环境
# 先安装依赖
sudo apt install libinput-bin libegl1 libxkbcommon-x11-0 libpixman-1-0

# 编译安装 (需要 Rust)
cargo install niri --locked

# 配置
mkdir -p ~/.config/niri
ln -sf ~/.dotfiles/niri/.config/niri/config.kdl ~/.config/niri/config.kdl
ln -sf ~/.dotfiles/niri/.config/niri/dms ~/.config/niri/dms
```

### 6.2 输入法 (Fcitx5)

```bash
# 安装 Fcitx5
sudo apt install fcitx5 fcitx5-configtool
sudo apt install fcitx5-frontend-gtk3 fcitx5-frontend-qt5

# 安装 Rime
sudo apt install fcitx5-rime librime

# 安装 rime-ice (需要从源码或 AUR 安装)
# 配置
mkdir -p ~/.config/fcitx5
ln -sf ~/.dotfiles/fcitx5/.config/fcitx5 ~/.config/fcitx5
ln -sf ~/.dotfiles/fcitx5/.local ~/.local
```

### 6.3 状态栏 (Waybar)

```bash
# 安装 waybar
sudo apt install waybar
# 或从源码编译
cargo install waybar --locked

# 配置
ln -sf ~/.dotfiles/waybar/.config/waybar ~/.config/waybar
```

### 6.4 终端 (Ghostty)

```bash
# 从 https://ghostty.org/download 下载
# 或从源码编译 (需要 Zig)
```

---

## 快速部署脚本

```bash
#!/bin/bash
# setup-linux-ordered.sh
# 按依赖关系顺序执行

set -e

echo "=========================================="
echo "第一阶段：系统基础"
echo "=========================================="

# 系统更新
sudo apt update && sudo apt upgrade -y

# 系统依赖
sudo apt install -y \
  curl wget git stow fish tmux \
  build-essential cmake pkg-config \
  libssl-dev sqlite3 libsqlite3-dev \
  libwebkit2gtk-4.1-dev libgtk-3-dev \
  libxkbcommon0 libinput10 libegl1 \
  fuse libfuse2 dbus-x11

# 配置 apt 镜像
echo "配置 apt 镜像..."
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo bash -c 'cat > /etc/apt/sources.list << "EOF"
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
EOF'
sudo apt update

echo "=========================================="
echo "第二阶段：核心运行时"
echo "=========================================="

# Rust
echo "安装 Rust..."
export RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
export RUSTUP_UPDATE_ROOT="https://mirrors.ustc.edu.cn/rust-static/rustup"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# 配置 Cargo
mkdir -p ~/.cargo
cat > ~/.cargo/config.toml << 'EOF'
[http]
proxy = "127.0.0.1:7897"

[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = "ustc"

[source.ustc]
registry = "https://mirrors.ustc.edu.cn/crates.io-index"

[net]
git-fetch-with-cli = true
EOF

source ~/.cargo/env

# Go
echo "安装 Go..."
cd /tmp
wget -q https://mirrors.tuna.tsinghua.edu.cn/golang/go1.21.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz

# Node.js (fnm)
echo "安装 fnm..."
curl -fsSL https://fnm.vercel.app/install | bash

echo "=========================================="
echo "第三阶段：基础工具"
echo "=========================================="

# Fish + Starship
mkdir -p ~/.config/fish
ln -sf ~/.dotfiles/fish/.config/fish/config.fish ~/.config/fish/config.fish
cargo install starship --locked
ln -sf ~/.dotfiles/starship/.config/starship.toml ~/.config/starship.toml

# Tmux
ln -sf ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf

# Git + jj
cargo install jj --locked
ln -sf ~/.dotfiles/jj/.config/jj ~/.config/jj

# CLI 工具
echo "安装 CLI 工具..."
cargo install yazi eza bat navi television lazygit lazydocker fastfetch tldr gum --locked
sudo apt install -y fzf ripgrep fd-find btop tree

echo "=========================================="
echo "第四阶段：AI 工具"
echo "=========================================="

# npm 配置
npm config set registry https://registry.npmmirror.com

# opencode - 从官网下载后放到 PATH 中

echo "=========================================="
echo "第五阶段：开发工具"
echo "=========================================="

# 编辑器
sudo apt install helix
ln -sf ~/.dotfiles/helix/.config/helix ~/.config/helix

# Python uv
cargo install uv --locked

echo "=========================================="
echo "完成！"
echo "=========================================="
echo "请运行: fish"
echo "验证: rustc --version && node --version && cargo --version"
```

---

## 安装顺序检查清单

| 顺序 | 阶段 | 工具 | 验证命令 |
|------|------|------|----------|
| 1 | 系统基础 | git, curl, wget, stow | `git --version` |
| 2 | 核心运行时 | Rust | `rustc --version` |
| 3 | 核心运行时 | Go | `go version` |
| 4 | 核心运行时 | fnm + Node.js | `node --version` |
| 5 | **Dotfiles** | 克隆仓库 + Stow 部署 | `ls -la ~/.config/fish` |
| 6 | 基础工具 | Fish + Starship | `starship --version` |
| 7 | 基础工具 | Tmux | `tmux -V` |
| 8 | 基础工具 | jj | `jj version` |
| 9 | 基础工具 | CLI 工具 | `yazi --version` |
| 10 | AI 工具 | opencode | `opencode --version` |
| 11 | 开发工具 | Helix, Python | `helix --version` |

---

## 常见问题

1. **Cargo 编译失败**: 确保代理已启动，或检查 USTC 镜像是否正常
2. **npm 安装慢**: 确保使用 npmmirror 镜像
3. **Go 模块下载慢**: 确保 GOPROXY 设置正确
4. **Niri 无法启动**: 确保在 Wayland 会话中运行