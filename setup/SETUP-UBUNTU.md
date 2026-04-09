# Ubuntu 开发环境配置指南

按照依赖关系排序，确保依次安装。

## 安装顺序概览

```
┌─────────────────────────────────────────────────────────────────┐
│  第一阶段：Ubuntu 系统基础                                        │
│  系统更新 → 安装 stow → 网络加速配置                              │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第二阶段：核心运行时 (通用) → 见 COMMON.md                       │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第三阶段：SSH 配置 + jj + Dotfiles (通用) → 见 COMMON.md          │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第四阶段：Fish + AI 工具 (优先) → 见 COMMON.md                    │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第五阶段：基础工具 → 见 COMMON.md                                │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第六阶段：开发工具 → 见 COMMON.md                                │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│  第七阶段：桌面环境 (可选) → 见 COMMON.md                          │
└─────────────────────────────────────────────────────────────────┘
```

---

## 第一阶段：Ubuntu 系统基础

### 1.1 系统更新

```bash
sudo apt update && sudo apt upgrade -y
```

### 1.2 安装系统基础依赖

```bash
sudo apt install -y \
  curl wget git stow fish tmux \
  build-essential cmake pkg-config \
  libssl-dev \
  sqlite3 libsqlite3-dev \
  libayatana-appindicator3-dev \
  libwebkit2gtk-4.1-dev libgtk-3-dev \
  libxkbcommon0 libinput10 libegl1 libglib2.0-0 \
  fuse libfuse2 \
  dbus-x11 \
  xclip
```

### 1.3 网络加速配置

#### 配置 apt 镜像源 (清华镜像)

```bash
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo bash -c 'cat > /etc/apt/sources.list << "EOF"
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
EOF'

sudo apt update
```

#### 配置 Git 镜像

```bash
git config --global url."https://ghproxy.com/".insteadOf https://github.com/
git config --global url."https://hub.gitmirror.com/".insteadOf https://github.com/
```

---

## 第二阶段：核心运行时

参见 [COMMON.md](COMMON.md#第二阶段核心运行时)

---

## 第三阶段：SSH 配置 + jj + Dotfiles

参见 [COMMON.md](COMMON.md#第三阶段ssh-配置--jj--dotfiles)

---

## 第四阶段：Fish + AI 工具 (优先)

参见 [COMMON.md](COMMON.md#第四阶段fish--ai-工具-优先)

---

## 第五阶段：基础工具安装 + 配置部署

参见 [COMMON.md](COMMON.md#第五阶段基础工具安装--配置部署)

---

## 第六阶段：开发工具安装 + 配置部署

参见 [COMMON.md](COMMON.md#第六阶段开发工具安装--配置部署)

---

## 第七阶段：桌面环境 (可选)

参见 [COMMON.md](COMMON.md#第七阶段桌面环境-可选)

---

## 快速部署脚本

```bash
#!/bin/bash
# setup-ubuntu.sh

set -e

echo "=== 第一阶段：Ubuntu 系统基础 ==="
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
  curl wget git stow fish tmux \
  build-essential cmake pkg-config \
  libssl-dev sqlite3 libsqlite3-dev \
  libwebkit2gtk-4.1-dev libgtk-3-dev \
  libxkbcommon0 libinput10 libegl1 \
  fuse libfuse2 dbus-x11 xclip

# 配置 apt 镜像
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo bash -c 'cat > /etc/apt/sources.list << "EOF"
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
EOF'
sudo apt update

# 后续阶段
# 参见 COMMON.md

echo "=== 完成基础配置 ==="
echo "请继续按照 COMMON.md 完成剩余阶段"
```

---

## 安装顺序检查清单

| 顺序 | 阶段 | 工具 | 验证命令 |
|------|------|------|----------|
| 1 | Ubuntu 系统 | apt update, stow | `stow --version` |
| 2 | 核心运行时 | Rust, fnm | `rustc --version; node --version` |
| 3 | SSH + Dotfiles | jj, git clone | `jj version` |
| 4 | Fish + OpenCode | 优先安装 | `fish; opencode` |
| 5-7 | 其他工具 | 见 COMMON.md | - |