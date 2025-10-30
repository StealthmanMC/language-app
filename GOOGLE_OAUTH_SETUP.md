# Google OAuth Setup Guide for Indian Language Learning App

## 📋 Overview

This document provides step-by-step instructions for setting up Google OAuth with your Flutter app and Supabase backend.

---

## Step 1: Get Your Google OAuth Credentials

### 1.1 Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click the project dropdown at the top
3. Click **NEW PROJECT**
4. Enter project name: `IndianLanguageLearning`
5. Click **CREATE**

### 1.2 Enable Google+ API

1. In the Console, go to **APIs & Services** → **Library**
2. Search for **"Google+ API"**
3. Click on it and click **ENABLE**

### 1.3 Create OAuth Credentials

1. Go to **APIs & Services** → **Credentials**
2. Click **+ CREATE CREDENTIALS** → **OAuth client ID**
3. If you haven't set up the OAuth consent screen yet:
   - Click **Configure Consent Screen**
   - Choose **External** user type
   - Fill in app name: `Indian Language Learning`
   - Add your email
   - Click **SAVE AND CONTINUE** (skip optional fields)
   - Click **SAVE AND CONTINUE** again
   - Click **BACK TO DASHBOARD**

4. Go to **Credentials** again
5. Click **+ CREATE CREDENTIALS** → **OAuth client ID**
6. Choose **Web application**
7. Add Name: `Flutter App`
8. Under **Authorized redirect URIs**, add:
   ```
   http://localhost:3000
   https://YOUR_SUPABASE_PROJECT_ID.supabase.co/auth/v1/callback
   ```
   (Replace `YOUR_SUPABASE_PROJECT_ID` with your actual Supabase project ID)

9. Click **CREATE**
10. A dialog shows your **Client ID** and **Client Secret** - **SAVE THESE!**

---

## Step 2: Configure Supabase

### 2.1 Enable Google Provider

