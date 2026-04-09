# Linux 通用安装步骤

本文档包含所有 Linux 发行版通用的安装步骤。

> **注意**: 开始本文档前，先完成对应发行版的系统基础配置阶段。

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
# 复制公钥到剪贴板 (Ubuntu)
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

## 第四阶段：Fish + AI 工具 (优先)

### 4.1 配置 Fish Shell

```bash
# 部署配置
cd ~/.dotfiles && stow --adopt fish

# 启动 fish
fish
```

### 4.2 AI 工具：OpenCode (优先安装)

```bash
# 配置 npm 镜像 (中国区)
npm config set registry https://registry.npmmirror.com

# 从官网下载 Linux 版本
# https://opencode.com/download
# 将可执行文件放到 PATH 中 (如 ~/.local/bin/)

# 部署配置
cd ~/.dotfiles && stow --adopt opencode

# 验证
opencode --version
```

---

## 第五阶段：基础工具安装 + 配置部署

### 5.1 Starship 提示符

```bash
# 安装 Starship (依赖 Rust)
cargo install starship --locked

# 部署配置
cd ~/.dotfiles && stow --adopt starship

# 验证
starship --version
```

### 5.2 Tmux

```bash
# 部署配置
cd ~/.dotfiles && stow --adopt tmux

# 验证
tmux -V
```

### 5.3 Git 配置

```bash
# 配置用户信息
git config --global user.name "Levy Gu"
git config --global user.email "32436334@qq.com"
git config --global core.editor helix
```

### 5.4 jj 版本控制

```bash
# jj 已在第三阶段安装
# 部署配置
cd ~/.dotfiles && stow --adopt jj

# 验证
jj version
```

### 5.5 CLI 工具批量安装

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

# 通过 apt 安装 (Ubuntu)
sudo apt install -y fzf ripgrep fd-find btop tree

# 验证
yazi --version
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
# 安装 Helix
sudo apt install helix

# 部署配置
cd ~/.dotfiles && stow --adopt helix

# 验证
helix --version
```

### 6.3 Zed 编辑器 (AI 增强)

```bash
# 安装 Zed
curl -f https://zed.dev/install.sh | sh

# 验证
zed --version
```

### 6.3 Vim

```bash
sudo apt install vim
cd ~/.dotfiles && stow --adopt vim
```

### 6.4 Python 环境 (uv)

```bash
# 安装 uv (依赖 Rust)
cargo install uv --locked

# 配置 uv 镜像 (中国区)
mkdir -p ~/.config/uv
cat > ~/.config/uv/settings.toml << 'EOF'
[pip]
index-url = "https://mirrors.ustc.edu.cn/pypi/web/simple"
trusted-host = ["mirrors.ustc.edu.cn"]

[python]
pre-release = false
EOF

# 创建 Python 环境
uv python install 3.12
uv python list

# 创建项目环境
cd ~/my-project
uv init
uv add requests
uv sync

# 或创建虚拟环境
uv venv .venv
source .venv/bin/activate
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
cd ~/.dotfiles && stow --adopt niri
```

### 7.2 Fcitx5 输入法

```bash
# 安装 Fcitx5
sudo apt install fcitx5 fcitx5-configtool
sudo apt install fcitx5-frontend-gtk3 fcitx5-frontend-qt5
sudo apt install fcitx5-rime librime

# 部署配置
cd ~/.dotfiles && stow --adopt fcitx5
```

### 7.3 Waybar 状态栏

```bash
# 安装 waybar
sudo apt install waybar

# 部署配置
cd ~/.dotfiles && stow --adopt waybar
```

### 7.4 Ghostty 终端

```bash
# 从 https://ghostty.org/download 下载

# 部署配置
cd ~/.dotfiles && stow --adopt ghostty
```

---

## 快速部署脚本 (通用部分)

```bash
#!/bin/bash
# 通用安装脚本 - 在系统基础配置后运行

set -e

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

echo "=== 第四阶段：Fish + AI 工具 ==="
stow --adopt fish
npm config set registry https://registry.npmmirror.com
# opencode 从官网下载后放到 PATH 中
stow --adopt opencode

echo "=== 第五阶段：基础工具 ==="
cargo install starship --locked
stow --adopt starship
stow --adopt tmux
stow --adopt jj
cargo install yazi eza bat navi television lazygit lazydocker fastfetch tldr gum --locked

echo "=== 第六阶段：开发工具 ==="
sudo apt install helix
stow --adopt helix
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
| 7 | 第四阶段 | Fish 配置 | stow --adopt fish | `fish --version` |
| 8 | 第四阶段 | OpenCode (AI) | 优先安装 | `opencode --version` |
| 9 | 第五阶段 | Starship | 第五阶段 | `cargo install starship` |
| 10 | 第五阶段 | Tmux | stow --adopt tmux | `tmux -V` |
| 11 | 第五阶段 | jj 配置 | stow --adopt jj | `jj version` |
| 12 | 第五阶段 | CLI 工具 | 第五阶段 | `yazi --version` |
| 13 | 第六阶段 | Helix, pnpm | 第六阶段 | `helix --version` |
| 14 | 第七阶段 | Niri/Waybar/Fcitx5 | stow --adopt | - |