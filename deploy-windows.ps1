# 🦆 鸭子 (Duck) Windows 一键部署脚本
# 用于在新 Windows 机器上快速恢复 OpenClaw 和鸭子配置

param(
    [string]$GitHubRepo = "https://github.com/Liuyz279/home.git",
    [string]$WorkspaceDir = "$HOME\.openclaw\workspace"
)

Write-Host "🦆 鸭子 Windows 部署脚本" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan
Write-Host ""

# 检查 Node.js
Write-Host "📦 检查 Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version 2>&1
    Write-Host "✅ Node.js 已安装：$nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js 未安装" -ForegroundColor Red
    Write-Host "请前往 https://nodejs.org/ 下载并安装 Node.js (v18+)" -ForegroundColor Yellow
    Write-Host "安装完成后重新运行此脚本" -ForegroundColor Yellow
    exit 1
}

# 检查 npm
Write-Host "📦 检查 npm..." -ForegroundColor Yellow
try {
    $npmVersion = npm --version 2>&1
    Write-Host "✅ npm 已安装：$npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ npm 未找到" -ForegroundColor Red
    exit 1
}

Write-Host ""

# 安装 OpenClaw
Write-Host "🔧 安装 OpenClaw..." -ForegroundColor Yellow
try {
    npm install -g openclaw 2>&1 | Tee-Object -Variable installOutput
    Write-Host "✅ OpenClaw 安装完成" -ForegroundColor Green
} catch {
    Write-Host "❌ OpenClaw 安装失败" -ForegroundColor Red
    Write-Host "错误信息：$_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# 创建工作区目录
Write-Host "📁 创建工作区目录..." -ForegroundColor Yellow
if (-not (Test-Path $WorkspaceDir)) {
    New-Item -ItemType Directory -Path $WorkspaceDir -Force | Out-Null
    Write-Host "✅ 工作区已创建：$WorkspaceDir" -ForegroundColor Green
} else {
    Write-Host "✅ 工作区已存在：$WorkspaceDir" -ForegroundColor Green
}

Write-Host ""

# 克隆 GitHub 仓库
$BackupDir = "$WorkspaceDir\home"
Write-Host "📥 克隆 GitHub 仓库..." -ForegroundColor Yellow
if (Test-Path "$BackupDir\.git") {
    Write-Host "ℹ️  仓库已存在，拉取最新代码..." -ForegroundColor Cyan
    Set-Location $BackupDir
    git pull origin main 2>&1
} else {
    if (Test-Path $BackupDir) {
        Remove-Item -Path $BackupDir -Recurse -Force
    }
    git clone $GitHubRepo $BackupDir 2>&1
    Write-Host "✅ 仓库克隆完成" -ForegroundColor Green
}

Set-Location $BackupDir

Write-Host ""

# 复制配置文件
Write-Host "📋 复制配置文件到工作区..." -ForegroundColor Yellow
$ConfigFiles = @(
    "SOUL.md",
    "USER.md",
    "IDENTITY.md",
    "TOOLS.md",
    "AGENTS.md",
    "HEARTBEAT.md"
)

foreach ($file in $ConfigFiles) {
    if (Test-Path "$BackupDir\$file") {
        Copy-Item "$BackupDir\$file" "$WorkspaceDir\$file" -Force
        Write-Host "✅ 已复制：$file" -ForegroundColor Green
    }
}

# 复制 memory 目录
if (Test-Path "$BackupDir\memory") {
    if (Test-Path "$WorkspaceDir\memory") {
        Remove-Item -Path "$WorkspaceDir\memory" -Recurse -Force
    }
    Copy-Item "$BackupDir\memory" "$WorkspaceDir\memory" -Recurse -Force
    Write-Host "✅ 已复制：memory/" -ForegroundColor Green
}

Write-Host ""

# 配置 Git（如果需要推送备份）
Write-Host "⚙️  配置 Git..." -ForegroundColor Yellow
git config --global user.name "Liuyz279" 2>&1 | Out-Null
Write-Host "✅ Git 用户名已配置" -ForegroundColor Green

Write-Host ""
Write-Host "⚠️  接下来需要手动配置认证信息" -ForegroundColor Yellow
Write-Host "=================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "请运行以下命令配置模型认证：" -ForegroundColor Cyan
Write-Host "  openclaw models auth login --provider qwen-portal" -ForegroundColor White
Write-Host ""
Write-Host "如果需要其他服务，继续配置：" -ForegroundColor Cyan
Write-Host "  openclaw agents add <agent-id>" -ForegroundColor White
Write-Host ""

# 启动 Gateway
Write-Host "🚀 启动 OpenClaw Gateway..." -ForegroundColor Yellow
try {
    openclaw gateway start 2>&1
    Write-Host "✅ Gateway 已启动" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Gateway 启动失败，请先配置认证后再启动" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎉 部署完成！" -ForegroundColor Green
Write-Host "=================" -ForegroundColor Green
Write-Host ""
Write-Host "📝 下一步：" -ForegroundColor Cyan
Write-Host "1. 配置模型认证：openclaw models auth login --provider qwen-portal" -ForegroundColor White
Write-Host "2. 检查状态：openclaw status" -ForegroundColor White
Write-Host "3. 开始使用！" -ForegroundColor White
Write-Host ""
Write-Host "🦆 鸭子已准备好为你服务！" -ForegroundColor Cyan
