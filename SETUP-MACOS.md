# macOS 开发环境配置指南

按照依赖关系排序，确保依次安装。

## 依赖关系图

```
┌─────────────────────────────────────────────────────────────────┐
│                        第一阶段：系统准备                          │
│  Xcode CLI → Homebrew → 网络加速配置                            │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│                        第二阶段：核心运行时                        │
│  Rust → Go → fnm → npm                                          │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│                   第二阶段半：拉取 Dotfiles 仓库                   │
│  Git 安装 → 克隆 dotfiles → Stow 部署配置                        │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│                        第三阶段：Shell 和基础工具                   │
│  Fish + Starship → Git 配置 → jj → CLI 工具                     │
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
│                        第六阶段：macOS 效率工具                    │
│  Raycast → Rectangle → Docker                                  │
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
# 方法 1: 使用中科大镜像
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_CORE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-core"

# 方法 2: 使用清华镜像
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_CORE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-core"

# 持久化配置
echo 'export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"' >> ~/.config/fish/config.fish
echo 'export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"' >> ~/.config/fish/config.fish
echo 'export HOMEBREW_CORE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-core"' >> ~/.config/fish/config.fish
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
brew install go

# 配置 Go 镜像
fish
set -gx GOPROXY "https://goproxy.cn,direct"
# 持久化
echo 'set -gx GOPROXY "https://goproxy.cn,direct"' >> ~/.config/fish/config.fish

go version
```

### 2.3 安装 fnm (Node.js 版本管理器)

```bash
# fnm 依赖 Rust (已完成)
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

## 第二阶段半：拉取 Dotfiles 仓库

在安装完核心运行时后，应该立即拉取 dotfiles 仓库，这样后续的工具配置都可以使用 stow 进行管理。

### 2.5 拉取 Dotfiles 仓库

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
stow fish tmux helix vim starship jj cargo opencode ghostty television

# 或逐个部署
stow fish
stow tmux
stow helix
# ... 其他模块
```

### 2.6 Stow 常用命令

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

### 2.7 验证 dotfiles 链接

```bash
# 检查关键配置是否已链接
ls -la ~/.config/fish     # 应该指向 ~/.dotfiles/fish/.config/fish
ls -la ~/.tmux.conf       # 应该指向 ~/.dotfiles/tmux/.tmux.conf
ls -la ~/.config/helix    # 应该指向 ~/.dotfiles/helix/.config/helix
```

---

## 第三阶段：Shell 和基础工具

### 3.1 配置 Fish Shell

```bash
# 设为默认 shell
echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish

# 配置已在第二阶段通过 stow 部署
# 如果需要手动配置：
# mkdir -p ~/.config/fish
# ln -sf ~/.dotfiles/fish/.config/fish/config.fish ~/.config/fish/config.fish
```

### 3.2 安装 Starship 提示符

```bash
# Starship 依赖 Rust
cargo install starship --locked

# 配置已在第二阶段通过 stow 部署
```

### 3.3 安装 Tmux

```bash
brew install tmux
# 配置已在第二阶段通过 stow 部署
# 如果需要手动配置：
# ln -sf ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf

# 安装 tmuxinator (可选)
brew install tmuxinator
```

### 3.4 Git 和版本控制

```bash
# 安装 Git (Xcode CLI 已包含，可升级)
brew install git

# 配置 Git
git config --global user.name "Levy Gu"
git config --global user.email "32436334@qq.com"
git config --global core.editor helix
git config --global init.defaultBranch main

# 配置 Git 镜像 (加速 GitHub)
git config --global url."https://ghproxy.com/".insteadOf https://github.com/
git config --global url."https://hub.gitmirror.com/".insteadOf https://github.com/

# 安装 jj (依赖 Rust)
cargo install jj --locked
mkdir -p ~/.config
ln -sf ~/.dotfiles/jj/.config/jj ~/.config/jj

# 配置 jj
cat > ~/.config/jj/config.toml << 'EOF'
[user]
name = "Levy Gu"
email = "32436334@qq.com"

[ui]
default-command = "log"
EOF
```

### 3.5 批量安装 CLI 工具

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

# 创建别名 (添加到 ~/.config/fish/config.fish)
# alias ll="eza -l"
# alias lla="eza -la"
# alias lt="eza -T"
# alias yz="yazi"
```

---

## 第四阶段：AI 工具

### 4.1 npm 配置确认 (已在第二阶段完成)

```bash
# 确认镜像配置
npm config get registry
# 应显示: https://registry.npmmirror.com
```

### 4.2 安装 OpenCode

```bash
# 方式 1: 从官网下载 macOS 版本
# https://opencode.com/download

# 方式 2: 如果有 npm 包
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
npm install -g @anthropic-ai/claude-code
```

---

## 第五阶段：开发工具

### 5.1 安装 pnpm

```bash
brew install pnpm
pnpm --version
```

### 5.2 安装编辑器

```bash
# Helix
brew install helix
ln -sf ~/.dotfiles/helix/.config/helix ~/.config/helix

# Vim
brew install vim
ln -sf ~/.dotfiles/vim/.vimrc ~/.vimrc

# VS Code
brew install --cask visual-studio-code

# 安装插件
code --install-extension rust-analyzer.rust-analyzer
code --install-extension vscodevim.vim
code --install-extension esbenp.prettier-vscode
```

### 5.3 Python 环境

```bash
# 安装 uv (依赖 Rust)
cargo install uv --locked

# 安装 Python (macOS 已内置，可升级)
brew install python3

