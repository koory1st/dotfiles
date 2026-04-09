# Termux (Android) 开发环境配置指南

按照依赖关系排序，确保依次安装。

## 安装顺序概览

```
┌─────────────────────────────────────────────────────────────────┐
│  第一阶段：Termux 基础                                            │
│  pkg 更新 → 安装基础工具 → 网络加速配置                          │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第二阶段：核心运行时                                              │
│  Rust → Node.js (fnm)                                            │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第三阶段：SSH 配置 + jj + Dotfiles                                │
│  SSH Key → jj 安装 → jj git clone --colocate dotfiles           │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第四阶段：Fish + AI 工具 (优先)                                   │
│  Fish 安装 → stow 部署 → opencode 安装                          │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第五阶段：基础工具安装 + 配置部署                                  │
│  Starship → stow 部署 → Tmux → jj 配置 → CLI 工具                │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第六阶段：开发工具安装 + 配置部署                                  │
│  Helix 安装 → stow 部署 → pnpm → stow 部署 → ...                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 第一阶段：Termux 基础

### 1.1 安装 Termux

从 F-Droid 或 Google Play 安装 Termux：

- **F-Droid** (推荐): https://f-droid.org/packages/com.termux/
- **Google Play**: https://play.google.com/store/apps/details?id=com.termux

### 1.2 更新包管理器

```bash
pkg update && pkg upgrade -y
```

### 1.3 安装系统基础依赖

```bash
pkg install \
  curl wget git stow fish tmux \
  build-essential cmake pkg-config \
  openssl libssl-dev \
  sqlite \
  ncurses-utils \
  termux-tools \
  coreutils \
  procps \
  util-linux
```

### 1.4 网络加速配置

#### 配置 pkg 镜像 (清华镜像)

```bash
pkg add-repo x论:x https://mirrors.tuna.tsinghua.edu.cn/termux/termux-main
# 或手动设置
pkg update
```

#### 配置 Git 镜像

```bash
git config --global url."https://ghproxy.com/".insteadOf https://github.com/
git config --global url."https://hub.gitmirror.com/".insteadOf https://github.com/
```

#### 配置代理

```bash
# 如果需要代理
set -gx http_proxy http://127.0.0.1:7897
set -gx https_proxy http://127.0.0.1:7897
set -gx all_proxy socks5://127.0.0.1:7890
```

### 1.5 安装 Rust 依赖

```bash
pkg install rust
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
# 安装 Node.js 通过 nvm 或直接安装
pkg install nodejs

# 或使用 fnm
curl -fsSL https://fnm.vercel.app/install | bash

# 验证
node --version
npm --version
```

---

## 第三阶段：SSH 配置 + jj + Dotfiles

### 3.1 配置 SSH Key (用于 GitHub)

```bash
# 安装 openssh
pkg install openssh

# 生成 SSH key
ssh-keygen -t ed25519 -C "32436334@qq.com"

# 查看公钥
cat ~/.ssh/id_ed25519.pub
```

### 3.2 添加 SSH Key 到 GitHub

```bash
# 复制公钥
cat ~/.ssh/id_ed25519.pub | termux-clipboard-set

# 然后在 GitHub 网站添加：
# https://github.com/settings/keys
```

### 3.3 安装 jj (依赖 Rust)

```bash
cargo install jj --locked

# 配置 jj 用户信息
jj config set --user.name "Levy Gu"
jj config set --user.email "32436334@qq.com"
```

### 3.4 使用 jj git clone --colocate 克隆仓库

```bash
# 使用 jj 的 colocate 模式克隆
jj git clone --colocate git@github.com:yourusername/dotfiles.git .dotfiles

cd .dotfiles

# 验证
stow --version
jj log --limit 1
```

---

## 第四阶段：Fish + AI 工具 (优先)

### 4.1 Fish Shell

```bash
# 安装 Fish
pkg install fish

# 设为默认 shell
chsh -s fish

# 部署配置
cd ~/.dotfiles && stow --adopt fish

# 启动 fish
fish
```

### 4.2 AI 工具：OpenCode (优先安装)

```bash
# 配置 npm 镜像
npm config set registry https://registry.npmmirror.com

# 从官网下载 Termux 版本
# https://opencode.com/download

