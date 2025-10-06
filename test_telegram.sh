#!/bin/bash
# Script to test cpn-cli and always send Telegram notification

BOT_TOKEN="8305269584:AAGJbN15m6tOLpmj5MoBQG1fD_pz_Q1hJHk"
CHAT_ID="1034510505"

# Run cpn-cli
echo "🔍 Đang kiểm tra phạt nguội..."
OUTPUT=$(cd /workspaces/cpn-gha && export PATH="$HOME/.local/bin:$PATH" && just run 2>&1)

# Parse output
VIOLATIONS=$(echo "$OUTPUT" | grep "Số vi phạm chưa xử phạt:" | sed 's/.*: //')
PLATE=$(echo "$OUTPUT" | grep "Biển số:" | sed 's/.*: //')

# Send notification
MESSAGE="🚗 *Kiểm tra phạt nguội*%0A%0A"
MESSAGE+="📋 Biển số: \`$PLATE\`%0A"
MESSAGE+="⚠️ Vi phạm chưa xử phạt: *$VIOLATIONS*%0A"
MESSAGE+="%0A✅ Đã kiểm tra xong!"

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id=${CHAT_ID}" \
  -d "text=${MESSAGE}" \
  -d "parse_mode=Markdown" > /dev/null

echo ""
echo "✅ Đã gửi thông báo đến Telegram!"