1. Go to your [Supabase Dashboard](https://app.supabase.com)
2. Select your project
3. Go to **Authentication** → **Providers**
4. Find **Google** and click it
5. Toggle **Enabled** to ON
6. Paste your **Client ID** from Google Cloud
7. Paste your **Client Secret** from Google Cloud
8. Click **SAVE**

---

## Step 3: Update Your Flutter App

### 3.1 Update `lib/main.dart`

Find this section:

```dart
await Supabase.initialize(
  url: 'https://your-supabase-url.supabase.co',
  anonKey: 'your-supabase-anon-key',
);
```

Replace it with your actual Supabase credentials:

```dart
await Supabase.initialize(
  url: 'https://YOUR_PROJECT_ID.supabase.co',
  anonKey: 'YOUR_ANON_KEY_HERE',
  redirectUrl: 'com.indianlanguageapp://callback/',
);
```

**Find your credentials:**
- Go to Supabase Dashboard
- Click **Settings** → **API**
- Copy **Project URL** and **anon/public key**

### 3.2 iOS Configuration

Update the `ios/Runner/Info.plist` file. Find this section:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_GOOGLE_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

Replace `YOUR_GOOGLE_CLIENT_ID` with your actual Client ID from Google Cloud Console.

**Example:**
If your Client ID is `123456789-abcdefg.apps.googleusercontent.com`, use:
```xml
<string>com.googleusercontent.apps.123456789-abcdefg</string>
```

### 3.3 Android Configuration

The `android/app/src/main/AndroidManifest.xml` and `android/app/build.gradle` files are already configured. No changes needed!

---

## Step 4: Test Google OAuth

### 4.1 Clean Build

```bash
cd /path/to/language-app
flutter clean
flutter pub get
```

### 4.2 Run on Device/Emulator

```bash
# iOS
flutter run -d iphone

# Android
flutter run -d android
```

### 4.3 Test Sign-In

1. Open the app
2. On the login screen, click **"Sign In with Google"**
3. You should see Google's sign-in popup
4. After signing in, you should be redirected to the language selection screen

### 4.4 Verify in Supabase

1. Go to Supabase Dashboard
2. **Authentication** → **Users**
3. You should see your test user with Google as the provider

---

## 🐛 Troubleshooting

### Issue: "Sign In with Google button does nothing"

**Cause:** Incorrect redirect URL or Client ID

**Fix:**
1. Check your redirect URL in `Info.plist` matches your Client ID format
2. Verify Client ID is in Google Cloud Console
3. Clear app cache: `flutter clean && flutter pub get`

### Issue: "Redirect URI mismatch"

**Cause:** Redirect URL doesn't match what you set in Google Cloud

**Fix:**
1. Go to Google Cloud Console
2. Go to **Credentials** → Click your OAuth client
3. Under **Authorized redirect URIs**, make sure it includes:
   - `https://YOUR_PROJECT_ID.supabase.co/auth/v1/callback`
4. Click **SAVE**

### Issue: iOS build fails

**Cause:** CocoaPods cache issue

**Fix:**
```bash
cd ios
rm -rf Pods Podfile.lock
cd ..
flutter pub get
flutter run -d iphone
```

### Issue: Android build fails

**Cause:** Gradle sync issue

**Fix:**
```bash
flutter clean
flutter pub get
flutter run -d android
```

### Issue: "Developer account not active"

**Cause:** Google Cloud project needs payment setup

**Fix:**
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Go to **Billing**
3. Set up a payment method
4. Wait 5-10 minutes for activation

---

## 📝 Files Modified

✅ Configuration files created/updated:
- `ios/Runner/Info.plist` - iOS OAuth configuration
- `android/app/src/main/AndroidManifest.xml` - Android deep linking
- `android/app/build.gradle` - Google Play Services dependencies
- `lib/main.dart` - Supabase initialization (UPDATE THIS!)

---

## 🔗 Quick Reference

### Required Information

1. **Google OAuth Client ID**: `YOUR_GOOGLE_CLIENT_ID`
   - Find at: Google Cloud Console → Credentials

2. **Google OAuth Client Secret**: `YOUR_CLIENT_SECRET`
   - Find at: Google Cloud Console → Credentials

3. **Supabase Project ID**: `YOUR_PROJECT_ID`
   - Find at: Supabase Dashboard → Settings → API

4. **Supabase Anon Key**: `YOUR_ANON_KEY`
   - Find at: Supabase Dashboard → Settings → API

### Redirect URLs

**iOS:**
```
com.googleusercontent.apps.YOUR_GOOGLE_CLIENT_ID
```

**Android:**
```
com.indianlanguageapp://callback/
```

**Web (Supabase):**
```
https://YOUR_PROJECT_ID.supabase.co/auth/v1/callback
```

---

## ✅ Verification Checklist

Before deploying, verify:

- [ ] Google OAuth Client ID created in Google Cloud Console
- [ ] Google OAuth Client Secret generated
- [ ] Google+ API enabled in Google Cloud
- [ ] OAuth credentials added to Supabase
- [ ] `Info.plist` updated with correct Client ID
- [ ] `lib/main.dart` updated with Supabase credentials
- [ ] App builds successfully on iOS: `flutter run -d iphone`
- [ ] App builds successfully on Android: `flutter run -d android`
- [ ] Google sign-in button works
- [ ] User created in Supabase after signing in with Google

---

## 🚀 Next Steps

After Google OAuth is working:

1. **Test other auth methods**: Email signup/login
2. **Verify all screens load**: Go through the onboarding flow
3. **Test course loading**: Browse Hindi and Telugu courses
4. **Test lesson completion**: Complete a full lesson with exercises
5. **Deploy to TestFlight/Internal Testing** on App Store/Play Store

---

## 📞 Support Resources

- [Supabase Auth Docs](https://supabase.com/docs/guides/auth/social-login/auth-google)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- [Google Cloud Documentation](https://cloud.google.com/docs)
- [OAuth 2.0 Best Practices](https://tools.ietf.org/html/rfc6749)

---

**Last Updated:** October 30, 2025
**Status:** Ready for Configuration
