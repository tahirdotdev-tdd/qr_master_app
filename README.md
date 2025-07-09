# 📱 QR Master App 🔍

QR Master is a powerful, fast, and modern Flutter-based mobile app that allows you to **scan**, **copy**, **open**, and **manage** QR codes with ease. Whether you're scanning codes from products, websites, or your gallery — QR Master does it all in one smooth experience. 🎯

---

## 🚀 Features

✅ **Real-Time QR Scanner**  
Scan QR codes instantly using your device's camera — super fast and reliable!

📋 **Copy to Clipboard**  
One-tap copy of scanned results to your clipboard — no hassle!

🌐 **Open Links in Browser**  
If your QR contains a URL, open it directly in your default browser.

🖼️ **Scan from Gallery**  
Import images from your gallery and scan QR codes embedded in them.

🕓 **Scan History**  
Keep track of all scanned QR codes with timestamps and details.

🗑️ **Delete History Items**  
Easily remove individual or all history entries whenever you want.

🌙 **Dark Mode Friendly**  
Smooth UI that supports both light and dark themes for a modern look.

---

## 📷 Screenshots (Optional)

> *Add your screenshots here using Markdown:*
>
> ```md
> ![Home Screen](screenshots/home.png)
> ![Scanner](screenshots/scanner.png)
> ```

---

## 🛠️ Tech Stack

- 💙 **Flutter** (Clean and responsive UI)
- 📦 `mobile_scanner` package for camera-based scanning
- 🧠 `provider` for state management
- 🔧 `shared_preferences` for local history storage

---

## 📂 Folder Structure

```plaintext
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── qr_scanner_screen.dart
│   ├── history_screen.dart
├── widgets/
│   └── custom_buttons.dart
├── models/
│   └── scan_result.dart
├── provider/
│   └── scan_history_provider.dart
```

---

## 🧑‍💻 How to Run

```bash
flutter pub get
flutter run
```

Make sure you have a device or emulator connected.

---

## 🔐 Permissions

The app uses the following permissions:

- `CAMERA` – To scan QR codes using your phone’s camera
- `STORAGE` – To pick images from the gallery (optional)

---

## 📦 Packages Used

| Package            | Description                        |
|--------------------|------------------------------------|
| `mobile_scanner`   | QR code scanning from camera       |
| `permission_handler` | To request runtime permissions    |
| `shared_preferences` | For saving scan history locally  |
| `url_launcher`     | To open URLs in browser            |

---

## 📝 License

MIT License © 2025 [Tahir](https://github.com/tahirdotdev-tdd)

---

## 🤝 Connect with Me

- GitHub: [@tahirdotdev-tdd](https://github.com/tahirdotdev-tdd)
- LinkedIn: *(Add your link if you want)*
- Telegram: *(Optional)*
```

---
