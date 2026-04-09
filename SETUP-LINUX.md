# Linux 开发环境配置指南

按照依赖关系排序，确保依次安装。

## 安装顺序概览

```
┌─────────────────────────────────────────────────────────────────┐
│  第一阶段：系统基础                                               │
│  系统更新 → 安装 stow → 网络加速配置                              │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第二阶段：核心运行时                                              │
│  Rust → Node.js (fnm)                                            │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第三阶段：基础工具 (部分)                                         │
│  jj 安装 → jj git clone --colocate dotfiles                     │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第四阶段：基础工具安装 + 配置部署                                  │
│  Fish 安装 → stow 部署 fish → Starship 安装 → stow 部署 → ...     │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第五阶段：AI 工具安装 + 配置部署                                  │
│  npm 配置 → 安装 opencode → stow 部署 opencode                    │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第六阶段：开发工具安装 + 配置部署                                  │
│  Helix 安装 → stow 部署 → pnpm → stow 部署 → ...                 │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第七阶段：桌面环境 (可选)                                         │
│  Niri/Waybar/Fcitx5 安装 → stow 部署                             │
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
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
EOF'

# Fedora - 清华镜像
sudo sed -i 's|mirrorlist=.*|mirrorlist=https://mirrors.tuna.tsinghua.edu.cn/fedora/$releasever/$basearch/os/|g' /etc/dnf/fedora.repo
sudo sed -i 's|metalink=.*|metalink=https://mirrors.tuna.tsinghua.edu.cn/fedora/repo/metalink|g' /etc/dnf/fedora.repo

# Arch - 清华镜像
sudo bash -c 'echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist'

sudo apt update
```

#### 配置 Git 镜像

```bash
git config --global url."https://ghproxy.com/".insteadOf https://github.com/
git config --global url."https://hub.gitmirror.com/".insteadOf https://github.com/
```

---

## 第二阶段：核心运行时

### 2.1 安装 Rust

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

### 2.2 安装 fnm + Node.js

```bash
# fnm 依赖 Rust (已完成)
curl -fsSL https://fnm.vercel.app/install | bash

# 配置 fish 环境
fish
fnm install --latest
fnm default lts-latest

# 验证
node --version
npm --version
```

---

## 第三阶段：SSH 配置 + jj + Dotfiles

### 3.1 配置 SSH Key (用于 GitHub)

```bash
# 生成 SSH key (如果还没有)
ssh-keygen -t ed25519 -C "32436334@qq.com"

# 查看公钥
cat ~/.ssh/id_ed25519.pub
```

### 3.2 添加 SSH Key 到 GitHub

```bash
# 复制公钥到剪贴板
cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard

# 然后在 GitHub 网站添加：
# https://github.com/settings/keys
# New SSH Key → 粘贴公钥
```

### 3.3 测试 SSH 连接

```bash
ssh -T git@github.com
# 应该看到 "Hi username! You've successfully authenticated..."
```

### 3.4 安装 jj (依赖 Rust)

```bash
# jj 依赖 Rust，此时 Rust 已安装
cargo install jj --locked

# 配置 jj 用户信息
jj config set --user.name "Levy Gu"
jj config set --user.email "32436334@qq.com"
```

### 3.5 使用 jj git clone --colocate 克隆仓库

```bash
# 使用 jj 的 colocate 模式克隆 (通过 SSH)
jj git clone --colocate git@github.com:yourusername/dotfiles.git .dotfiles

# 进入目录
cd .dotfiles

# 验证
stow --version
jj log --limit 1
```

> **注意**: 此时不要运行 `stow` 部署任何配置

---

## 第四阶段：基础工具安装 + 配置部署

### 4.1 Fish Shell

```bash
# 已在第一阶段安装 fish
# 部署配置
cd ~/.dotfiles && stow fish

# 启动 fish
fish
```

### 4.2 Starship 提示符

```bash
# 安装 Starship (依赖 Rust)
cargo install starship --locked

# 部署配置
cd ~/.dotfiles && stow starship

# 验证
starship --version
```

### 4.3 Tmux

```bash
# 已在第一阶段安装 tmux
# 部署配置
cd ~/.dotfiles && stow tmux

# 验证
tmux -V
```

### 4.4 Git 配置

```bash
# Git 已在第一阶段安装，配置用户信息
git config --global user.name "Levy Gu"
git config --global user.email "32436334@qq.com"
git config --global core.editor helix
```

### 4.5 jj 版本控制

```bash
# jj 已在第三阶段安装
# 部署配置
cd ~/.dotfiles && stow jj

# 验证
jj version
```

### 4.6 CLI 工具批量安装

```bash
# 通过 cargo 安装 (依赖 Rust)
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

# 通过 apt 安装
sudo apt install -y fzf ripgrep fd-find btop tree

# 验证
yazi --version
eza --version
```

---

## 第五阶段：AI 工具安装 + 配置部署

### 5.1 配置 npm 镜像 (中国区)

```bash
npm config set registry https://registry.npmmirror.com
npm config set disturl https://npmmirror.com/mirrors/node
```

### 5.2 安装 OpenCode

```bash
# 从官网下载 Linux 版本
# https://opencode.com/download
# 将可执行文件放到 PATH 中

# 部署配置
cd ~/.dotfiles && stow opencode

# 验证
opencode --version
```

### 5.3 安装 Gemini CLI

```bash
npm install -g @google/gemini-cli
```

---

## 第六阶段：开发工具安装 + 配置部署

### 6.1 pnpm

```bash
npm install -g pnpm
pnpm --version
```

### 6.2 Helix 编辑器

```bash
# 安装 Helix
sudo apt install helix

# 部署配置
cd ~/.dotfiles && stow helix

# 验证
helix --version
```

