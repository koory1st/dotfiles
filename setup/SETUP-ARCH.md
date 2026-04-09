# Arch Linux 开发环境配置指南

按照依赖关系排序，确保依次安装。

## 安装顺序概览

```
┌─────────────────────────────────────────────────────────────────┐
│  第一阶段：Arch Linux 系统基础                                    │
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

## 第一阶段：Arch Linux 系统基础

### 1.1 系统更新

```bash
sudo pacman -Syu
```

### 1.2 安装系统基础依赖

```bash
sudo pacman -Syu
sudo pacman -S \
  curl wget git stow fish tmux \
  base-devel cmake pkgconf \
  openssl sqlite \
  gtk3 webkit2gtk \
  libxkbcommon libinput fuse2 dbus \
  xclip
```

### 1.3 网络加速配置

#### 配置 pacman 镜像源 (清华镜像)

```bash
sudo bash -c 'echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist'
sudo pacman -Syy
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

> **注意**: Arch 上部分 CLI 工具通过 `yay` 或 `paru` 从 AUR 安装

---

## 第六阶段：开发工具安装 + 配置部署

参见 [COMMON.md](COMMON.md#第六阶段开发工具安装--配置部署)

> **注意**: Arch 上使用 `yay` 或 `paru` 安装 AUR 包，如 `helix` 可能需要从 AUR 安装

---

## 第七阶段：桌面环境 (可选)

参见 [COMMON.md](COMMON.md#第七阶段桌面环境-可选)

---

## 快速部署脚本

```bash
#!/bin/bash
# setup-arch.sh

set -e

echo "=== 第一阶段：Arch Linux 系统基础 ==="
sudo pacman -Syu
sudo pacman -S \
  curl wget git stow fish tmux \
  base-devel cmake pkgconf \
  openssl sqlite \
  gtk3 webkit2gtk \
  libxkbcommon libinput fuse2 dbus \
  xclip

# 配置 pacman 镜像
sudo bash -c 'echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist'
sudo pacman -Syy

echo "=== 完成基础配置 ==="
echo "请继续按照 COMMON.md 完成剩余阶段"
```

---

## 安装顺序检查清单

| 顺序 | 阶段 | 工具 | 验证命令 |
|------|------|------|----------|
| 1 | Arch 系统 | pacman -Syu, stow | `stow --version` |
| 2 | 核心运行时 | Rust, fnm | `rustc --version; node --version` |
| 3 | SSH + Dotfiles | jj, git clone | `jj version` |
| 4 | Fish + OpenCode | 优先安装 | `fish; opencode` |
| 5-7 | 其他工具 | 见 COMMON.md | - |

---

## Arch 特有命令参考

```bash
# 搜索包
pacman -Ss <package>

# 安装包
sudo pacman -S <package>

# 列出已安装的包
pacman -Q

# 清理未使用的依赖
sudo pacman -Rns $(pacman -Qdtq)

# 使用 yay 安装 AUR 包
yay -S <aur-package>
```