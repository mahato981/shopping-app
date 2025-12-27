# GitHub Actions Workflows

This folder contains automated workflows for building Android APKs.

## Available Workflows

### `build-apk.yml` - Build Android APK

Automatically builds Android APK and App Bundle on every push.

**Triggers:**
- Push to main/master branch
- Pull requests
- Manual trigger (Actions tab)
- Git tags (creates releases)

**Outputs:**
- Debug APK
- Release APK
- App Bundle (.aab)

**Artifacts Retention:**
- Debug APK: 30 days
- Release APK: 90 days
- App Bundle: 90 days

## Manual Trigger

1. Go to **Actions** tab
2. Select **Build Android APK**
3. Click **Run workflow**
4. Choose branch
5. Click **Run workflow** button

## Download Built APKs

1. Go to **Actions** tab
2. Click on completed workflow run
3. Scroll to **Artifacts** section
4. Download APK files

## Workflow Status

Check the status badge in your README.md to see if builds are passing!
