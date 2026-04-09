# macOS 开发环境配置指南

按照依赖关系排序，确保依次安装。

## 安装顺序概览

```
┌─────────────────────────────────────────────────────────────────┐
│  第一阶段：系统准备                                               │
│  Xcode CLI → Homebrew → 网络加速配置                             │
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
│  第七阶段：macOS 效率工具                                         │
│  Raycast → Docker → Rectangle                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 第一阶段：系统准备

### 1.1 安装 Xcode Command Line Tools

```bash
xcode-select --install
```

### 1.2 安装 Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 1.3 配置 Homebrew 镜像 (中国区)

```bash
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_CORE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-core"
```

### 1.4 安装系统基础依赖

```bash
brew install \
  curl wget git stow fish tmux \
  build-essential cmake pkg-config \
  openssl@3 sqlite automake autoconf libtool
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
# fnm 依赖 Rust
brew install fnm

# 配置
fish
fnm install --latest
fnm default lts-latest

# 配置 npm 镜像
npm config set registry https://registry.npmmirror.com

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
cat ~/.ssh/id_ed25519.pub | pbcopy

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
# 设置默认 shell
echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish

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
brew install tmux

# 部署配置
cd ~/.dotfiles && stow tmux

# 安装 tmuxinator (可选)
brew install tmuxinator
```

### 4.4 Git 配置

```bash
# Git 已在 Xcode CLI 中，安装新版本
brew install git

git config --global user.name "Levy Gu"
git config --global user.email "32436334@qq.com"
git config --global core.editor helix
git config --global init.defaultBranch main

# GitHub CLI
brew install gh
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

# 通过 Homebrew 安装
brew install \
  fzf \
  ripgrep \
  fd \
  btop \
  tree \
  tldr \
  lf \
  ranger \
  httpie \
  dutree \
  imagemagick \
  ffmpeg

# 验证
yazi --version
eza --version
```

---

## 第五阶段：AI 工具安装 + 配置部署

### 5.1 npm 配置确认

```bash
npm config set registry https://registry.npmmirror.com
```

### 5.2 安装 OpenCode

```bash
# 从官网下载 macOS 版本
# https://opencode.com/download
# 将.app 放到 Applications 或可执行文件放到 PATH 中

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
brew install pnpm
# pnpm 无需配置

pnpm --version
```

### 6.2 Helix 编辑器

```bash
brew install helix

# 部署配置
cd ~/.dotfiles && stow helix

# 验证
helix --version
```

### 6.3 Vim

```bash
brew install vim

# 部署配置
cd ~/.dotfiles && stow vim
```

### 6.4 VS Code

```bash
brew install --cask visual-studio-code

# 安装常用插件
code --install-extension rust-analyzer.rust-analyzer
code --install-extension ms-vscode.vscode-json
code --install-extension editorconfig.editorconfig
```

### 6.5 Python 环境 (uv)

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
uv python install 3.12  # 安装 Python 3.12
uv python list          # 查看已安装版本

# 创建项目环境
cd ~/my-project
uv init                # 初始化项目
uv add requests        # 添加依赖
uv sync               # 同步环境

# 或创建虚拟环境
uv venv .venv
source .venv/bin/activate.fish
```

### 6.6 数据库

```bash
brew install \
  sqlite \
  postgresql@15 \
  mysql@8.0 \
  redis \
  mariadb

# 启动服务
brew services start postgresql@15
brew services start mysql@8.0
brew services start redis

# GUI 工具
brew install --cask tableplus dbeaver-community
```

---

## 第七阶段：macOS 效率工具

### 7.1 Raycast (强烈推荐)

```bash
# 从 App Store 或官网下载
# https://raycast.com
```

### 7.2 Docker

```bash
# 方式 1: Docker Desktop
brew install --cask docker

# 方式 2: OrbStack (轻量级，推荐)
brew install --cask orbstack

# 方式 3: Colima
brew install colima
colima start
```

### 7.3 窗口管理

```bash
# Rectangle
brew install --cask rectangle
```