# 配置 uv 镜像
uv config set mirror https://mirrors.ustc.edu.cn/pypi/web/simple
```

### 5.4 数据库工具

```bash
# 通过 Homebrew 安装
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

# 或使用 GUI 工具
brew install --cask \
  tableplus \
  postman \
  insomnia
```

---

## 第六阶段：macOS 效率工具

### 6.1 Raycast (强烈推荐)

```bash
# 从 App Store 或官网下载
# https://raycast.com

# 安装扩展
brew install raycast
```

### 6.2 窗口管理

```bash
# Rectangle
brew install --cask rectangle

# 或 yabai (需关闭 SIP)
# brew install yabai
```

### 6.3 容器工具

```bash
# Docker Desktop
brew install --cask docker

# 或 OrbStack (轻量级，推荐)
brew install --cask orbstack

# 或 Colima (轻量级容器运行时)
brew install colima
colima start

# Docker Compose
brew install docker-compose
```

### 6.4 云原生工具

```bash
brew install \
  kubectl \
  helm \
  terraform \
  ansible \
  minikube \
  k9s \
  kubectx \
  istioctl \
  docker-compose
```

### 6.5 Ghostty 终端

```bash
brew install ghostty
ln -sf ~/.dotfiles/ghostty/.config/ghostty ~/.config/ghostty
```

### 6.6 其他工具

```bash
# 效率工具
brew install --cask \
  raycast \
  alfred \
  clipboardy \
  rectangle \
  obsidian \
  discord \
  slack \
  docker

# 开发工具
brew install --cask \
  fork \
  tower \
  gitup \
  sourcetree \
  dbeaver-community

# 媒体工具
brew install --cask \
  vlc \
  iina \
  handbrake
```

---

## 快速部署脚本

```bash
#!/bin/bash
# setup-macos-ordered.sh
# 按依赖关系顺序执行

set -e

echo "=========================================="
echo "第一阶段：系统准备"
echo "=========================================="

# Xcode CLI
xcode-select --install

# 安装 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 配置 Homebrew 镜像
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"

# 基础依赖
brew install \
  curl wget git stow fish tmux \
  build-essential cmake pkg-config \
  openssl@3 sqlite

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
registry = "https://github.com/rust-lang/crates-io-index"
replace-with = "ustc"

[source.ustc]
registry = "https://mirrors.ustc.edu.cn/crates.io-index"

[net]
git-fetch-with-cli = true
EOF

source ~/.cargo/env

# Go
brew install go

# fnm
brew install fnm
fish -c "fnm install --latest && fnm default lts-latest"

# npm 镜像
npm config set registry https://registry.npmmirror.com

echo "=========================================="
echo "第三阶段：Shell 和基础工具"
echo "=========================================="

# Fish shell
echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
mkdir -p ~/.config/fish
ln -sf ~/.dotfiles/fish/.config/fish/config.fish ~/.config/fish/config.fish

# Starship
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
brew install fzf ripgrep fd btop tree lf httpie

echo "=========================================="
echo "第四阶段：AI 工具"
echo "=========================================="

# opencode - 从官网下载后放到 PATH 中

echo "=========================================="
echo "第五阶段：开发工具"
echo "=========================================="

# pnpm
brew install pnpm

# 编辑器
brew install helix
ln -sf ~/.dotfiles/helix/.config/helix ~/.config/helix

# Python uv
cargo install uv --locked

# 数据库 (可选)
# brew install postgresql@15 mysql@8.0 redis

echo "=========================================="
echo "第六阶段：macOS 效率工具"
echo "=========================================="

# 容器
brew install --cask orbstack

# 其他工具 (可选)
# brew install --cask visual-studio-code rectangle obsidian postman

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
| 1 | 系统准备 | Xcode CLI | `xcode-select -p` |
| 2 | 系统准备 | Homebrew | `brew --version` |
| 3 | 核心运行时 | Rust | `rustc --version` |
| 4 | 核心运行时 | Go | `go version` |
| 5 | 核心运行时 | fnm + Node.js | `node --version` |
| 6 | **Dotfiles** | 克隆仓库 + Stow 部署 | `ls -la ~/.config/fish` |
| 7 | 基础工具 | Fish + Starship | `starship --version` |
| 8 | 基础工具 | Tmux | `tmux -V` |
| 9 | 基础工具 | Git + jj | `jj version` |
| 10 | 基础工具 | CLI 工具 | `yazi --version` |
| 11 | AI 工具 | opencode | `opencode --version` |
| 12 | 开发工具 | Helix, pnpm | `helix --version` |
| 13 | 效率工具 | Raycast, Docker | `docker --version` |

---

## 常见问题

1. **Homebrew 慢**: 确保已配置 USTC 镜像
2. **Cargo 编译失败**: 确保代理已启动，或检查 USTC 镜像
3. **npm 安装慢**: 确保使用 npmmirror 镜像
4. **Docker 无法启动**: 检查 macOS 虚拟化设置，或使用 OrbStack/Colima
5. **Rust 编译内存不足**: 限制并发数 `CARGO_BUILD_JOBS=4 cargo install ...`
6. **fish 无法设为默认**: 需要先安装 Fish 到 `/etc/shells`

---

## macOS 专用工具推荐

| 工具 | 用途 | 安装方式 |
|------|------|----------|
| Raycast | 效率启动器 (必装) | App Store / 官网 |
| Rectangle | 窗口管理 | Homebrew |
| OrbStack | 轻量级 Docker | Homebrew |
| TablePlus | 数据库 GUI | Homebrew |
| Postman | API 测试 | Homebrew |
| Obsidian | 笔记 | Homebrew |
| VS Code | 代码编辑 | Homebrew |