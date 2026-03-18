# 🦆 鸭子 Windows 部署指南

## 快速部署（推荐）

### 1️⃣ 下载部署脚本

```powershell
# 克隆仓库
git clone https://github.com/Liuyz279/home.git
cd home
```

### 2️⃣ 运行一键部署

以**管理员身份**打开 PowerShell，运行：

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\deploy-windows.ps1
```

### 3️⃣ 配置认证

部署完成后，配置模型认证：

```powershell
openclaw models auth login --provider qwen-portal
```

### 4️⃣ 开始使用

```powershell
openclaw status
```

---

## 手动部署

如果自动脚本有问题，可以手动执行：

### 前置要求

- **Node.js** v18+ ([下载](https://nodejs.org/))
- **Git** ([下载](https://git-scm.com/))

### 步骤

```powershell
# 1. 安装 OpenClaw
npm install -g openclaw

# 2. 创建工作区
$workspace = "$HOME\.openclaw\workspace"
New-Item -ItemType Directory -Path $workspace -Force

# 3. 克隆配置仓库
git clone https://github.com/Liuyz279/home.git
cd home

# 4. 复制配置文件
Copy-Item SOUL.md USER.md IDENTITY.md TOOLS.md AGENTS.md HEARTBEAT.md $workspace\
Copy-Item memory $workspace\ -Recurse

# 5. 配置认证
openclaw models auth login --provider qwen-portal

# 6. 启动 Gateway
openclaw gateway start

# 7. 检查状态
openclaw status
```

---

## 文件说明

| 文件 | 说明 |
|------|------|
| `deploy-windows.ps1` | Windows 一键部署脚本 |
| `scripts/backup.sh` | Linux/Mac 自动备份脚本 |
| `SOUL.md` | 核心人格配置 |
| `USER.md` | 用户信息 |
| `MEMORY.md` | 长期记忆 |
| `TOOLS.md` | 工具配置 |

---

## 常见问题

### Q: 脚本无法运行？
```powershell
# 解除执行策略限制
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Q: npm 安装失败？
- 检查 Node.js 版本：`node --version`
- 尝试使用管理员权限运行 PowerShell
- 检查网络连接

### Q: 认证失败？
- 确保已登录 Qwen 账号
- 检查网络连接
- 重新运行：`openclaw models auth login --provider qwen-portal`

### Q: 如何更新配置？
```powershell
cd home
git pull origin main
.\deploy-windows.ps1
```

---

## 备份与恢复

### 查看备份仓库
https://github.com/Liuyz279/home

### 手动备份
```powershell
cd home
bash scripts/backup.sh  # 需要 Git Bash
```

### 自动备份
每天凌晨 2:00 自动同步到 GitHub

---

**🦆 鸭子陪你，随时随地！**
