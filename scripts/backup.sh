#!/bin/bash
# 鸭子核心配置自动备份脚本

set -e

WORKSPACE="/home/lyz/.openclaw/workspace"
BACKUP_DIR="$WORKSPACE/home"
MEMORY_DIR="$WORKSPACE/memory"

echo "🦆 开始备份鸭子配置... $(date)"

# 启动 ssh-agent 并添加密钥
eval $(ssh-agent -s)
ssh-add ~/.ssh/github_ed25519 2>/dev/null || true

cd "$BACKUP_DIR"

# 拉取最新代码（避免冲突）
git pull --rebase origin main 2>/dev/null || true

# 复制核心文件（如果存在）
FILES_TO_BACKUP=(
    "SOUL.md"
    "USER.md"
    "IDENTITY.md"
    "TOOLS.md"
    "AGENTS.md"
    "HEARTBEAT.md"
)

for file in "${FILES_TO_BACKUP[@]}"; do
    if [ -f "$WORKSPACE/$file" ]; then
        cp "$WORKSPACE/$file" "$BACKUP_DIR/$file"
        echo "✅ 备份：$file"
    fi
done

# 备份 memory 目录
if [ -d "$MEMORY_DIR" ]; then
    mkdir -p "$BACKUP_DIR/memory"
    cp -r "$MEMORY_DIR"/* "$BACKUP_DIR/memory/" 2>/dev/null || true
    echo "✅ 备份：memory/"
fi

# 提交并推送
git add -A
if git diff --cached --quiet; then
    echo "📝 无变更，跳过提交"
else
    git commit -m "自动备份：$(date +%Y-%m-%d %H:%M)"
    git push origin main
    echo "✅ 推送成功"
fi

# 停止 ssh-agent
ssh-agent -k > /dev/null

echo "🦆 备份完成！$(date)"