### 7.4 Ghostty 终端

```bash
brew install ghostty

# 部署配置
cd ~/.dotfiles && stow ghostty
```

### 7.5 云原生工具

```bash
brew install \
  kubectl \
  helm \
  terraform \
  ansible \
  minikube \
  k9s \
  kubectx \
  docker-compose
```

---

## 快速部署脚本

```bash
#!/bin/bash
# setup-macos-ordered.sh

set -e

echo "=== 第一阶段：系统准备 ==="
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"

echo "=== 第二阶段：核心运行时 ==="
# Rust
export RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
export RUSTUP_UPDATE_ROOT="https://mirrors.ustc.edu.cn/rust-static/rustup"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env

# fnm
brew install fnm

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
cargo install jj --locked
stow jj
cargo install yazi eza bat navi television lazygit lazydocker fastfetch tldr gum --locked

echo "=== 第五阶段：AI 工具 ==="
npm config set registry https://registry.npmmirror.com
# opencode 从官网下载
stow opencode

echo "=== 第六阶段：开发工具 ==="
brew install helix pnpm
stow helix
cargo install uv --locked

echo "=== 完成 ==="
echo "运行 fish 进入 shell"
```

---

## 安装顺序检查清单

| 顺序 | 阶段 | 工具 | 部署时机 | 验证命令 |
|------|------|------|----------|----------|
| 1 | 系统准备 | Xcode CLI | 第一阶段 | `xcode-select -p` |
| 2 | 系统准备 | Homebrew | 第一阶段 | `brew --version` |
| 3 | 核心运行时 | Rust | 第二阶段 | `rustc --version` |
| 4 | 核心运行时 | fnm + Node.js | 第二阶段 | `node --version` |
| 5 | SSH | SSH Key 生成 + 配置 | 第三阶段 | `ssh -T git@github.com` |
| 6 | 基础工具 | jj 安装 | 第三阶段 | `jj version` |
| 7 | Dotfiles | jj git clone --colocate | 第三阶段 | `ls ~/.dotfiles` |
| 8 | 基础工具 | Fish 配置 | 第四阶段 | `stow --adopt fish` |
| 9 | 基础工具 | Starship | 第四阶段 | `cargo install starship` |
| 10 | 基础工具 | Tmux | 第四阶段 | `stow --adopt tmux` |
| 11 | 基础工具 | jj 配置 | 第四阶段 | `stow --adopt jj` |
| 12 | 基础工具 | CLI 工具 | 第四阶段 | `yazi --version` |
| 13 | AI 工具 | opencode | 第五阶段 | `opencode --version` |
| 14 | 开发工具 | Helix, pnpm | 第六阶段 | `helix --version` |
| 15 | 效率工具 | Docker, Raycast | 第七阶段 | `docker --version` |

---

## Stow 部署规则

```bash
# 原则：每安装一个工具后，立即用 stow 部署其配置
# 注意：如果目标目录已有文件，使用 --adopt 删除后重新链接

# 示例：

# 1. 安装工具
brew install fish

# 2. 部署配置 (可能已有文件，加 --adopt)
cd ~/.dotfiles && stow --adopt fish

# 3. 验证链接
ls -la ~/.config/fish
```

## 常见问题

1. **Stow 部署失败**: 确保目标目录不存在已有文件
2. **Homebrew 慢**: 确保已配置 USTC 镜像
3. **Docker 无法启动**: 检查 macOS 虚拟化设置，或使用 OrbStack/Colima
4. **Rust 编译内存不足**: `CARGO_BUILD_JOBS=4 cargo install ...`

---

## macOS 专用工具推荐

| 工具 | 用途 | 安装方式 |
|------|------|----------|
| Raycast | 效率启动器 (必装) | App Store / 官网 |
| Rectangle | 窗口管理 | Homebrew |
| OrbStack | 轻量级 Docker | Homebrew |
| TablePlus | 数据库 GUI | Homebrew |
| Obsidian | 笔记 | Homebrew |