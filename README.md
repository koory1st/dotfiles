# Dotfiles 配置指南

本仓库包含在 Linux 和 macOS 上的开发环境配置。

## 文件说明

| 文件 | 说明 |
|------|------|
| [SETUP-LINUX.md](SETUP-LINUX.md) | Linux 系统安装指南 (Ubuntu/Fedora/Arch/NixOS) |
| [SETUP-MACOS.md](SETUP-MACOS.md) | macOS 系统安装指南 |

## 快速开始

### 1. 选择你的操作系统

- **[Linux 安装指南 →](SETUP-LINUX.md)**
- **[macOS 安装指南 →](SETUP-MACOS.md)**

### 2. 安装顺序概览

```
系统基础 → Rust → Go → fnm → 克隆 dotfiles → Stow 部署 → AI 工具 → 开发工具
```

## 配置模块

| 目录 | 工具 |
|------|------|
| `fish/` | Shell |
| `tmux/` | 终端复用器 |
| `helix/` | 编辑器 |
| `niri/` | Wayland 窗口管理器 (Linux) |
| `ghostty/` | 终端 (macOS/Linux) |
| `waybar/` | 状态栏 (Linux) |
| `fcitx5/` | 输入法 (Linux) |
| `starship/` | Shell 提示符 |
| `cargo/` | Rust 配置 |
| `jj/` | 版本控制 |
| `opencode/` | AI 编程助手 |

## 常用命令

```bash
# 部署配置
cd ~/.dotfiles
stow fish tmux helix vim starship jj cargo opencode ghostty television niri waybar fcitx5

# 查看可用包
stow --dry-run -v *

# 重新部署
stow -R fish
```

## 验证

```bash
# 检查配置链接
ls -la ~/.config/fish
ls -la ~/.tmux.conf

# 检查工具版本
rustc --version
node --version
opencode --version
```