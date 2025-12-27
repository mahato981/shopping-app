# 🚀 Quick GitHub Setup Guide

## Step-by-Step Instructions to Build APK on GitHub

### 📋 Prerequisites
- GitHub account
- Git installed
- Flutter installed (for local testing)

---

## 🎯 5-Minute Setup

### Step 1: Create GitHub Repository

1. Go to [GitHub](https://github.com/new)
2. Create new repository:
   - **Name**: `shopping-app`
   - **Visibility**: Public or Private
   - **Do NOT** add README, .gitignore, or license (we have them)
3. Copy the repository URL

### Step 2: Initialize Git and Push

```bash
# Navigate to shopping_app folder
cd shopping_app

# Check if git is initialized
git status

# If not initialized, run:
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Shopping App ready for APK build"

# Add your GitHub remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/shopping-app.git

# Push to GitHub
git push -u origin main
```

**If you get an error about main/master branch:**
```bash
# Rename branch to main
git branch -M main

# Then push
git push -u origin main
```

### Step 3: Watch the Build

1. Go to your GitHub repository
2. Click **Actions** tab
3. See the build running automatically! ⚙️
4. Wait 5-10 minutes for completion

### Step 4: Download Your APK

1. Click on the completed workflow
2. Scroll to **Artifacts** section
3. Download:
   - `shopping-app-debug-1.0.0+1.zip` (for testing)
   - `shopping-app-release-1.0.0+1.zip` (for distribution)
4. Unzip and install the APK on your Android device

---

## 🔐 Optional: Add Release Signing (Recommended for Production)

### Create Keystore (One-time setup)

```bash
cd shopping_app/android

# Create keystore folder
mkdir -p keystore

# Generate keystore
keytool -genkey -v -keystore keystore/shopping_app.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias shopping_app_key
```

**Fill in the information:**
- Keystore password: (create a strong password)
- Key password: (can be same as keystore password)
- First and last name: Your name or company
- Organizational unit: Development
- Organization: Your company name
- City, State, Country: Your location

### Create key.properties

```bash
# Create the file
nano key.properties
```

Add this content (replace with your actual passwords):

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=shopping_app_key
storeFile=keystore/shopping_app.jks
```

**Save and close** (Ctrl+O, Enter, Ctrl+X for nano)

⚠️ **Important**: Keep this file safe! Don't share it or commit it to Git.

---

## 📦 What Gets Built Automatically

Every time you push code to GitHub:

✅ **Debug APK** - For testing with debug info
✅ **Release APK** - Optimized for production
✅ **App Bundle (.aab)** - For Google Play Store

---

## 🏷️ Creating Releases

To create a versioned release:

```bash
# Update version in pubspec.yaml first
# version: 1.0.1+2

# Commit changes
git add pubspec.yaml
git commit -m "Bump version to 1.0.1"
git push

# Create and push tag
git tag v1.0.1
git push origin v1.0.1
```

GitHub will automatically create a release with APK attached!

---

## 🔄 Making Updates

After making changes to your app:

```bash
# Add changed files
git add .

# Commit with descriptive message
git commit -m "Add shopping cart feature"

# Push to GitHub
git push

# GitHub Actions will automatically build new APKs!
```

---

## 📱 Installing APK on Your Phone

### Method 1: Direct Download
1. Open GitHub on your phone
2. Go to Actions → Artifacts
3. Download APK
4. Open downloaded file
5. Enable "Install from Unknown Sources" if prompted
6. Install

### Method 2: Using ADB (from computer)
```bash
# Connect phone via USB
adb devices

# Install APK
adb install shopping-app-release.apk
```

---

## ✅ Verification Checklist

Before pushing to GitHub, make sure:

- [ ] `.gitignore` includes keystore files
- [ ] `key.properties` is NOT in git (run: `git status`)
- [ ] GitHub Actions workflow exists (`.github/workflows/build-apk.yml`)
- [ ] App version is correct in `pubspec.yaml`
- [ ] App name and package name are correct
- [ ] Internet permission is in AndroidManifest.xml

---

## 🆘 Common Issues

### Issue: "remote: Repository not found"

**Solution:** Check repository URL
```bash
git remote -v
git remote set-url origin https://github.com/YOUR_USERNAME/shopping-app.git
```

### Issue: "Permission denied (publickey)"

**Solution:** Use HTTPS instead of SSH or setup SSH keys
```bash
git remote set-url origin https://github.com/YOUR_USERNAME/shopping-app.git
```

### Issue: Build fails on GitHub

**Solution:** Check Actions logs
1. Go to Actions tab
2. Click failed workflow
3. Click on failed step
4. Read error message

### Issue: Can't install APK on phone

**Solution:** 
1. Enable "Unknown Sources" in Android settings
2. Make sure APK is for correct architecture
3. Uninstall old version first if exists

---

## 📞 Support

Need help? Check:
- `BUILD_APK_GUIDE.md` - Detailed build guide
- GitHub Actions logs - For build errors
- [Flutter Documentation](https://flutter.dev/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

## 🎉 You're Ready!

Your shopping app is now configured for automatic APK building on GitHub!

**Just push your code and GitHub will build the APKs for you!** 🚀
