# 🛍️ Shopping App

A modern Flutter e-commerce application with SQLite database and API integration.

## ✨ Features

- 📱 **Cross-Platform**: Works on Android, iOS, Web, Linux, Windows, macOS
- 🗄️ **Smart Storage**: SQLite on mobile/desktop, localStorage on web
- 🌐 **API Integration**: Fetches products from FakeStore API
- 🖼️ **Image Caching**: Fast loading with cached network images
- 🔍 **Search & Filter**: Search products and filter by categories
- 📊 **Grid/List View**: Toggle between grid and list layouts
- 🎨 **Material Design 3**: Modern, beautiful UI
- ⚡ **Optimized**: ProGuard enabled, code shrinking

## 📱 Android Support

- **Minimum**: Android 5.0 (API 21) - Released 2014
- **Target**: Android 14 (API 34) - Latest
- **Coverage**: 99%+ of active Android devices

## 🏗️ Building APK on GitHub

This app is configured to **automatically build APKs using GitHub Actions**!

### Quick Start

1. **Push to GitHub**:
   ```bash
   git add .
   git commit -m "Initial commit"
   git push
   ```

2. **Download APK**:
   - Go to **Actions** tab
   - Click on completed workflow
   - Download APK from **Artifacts**

### 📚 Documentation

- **[GITHUB_SETUP.md](GITHUB_SETUP.md)** - 5-minute setup guide
- **[BUILD_APK_GUIDE.md](BUILD_APK_GUIDE.md)** - Complete build guide
- **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)** - Pre-deployment checklist

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.24.5+
- Dart 3.5.4+
- Android Studio / VS Code
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/shopping-app.git
cd shopping-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build Commands

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

## 📦 Dependencies

- **sqflite** - SQLite database (mobile/desktop)
- **shared_preferences** - Local storage (web)
- **http** - API requests
- **cached_network_image** - Image caching
- **provider** - State management

## 🏗️ Architecture

```
lib/
├── main.dart                           # App entry point
├── models/
│   └── product.dart                    # Product model
├── database/
│   ├── database_helper.dart            # SQLite helper
│   └── web_storage_helper.dart         # Web storage helper
├── services/
│   ├── storage_service.dart            # Unified storage service
│   └── api_service.dart                # API service
├── screens/
│   ├── home_screen.dart                # Product list screen
│   └── product_detail_screen.dart      # Product detail screen
└── widgets/
    └── product_card.dart               # Reusable product card
```

## 🌐 API

Uses [FakeStore API](https://fakestoreapi.com) for product data:
- 20 products
- 4 categories
- Product images, prices, ratings

## 🎨 Features in Detail

### Home Screen
- Product grid/list view
- Search functionality
- Category filtering
- Pull to refresh
- Offline support with caching

### Product Detail Screen
- Full product information
- High-quality images
- Pricing with discounts
- Ratings and reviews

### Storage
- **Mobile/Desktop**: SQLite database
- **Web**: Browser localStorage
- Automatic platform detection
- Unified API for all platforms

## 🔧 Configuration

### Android
- **Package**: com.shoppingapp.shopping_app
- **minSdk**: 21 (Android 5.0+)
- **targetSdk**: 34 (Android 14)
- **Permissions**: INTERNET

### Release Signing

See [BUILD_APK_GUIDE.md](BUILD_APK_GUIDE.md) for keystore setup.

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/widget_test.dart
```

## 📄 License

This project is open source and available for personal use.

## 🤝 Contributing

Contributions welcome! Please feel free to submit a Pull Request.

## 📞 Support

For issues and questions:
- Check documentation files
- GitHub Issues
- [Flutter Documentation](https://flutter.dev/docs)

## 🎉 Ready to Deploy!

Your app is ready for GitHub! Just push and the APKs will build automatically.

**Next Steps:**
1. Follow [GITHUB_SETUP.md](GITHUB_SETUP.md)
2. Push to GitHub
3. Download APK from Actions
4. Install and test!
