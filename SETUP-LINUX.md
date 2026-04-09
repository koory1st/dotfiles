# Linux 开发环境配置指南

本目录包含各 Linux 发行版的详细安装指南。

## 文件结构

```
setup/
├── COMMON.md              # 通用安装步骤 (核心运行时 → 工具安装)
├── SETUP-UBUNTU.md        # Ubuntu 专用
└── SETUP-ARCH.md         # Arch Linux 专用
```

## 安装顺序概览

所有发行版都遵循相同的安装顺序：

```
第一阶段：系统基础 (发行版特定)
        ↓
第二阶段：核心运行时 (通用)
        ↓
第三阶段：SSH + jj + Dotfiles (通用)
        ↓
第四阶段：Fish + AI 工具 (优先)
        ↓
第五阶段：基础工具
        ↓
第六阶段：开发工具
        ↓
第七阶段：桌面环境 (可选)
```

## 选择你的发行版

- [Ubuntu →](setup/SETUP-UBUNTU.md)
- [Fedora →](setup/SETUP-FEDORA.md)
- [Arch Linux →](setup/SETUP-ARCH.md)

## 快速开始

1. 选择对应发行版的文档
2. 按照第一阶段完成系统基础配置
3. 引用 COMMON.md 完成剩余阶段