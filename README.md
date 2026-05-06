# Cảnh Báo Phạt Nguội Tự Động (GitHub Actions)

Công cụ tự động kiểm tra phạt nguội phương tiện giao thông tại Việt Nam và gửi thông báo trực tiếp qua Telegram. Dự án được tối ưu hóa để chạy hoàn toàn miễn phí trên GitHub Actions.

## 🚀 Tính năng chính
- 🛡️ **Tự động hóa**: Chạy định kỳ hàng ngày vào 09:00 sáng (giờ VN).
- 📱 **Thông báo Telegram**: Gửi chi tiết biển số, lỗi vi phạm và trạng thái xử lý.
- 🛠️ **Dễ cấu hình**: Quản lý danh sách xe qua GitHub Secrets, không lộ thông tin cá nhân.
- 🔍 **Độ chính xác cao**: Sử dụng Tesseract OCR để giải quyết Captcha từ nguồn dữ liệu gốc.

## ⚙️ Hướng dẫn thiết lập (GitHub Actions)

Để hệ thống hoạt động, bạn cần cấu hình các **Secrets** trong Repository:
Vào **Settings** → **Secrets and variables** → **Actions** → **New repository secret**.

### 1. Thông tin Telegram
- `TELEGRAM_BOT_TOKEN`: Token của Bot (lấy từ @BotFather).
- `TELEGRAM_CHAT_ID`: ID của người nhận hoặc nhóm nhận tin nhắn.

### 2. Cấu hình danh sách xe
- `CONFIG_JSON`: Nội dung cấu hình danh sách xe cần kiểm tra.
  
**Định dạng chuẩn của `CONFIG_JSON`:**
```json
{
    "plates_infos": [
        {
            "plate": "81A26559",
            "type": "car"
        }
    ]
}
```
*Lưu ý về trường `type`:*
- Ô tô: dùng `"car"` hoặc `"Ô tô"`
- Xe máy: dùng `"motorbike"` hoặc `"Xe máy"`
- Xe máy điện: dùng `"electric_motorbike"` hoặc `"Xe máy điện"`

## 💻 Chạy thử tại máy cá nhân (Local)

### Yêu cầu
1. **Tesseract OCR**: 
   - macOS: `brew install tesseract`
   - Linux: `sudo apt install tesseract-ocr`
2. **uv**: [Trình quản lý package Python](https://astral.sh/uv).

### Các bước thực hiện
```bash
# 1. Cài đặt môi trường
uv sync

# 2. Tạo file config.json (giống định dạng bên trên)
# 3. Chạy kiểm tra
uv run cpn-cli

# 4. Chạy thử gửi Telegram (Yêu cầu đã sửa Token/ChatID trong script)
./test_telegram.sh
```

## ⏰ Lịch trình chạy (Schedule)
Mặc định, workflow được thiết lập chạy vào **09:00 sáng hàng ngày** (giờ Việt Nam).
Để thay đổi, bạn có thể chỉnh sửa giá trị `cron` trong file `.github/workflows/schedule-run.yml`:
- `cron: '0 2 * * *'` (02:00 UTC = 09:00 VN).

## 📜 Giấy phép
Dự án được phát hành dưới giấy phép MIT. Xem file `LICENSE` để biết thêm chi tiết.