### 6.3 Vim

```bash
sudo apt install vim
cd ~/.dotfiles && stow vim
```

### 6.4 Python 环境

```bash
# 安装 uv (依赖 Rust)
cargo install uv --locked

# 安装 Python
sudo apt install python3 python3-pip python3-venv

# 配置 uv 镜像
uv config set mirror https://mirrors.ustc.edu.cn/pypi/web/simple
```

### 6.5 数据库

```bash
# SQLite
sudo apt install sqlite3

# PostgreSQL
sudo apt install postgresql postgresql-contrib

# Redis
sudo apt install redis-server
```

### 6.6 Docker

```bash
sudo apt install docker.io
sudo systemctl start docker
sudo usermod -aG docker $USER
```

---

## 第七阶段：桌面环境 (可选)

### 7.1 Niri 窗口管理器

```bash
# 安装依赖
sudo apt install libinput-bin libegl1 libxkbcommon-x11-0 libpixman-1-0

# 编译安装 (依赖 Rust)
cargo install niri --locked

# 部署配置
cd ~/.dotfiles && stow niri
```

### 7.2 Fcitx5 输入法

```bash
# 安装 Fcitx5
sudo apt install fcitx5 fcitx5-configtool
sudo apt install fcitx5-frontend-gtk3 fcitx5-frontend-qt5
sudo apt install fcitx5-rime librime

# 部署配置
cd ~/.dotfiles && stow fcitx5
```

### 7.3 Waybar 状态栏

```bash
# 安装 waybar
sudo apt install waybar

# 部署配置
cd ~/.dotfiles && stow waybar
```

### 7.4 Ghostty 终端

```bash
# 从 https://ghostty.org/download 下载

# 部署配置
cd ~/.dotfiles && stow ghostty
```

---

## 快速部署脚本

```bash
#!/bin/bash
# setup-linux-ordered.sh

set -e

echo "=== 第一阶段：系统基础 ==="
sudo apt update
sudo apt install -y curl wget git stow fish tmux build-essential cmake pkg-config libssl-dev sqlite3

echo "=== 第二阶段：核心运行时 ==="
# Rust
export RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
export RUSTUP_UPDATE_ROOT="https://mirrors.ustc.edu.cn/rust-static/rustup"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env

# fnm
curl -fsSL https://fnm.vercel.app/install | bash

echo "=== 第三阶段：SSH + jj + Dotfiles ==="
# SSH key
ssh-keygen -t ed25519 -C "32436334@qq.com" -f ~/.ssh/id_ed25519 -N ""

# 添加 SSH key 到 GitHub (手动操作)
echo "请手动添加 SSH key 到 GitHub:"
cat ~/.ssh/id_ed25519.pub

# 安装 jj
cargo install jj --locked
jj config set --user.name "Levy Gu"
jj config set --user.email "32436334@qq.com"

# 使用 jj clone (SSH)
jj git clone --colocate git@github.com:yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

echo "=== 第四阶段：基础工具 ==="
stow fish
cargo install starship --locked
stow starship
stow tmux
stow jj
cargo install yazi eza bat navi television lazygit lazydocker fastfetch tldr gum --locked

echo "=== 第五阶段：AI 工具 ==="
npm config set registry https://registry.npmmirror.com
# opencode 从官网下载后放到 PATH 中
stow opencode

echo "=== 第六阶段：开发工具 ==="
sudo apt install helix
stow helix
cargo install uv --locked

echo "=== 完成 ==="
echo "运行 fish 进入 shell"
```

---

## 安装顺序检查清单

| 顺序 | 阶段 | 工具 | 部署时机 | 验证命令 |
|------|------|------|----------|----------|
| 1 | 系统基础 | git, curl, wget, stow | 系统安装时 | `stow --version` |
| 2 | 核心运行时 | Rust | 第二阶段 | `rustc --version` |
| 3 | 核心运行时 | fnm + Node.js | 第二阶段 | `node --version` |
| 4 | SSH | SSH Key 生成 + 配置 | 第三阶段 | `ssh -T git@github.com` |
| 5 | 基础工具 | jj 安装 | 第三阶段 | `jj version` |
| 6 | Dotfiles | jj git clone --colocate | 第三阶段 | `ls ~/.dotfiles` |
| 7 | 基础工具 | Fish 配置 | 第四阶段 | `stow --adopt fish` |
| 8 | 基础工具 | Starship | 第四阶段 | `cargo install starship` |
| 9 | 基础工具 | Tmux | 第四阶段 | `stow --adopt tmux` |
| 10 | 基础工具 | jj 配置 | 第四阶段 | `stow --adopt jj` |
| 11 | 基础工具 | CLI 工具 | 第四阶段 | `yazi --version` |
| 12 | AI 工具 | opencode | 第五阶段 | `opencode --version` |
| 13 | 开发工具 | Helix, pnpm | 第六阶段 | `helix --version` |

---

## Stow 部署规则

```bash
# 原则：每安装一个工具后，立即用 stow 部署其配置
# 注意：如果目标目录已有文件，使用 --adopt 删除后重新链接

# 示例：

# 1. 安装工具
sudo apt install fish

# 2. 部署配置 (可能已有文件，加 --adopt)
cd ~/.dotfiles && stow --adopt fish

# 3. 验证链接
ls -la ~/.config/fish
```

## 常见问题

1. **Stow 部署失败**: 确保目标目录不存在已有文件 `ls ~/.config/fish`
2. **Cargo 编译失败**: 确保代理已启动，或检查 USTC 镜像
3. **npm 安装慢**: 确保使用 npmmirror 镜像
4. **Fish 配置未生效**: 重启 shell 或 `source ~/.config/fish/config.fish`