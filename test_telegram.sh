#!/bin/bash
# Script to test cpn-cli and always send Telegram notification

BOT_TOKEN="8305269584:AAGJbN15m6tOLpmj5MoBQG1fD_pz_Q1hJHk"
CHAT_ID="1034510505"

# Run cpn-cli
echo "🔍 Đang kiểm tra phạt nguội..."
OUTPUT=$(cd /workspaces/cpn-gha && export PATH="$HOME/.local/bin:$PATH" && just run 2>&1)

# Parse output for multiple vehicles
PLATES=($(echo "$OUTPUT" | grep "Biển số:" | sed 's/.*: //'))
OWNERS=($(echo "$OUTPUT" | grep "Chủ sở hữu:" | sed 's/.*: //'))
VIOLATIONS=($(echo "$OUTPUT" | grep "Số vi phạm chưa xử phạt:" | sed 's/.*: //'))

# Count total violations
TOTAL_VIOLATIONS=0
for v in "${VIOLATIONS[@]}"; do
    TOTAL_VIOLATIONS=$((TOTAL_VIOLATIONS + v))
done

# Build message
MESSAGE="🚗 *Kiểm tra phạt nguội (Local)*%0A"
MESSAGE+="⏰ $(date '+%d/%m/%Y %H:%M:%S')%0A%0A"

# Add info for each vehicle
for i in "${!PLATES[@]}"; do
    MESSAGE+="━━━━━━━━━━━━━━━━%0A"
    MESSAGE+="🏍️ *Xe $(($i + 1))*%0A"
    MESSAGE+="📋 Biển số: \`${PLATES[$i]}\`%0A"
    MESSAGE+="👤 Chủ xe: ${OWNERS[$i]}%0A"
    MESSAGE+="⚠️ Vi phạm: *${VIOLATIONS[$i]}*%0A"
done

MESSAGE+="━━━━━━━━━━━━━━━━%0A"
MESSAGE+="%0A📊 *Tổng kết:* ${#PLATES[@]} xe%0A"

if [ "$TOTAL_VIOLATIONS" = "0" ]; then
    MESSAGE+="✅ Không có vi phạm nào!"
else
    MESSAGE+="🚨 *CÓ ${TOTAL_VIOLATIONS} VI PHẠM!*"
fi

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id=${CHAT_ID}" \
  -d "text=${MESSAGE}" \
  -d "parse_mode=Markdown" > /dev/null

echo ""
echo "✅ Đã gửi thông báo đến Telegram!"
