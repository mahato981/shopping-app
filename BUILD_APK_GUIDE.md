# 🏗️ Building APK on GitHub - Complete Guide

This guide will help you automatically build Android APK files using GitHub Actions.

## 📋 Table of Contents
1. [Quick Start](#quick-start)
2. [Creating a Release Keystore](#creating-a-release-keystore)
3. [Setting Up GitHub Repository](#setting-up-github-repository)
4. [GitHub Actions Workflow](#github-actions-workflow)
5. [Building APK](#building-apk)
6. [Troubleshooting](#troubleshooting)

---

## 🚀 Quick Start

### Prerequisites
- GitHub account
- Git installed on your computer
- Flutter SDK (for local testing)

### Step 1: Push to GitHub

```bash
# Initialize git repository (if not already done)
cd shopping_app
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Shopping App ready for APK build"

# Add remote repository (replace with your GitHub repo URL)
git remote add origin https://github.com/YOUR_USERNAME/shopping-app.git

# Push to GitHub
git push -u origin main
```

### Step 2: Automatic Build

Once pushed, GitHub Actions will automatically:
- ✅ Build debug APK
- ✅ Build release APK
- ✅ Build App Bundle (.aab for Play Store)
- ✅ Upload artifacts for download

---

## 🔐 Creating a Release Keystore

### Option A: Using Keytool (Recommended)

**1. Generate keystore:**

```bash
# Navigate to android folder
cd android

# Create keystore directory
mkdir -p keystore

# Generate keystore
keytool -genkey -v -keystore keystore/shopping_app.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias shopping_app_key
```

**2. You'll be asked for:**
- Keystore password (remember this!)
- Key password (remember this!)
- Your name and organization details

**3. Save your credentials safely!**

Create `android/key.properties` file:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=shopping_app_key
storeFile=keystore/shopping_app.jks
```

⚠️ **IMPORTANT**: Never commit `key.properties` or `.jks` files to Git!

### Option B: Using Android Studio

1. Open project in Android Studio
2. Go to **Build** → **Generate Signed Bundle/APK**
3. Select **APK**
4. Click **Create new...**
5. Fill in the details
6. Save the keystore file in `android/keystore/`

---

## 📦 Setting Up GitHub Repository

### 1. Create New Repository

Go to GitHub and create a new repository:
- Name: `shopping-app` (or your preferred name)
- Public or Private
- Do NOT initialize with README (we already have one)

### 2. Repository Structure

```
shopping_app/
├── .github/
│   └── workflows/
│       └── build-apk.yml          ← GitHub Actions workflow
├── android/
│   ├── key.properties.example      ← Template for keystore config
│   └── app/
│       ├── build.gradle            ← Updated with signing config
│       └── proguard-rules.pro      ← ProGuard rules
├── lib/
├── pubspec.yaml
├── .gitignore                      ← Protects sensitive files
└── BUILD_APK_GUIDE.md             ← This file
```

### 3. Protected Files

These files are **automatically excluded** from Git (in `.gitignore`):

```
*.jks                # Keystore files
*.keystore
key.properties       # Keystore credentials
android/key.properties
```

---

## ⚙️ GitHub Actions Workflow

The workflow (`.github/workflows/build-apk.yml`) automatically runs on:

✅ **Push to main/master branch**
✅ **Pull requests**
✅ **Manual trigger** (from GitHub Actions tab)
✅ **Git tags** (for releases)

### What it does:

1. ✅ Sets up Java 17
2. ✅ Sets up Flutter 3.24.5
3. ✅ Installs dependencies
4. ✅ Analyzes code
5. ✅ Runs tests
6. ✅ Builds debug APK
7. ✅ Builds release APK
8. ✅ Builds App Bundle
9. ✅ Uploads artifacts
10. ✅ Creates GitHub release (for tags)

---

## 🔨 Building APK

### Method 1: Automatic Build (GitHub Actions)

**Just push your code!**

```bash
git add .
git commit -m "Update app"
git push
```

Then:
1. Go to your GitHub repository
2. Click **Actions** tab
3. Wait for build to complete (5-10 minutes)
4. Download APK from **Artifacts** section

### Method 2: Manual Trigger

1. Go to **Actions** tab on GitHub
2. Click **Build Android APK** workflow
3. Click **Run workflow** button
4. Select branch
5. Click **Run workflow**

### Method 3: Local Build

```bash
# Debug APK (larger, with debugging info)
flutter build apk --debug

# Release APK (smaller, optimized)
flutter build apk --release

# Split APKs by architecture (smaller files)
flutter build apk --split-per-abi --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

APK locations:
- Debug: `build/app/outputs/flutter-apk/app-debug.apk`
- Release: `build/app/outputs/flutter-apk/app-release.apk`
- Bundle: `build/app/outputs/bundle/release/app-release.aab`

---

## 📥 Downloading Built APKs

### From GitHub Actions:

1. Go to **Actions** tab
2. Click on a completed workflow run
3. Scroll to **Artifacts** section
4. Download:
   - `shopping-app-debug-1.0.0+1` (Debug APK)
   - `shopping-app-release-1.0.0+1` (Release APK)
   - `shopping-app-bundle-1.0.0+1` (App Bundle)

### From GitHub Releases (for tagged versions):

1. Go to **Releases** tab
2. Download attached APK/AAB files

---

## 🏷️ Creating Releases

To create a GitHub release with APK:

```bash
# Create and push a tag
git tag v1.0.0
git push origin v1.0.0
```

GitHub Actions will automatically:
- Build the APK
- Create a GitHub Release
- Attach APK and App Bundle files

---

## 🐛 Troubleshooting

### Build Fails - Missing Dependencies

**Error:** `Could not resolve all dependencies`

**Solution:**
```bash
flutter clean
flutter pub get
flutter build apk
```

### Build Fails - Keystore Issues

**Error:** `Keystore file not found`

**Solution:**
1. Remove keystore signing (builds with debug key)
2. Edit `android/app/build.gradle`
3. Ensure `keystorePropertiesFile.exists()` check is working

### APK Size Too Large

**Solutions:**
1. Build split APKs:
   ```bash
   flutter build apk --split-per-abi
   ```

2. Enable ProGuard (already configured)

3. Remove unused resources

### App Crashes on Some Devices

**Solutions:**
1. Check ProGuard rules in `android/app/proguard-rules.pro`
2. Test on multiple Android versions
3. Check logs: `adb logcat`

### GitHub Actions Timeout

**Solutions:**
1. Increase timeout in workflow file
2. Enable caching (already enabled)
3. Use smaller dependencies

---

## 📊 Build Variants

### Debug APK
- **Size:** Larger (~50-100 MB)
- **Performance:** Slower
- **Use for:** Testing, development
- **Debugging:** Full debugging info included

### Release APK
- **Size:** Smaller (~20-50 MB)
- **Performance:** Optimized
- **Use for:** Production, distribution
- **Debugging:** Minimal info, obfuscated

### App Bundle (.aab)
- **Size:** Varies per device
- **Performance:** Best
- **Use for:** Google Play Store only
- **Features:** Dynamic delivery, smaller downloads

---

## 🎯 Best Practices

1. ✅ **Never commit keystore files** - Use `.gitignore`
2. ✅ **Keep keystore credentials safe** - Use password manager
3. ✅ **Test before release** - Install debug APK first
4. ✅ **Version properly** - Update `pubspec.yaml` version
5. ✅ **Use semantic versioning** - e.g., 1.0.0, 1.1.0, 2.0.0
6. ✅ **Sign release APKs** - Use proper keystore
7. ✅ **Test on multiple devices** - Different Android versions
8. ✅ **Check APK size** - Keep under 100 MB if possible
9. ✅ **Enable ProGuard** - Reduce size, protect code
10. ✅ **Create GitHub releases** - For version tracking

---

## 📱 Installing APK

### On Android Device:

1. Enable **Unknown Sources** in settings
2. Download APK from GitHub
3. Open APK file
4. Click **Install**

### Using ADB:

```bash
# Install debug APK
adb install build/app/outputs/flutter-apk/app-debug.apk

# Install release APK
adb install build/app/outputs/flutter-apk/app-release.apk

# Reinstall (keep data)
adb install -r app-release.apk
```

---

## 🎉 Summary

**You're all set!** Your app will automatically build APKs on every push to GitHub.

**Quick Commands:**
```bash
# Push and build
git add .
git commit -m "Your message"
git push

# Create release
git tag v1.0.0
git push origin v1.0.0

# Build locally
flutter build apk --release
```

**Download APKs from:**
- GitHub Actions → Artifacts
- GitHub Releases → Assets

---

## 🆘 Need Help?

- Check [Flutter documentation](https://flutter.dev/docs)
- Check [GitHub Actions docs](https://docs.github.com/en/actions)
- Check build logs in GitHub Actions
- Search for error messages online

**Happy Building! 🚀**