# 或使用 npm 安装 (如果可用)
# npm install -g opencode
```

---

## 第五阶段：基础工具安装 + 配置部署

### 5.1 Starship 提示符

```bash
cargo install starship --locked

# 部署配置
cd ~/.dotfiles && stow --adopt starship

# 验证
starship --version
```

### 5.2 Tmux

```bash
# tmux 已在第一阶段安装
cd ~/.dotfiles && stow --adopt tmux

# 验证
tmux -V
```

### 5.3 jj 版本控制

```bash
cd ~/.dotfiles && stow --adopt jj

# 验证
jj version
```

### 5.4 CLI 工具安装

```bash
# 通过 pkg 安装
pkg install \
  fzf \
  ripgrep \
  fd \
  btop \
  tree \
  htop \
  neofetch \
  wget \
  curl \
  vim \
  neovim \
  python \
  rust

# 通过 cargo 安装
cargo install \
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

# 验证
eza --version
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
# Termux 上可能需要从源码编译
# 或使用 neovim 作为替代
pkg install neovim

# 部署配置
cd ~/.dotfiles && stow --adopt vim
```

### 6.3 Python 环境 (uv)

```bash
# 安装 uv
cargo install uv --locked

# 配置 uv 镜像
mkdir -p ~/.config/uv
cat > ~/.config/uv/settings.toml << 'EOF'
[pip]
index-url = "https://mirrors.ustc.edu.cn/pypi/web/simple"
trusted-host = ["mirrors.ustc.edu.cn"]

[python]
pre-release = false
EOF

# 安装 Python
pkg install python

# 创建环境
uv python install 3.12
uv venv .venv
```

---

## Termux 特有配置

### 存储权限

```bash
# 授予存储权限
termux-setup-storage

# 这允许访问 /sdcard 等目录
```

### 常用快捷键

| 快捷键 | 功能 |
|--------|------|
| `Vol+` + `C` | 复制 |
| `Vol+` + `V` | 粘贴 |
| `Vol+` + `N` | 新建标签 |
| `Vol+` + `W` | 关闭标签 |
| `Vol+` + `1-9` | 切换标签 |
| `Vol+` + `L` | 清除屏幕 |
| `Vol+` + `H` | 帮助 |

### Termux 启动 SSH

```bash
# 设置密码
passwd

# 启动 sshd
sshd

# 默认端口 8022
ssh user@localhost -p 8022
```

---

## 快速部署脚本

```bash
#!/bin/bash
# setup-termux.sh

set -e

echo "=== 第一阶段：Termux 基础 ==="
pkg update && pkg upgrade -y
pkg install \
  curl wget git stow fish tmux \
  build-essential cmake pkg-config \
  openssl libssl-dev sqlite \
  ncurses-utils termux-tools \
  coreutils procps util-linux

echo "=== 第二阶段：核心运行时 ==="
pkg install rust nodejs

echo "=== 第三阶段：SSH + jj + Dotfiles ==="
pkg install openssh
ssh-keygen -t ed25519 -C "32436334@qq.com"

echo "请手动添加 SSH key 到 GitHub"
cat ~/.ssh/id_ed25519.pub

cargo install jj --locked
jj config set --user.name "Levy Gu"
jj config set --user.email "32436334@qq.com"

jj git clone --colocate git@github.com:yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

echo "=== 第四阶段：Fish + AI 工具 ==="
pkg install fish
chsh -s fish
stow --adopt fish

echo "=== 第五阶段：基础工具 ==="
cargo install starship eza bat navi television lazygit fastfetch tldr gum --locked
stow --adopt starship
stow --adopt tmux
stow --adopt jj

echo "=== 完成 ==="
echo "运行 fish 进入 shell"
```

---

## 安装顺序检查清单

| 顺序 | 阶段 | 工具 | 验证命令 |
|------|------|------|----------|
| 1 | Termux 基础 | pkg update, stow | `stow --version` |
| 2 | 核心运行时 | Rust, Node.js | `rustc --version; node --version` |
| 3 | SSH + Dotfiles | jj, git clone | `jj version` |
| 4 | Fish + OpenCode | 优先安装 | `fish; opencode` |
| 5 | 基础工具 | Starship, Tmux | `starship --version` |
| 6 | 开发工具 | Helix, pnpm | `helix --version` |