# CPN GitHub Actions

Tự động kiểm tra phạt nguội và gửi thông báo Telegram qua GitHub Actions.

## 🚀 Setup

### 1. Setup GitHub Secrets

Vào **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Thêm các secrets sau:

- `TELEGRAM_BOT_TOKEN`: `xxxx:xxx`
- `TELEGRAM_CHAT_ID`: `xxxxx`
- `config` (optional): URL đến file config.json nếu muốn lưu ở nơi khác

### 2. Test Workflow

- Vào tab **Actions**
- Chọn workflow **Schedule Run**
- Click **Run workflow** → **Run workflow**

### 3. Schedule

Workflow tự động chạy:
- 🕐 **Hàng ngày lúc 00:00 giờ Việt Nam** (17:00 UTC)
- 🔘 **Manual trigger**: Bất cứ lúc nào qua Actions tab

## 📱 Thông báo Telegram

Sau mỗi lần check, bạn sẽ nhận được thông báo gồm:
- 📋 Biển số xe
- 👤 Chủ xe
- 🏍️ Loại xe
- ⚠️ Số vi phạm chưa xử phạt
- ⏰ Thời gian check

## 🛠️ Local Testing

```bash
# Test local với Telegram notification
k

# Hoặc
./test_telegram.sh
```

## 📝 Config

File `config.json` chứa thông tin:
- Biển số xe cần check
- Cấu hình Telegram bot
- Các tùy chọn khác

## 🔧 Modify Schedule

Sửa file `.github/workflows/schedule-run.yml`:

```yaml
schedule:
  - cron: '0 17 * * *'  # Every day at 00:00 Vietnam time (UTC+7)
```

Ví dụ cron (UTC time):
- `0 17 * * *` - Hàng ngày lúc 00:00 VN (17:00 UTC)
- `0 23 * * *` - Hàng ngày lúc 06:00 VN (23:00 UTC)
- `0 10 * * *` - Hàng ngày lúc 17:00 VN (10:00 UTC)
- `0 17 * * 0` - Mỗi Chủ nhật lúc 00:00 VN

Sử dụng [crontab.guru](https://crontab.guru/) để tạo cron expression.
