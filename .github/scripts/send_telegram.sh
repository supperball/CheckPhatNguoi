#!/bin/bash
# GitHub Actions script to send Telegram notification

BOT_TOKEN="${TELEGRAM_BOT_TOKEN}"
CHAT_ID="${TELEGRAM_CHAT_ID}"

# Check if required env vars are set
if [ -z "$BOT_TOKEN" ] || [ -z "$CHAT_ID" ]; then
    echo "❌ TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID not set"
    exit 1
fi

# Get the output log file
LOG_FILE="${1:-/tmp/cpn_output.log}"

if [ ! -f "$LOG_FILE" ]; then
    echo "❌ Log file not found: $LOG_FILE"
    exit 1
fi

# Parse output for multiple vehicles
mapfile -t PLATES < <(grep "Biển số:" "$LOG_FILE" | sed 's/.*: //')
mapfile -t OWNERS < <(grep "Chủ sở hữu:" "$LOG_FILE" | sed 's/.*: //')
mapfile -t VIOLATIONS < <(grep "Số vi phạm chưa xử phạt:" "$LOG_FILE" | sed 's/.*: //')

# Count total violations
TOTAL_VIOLATIONS=0
for v in "${VIOLATIONS[@]}"; do
    TOTAL_VIOLATIONS=$((TOTAL_VIOLATIONS + v))
done

# Build message
MESSAGE="🤖 *GitHub Actions - Kiểm tra phạt nguội*%0A"
MESSAGE+="⏰ $(TZ=Asia/Ho_Chi_Minh date '+%d/%m/%Y %H:%M:%S')%0A%0A"

# Add info for each vehicle
for i in "${!PLATES[@]}"; do
    MESSAGE+="━━━━━━━━━━━━━━━━%0A"
    MESSAGE+="� *Xe $(($i + 1))*%0A"
    MESSAGE+="�📋 Biển số: \`${PLATES[$i]}\`%0A"
    MESSAGE+="👤 Chủ xe: ${OWNERS[$i]}%0A"
    MESSAGE+="⚠️ Vi phạm: *${VIOLATIONS[$i]}*%0A"
done

MESSAGE+="━━━━━━━━━━━━━━━━%0A"
MESSAGE+="%0A📊 *Tổng kết:* ${#PLATES[@]} xe%0A"

if [ "$TOTAL_VIOLATIONS" = "0" ]; then
    MESSAGE+="✅ Không có vi phạm nào!"
else
    MESSAGE+="🚨 *CÓ VI PHẠM MỚI!*"
fi

# Send to Telegram
RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id=${CHAT_ID}" \
  -d "text=${MESSAGE}" \
  -d "parse_mode=Markdown")

# Check if successful
if echo "$RESPONSE" | grep -q '"ok":true'; then
    echo "✅ Đã gửi thông báo Telegram thành công!"
else
    echo "❌ Gửi thông báo Telegram thất bại!"
    echo "$RESPONSE"
    exit 1
fi
