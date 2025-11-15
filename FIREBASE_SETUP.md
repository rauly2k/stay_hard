# Firebase Setup Guide for StayHard App

This guide will help you configure Firebase for the StayHard app.

## Prerequisites

- Flutter SDK installed
- Firebase CLI installed (`npm install -g firebase-tools`)
- Google account

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: **stay-hard-app** (or your preferred name)
4. Disable Google Analytics (optional for now)
5. Click "Create project"

## Step 2: Register Android App

1. In Firebase Console, click the Android icon
2. Enter Android package name: `com.stayhard.app` (or your package name)
3. Enter App nickname: **StayHard Android**
4. Leave SHA-1 empty for now (needed later for Google Sign-In)
5. Click "Register app"
6. Download `google-services.json`
7. Move the file to: `android/app/google-services.json`

## Step 3: Enable Authentication Methods

1. In Firebase Console, go to **Build** → **Authentication**
2. Click "Get started"
3. Enable **Email/Password**:
   - Click on "Email/Password"
   - Toggle "Enable"
   - Click "Save"

4. Enable **Google Sign-In**:
   - Click on "Google"
   - Toggle "Enable"
   - Enter support email
   - Click "Save"

## Step 4: Set up Firestore Database

1. In Firebase Console, go to **Build** → **Firestore Database**
2. Click "Create database"
3. Choose "Start in test mode" (we'll add security rules later)
4. Select your region (choose closest to your users)
5. Click "Enable"

## Step 5: Configure FlutterFire

Run the FlutterFire configuration command:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

This will:
- Detect your Firebase project
- Generate `lib/firebase_options.dart` with real credentials
- Update your Android configuration

**Important:** Replace the placeholder `lib/firebase_options.dart` with the generated one!

## Step 6: Update Android Configuration

### 6.1 Update `android/build.gradle`

Add the Google services classpath:

```gradle
buildscript {
    dependencies {
        // ... other dependencies
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

### 6.2 Update `android/app/build.gradle`

Add the Google services plugin at the bottom of the file:

```gradle
// At the bottom of the file
apply plugin: 'com.google.gms.google-services'
```

## Step 7: Configure Google Sign-In SHA-1

For Google Sign-In to work, you need to add your SHA-1 fingerprint:

### Get Debug SHA-1:

```bash
cd android
./gradlew signingReport
```

Copy the SHA-1 from the debug keystore.

### Add to Firebase:

1. In Firebase Console, go to Project Settings
2. Scroll to "Your apps" section
3. Click on your Android app
4. Click "Add fingerprint"
5. Paste the SHA-1
6. Click "Save"

### Download new `google-services.json`:

After adding SHA-1, download the updated `google-services.json` and replace the old one.

## Step 8: Test the Setup

Run your app:

```bash
flutter pub get
flutter run
```

Test the authentication flows:
1. Create an account with email/password
2. Log out
3. Log in with Google
4. Test password reset

## Security Rules (Production)

Before deploying, update Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /habits/{habitId} {
      allow read, write: if request.auth != null &&
                            resource.data.userId == request.auth.uid;
    }

    match /completions/{completionId} {
      allow read, write: if request.auth != null &&
                            resource.data.userId == request.auth.uid;
    }

    match /goals/{goalId} {
      allow read, write: if request.auth != null &&
                            resource.data.userId == request.auth.uid;
    }
  }
}
```

## Troubleshooting

### Google Sign-In not working:
- Verify SHA-1 is added to Firebase
- Check `google-services.json` is up to date
- Ensure Google Sign-In is enabled in Firebase Console

### Authentication errors:
- Check Firebase Authentication is enabled
- Verify package name matches in `google-services.json`
- Check internet connectivity

### Build errors:
- Run `flutter clean`
- Delete `build` folder
- Run `flutter pub get`
- Try again

## Environment Variables (Optional)

For security, you can move the Gemini API key to environment variables:

Create `.env` file in project root:
```
GEMINI_API_KEY=AIzaSyASsXcwN3NzsTcBsZtM4x5DgFn52rLN6Ms
```

Add to `.gitignore`:
```
.env
```

Use `flutter_dotenv` package to load it.

## Next Steps

After Firebase setup:
1. Test all authentication flows
2. Proceed to Phase 2 implementation
3. Set up Crashlytics for error reporting
4. Configure Performance Monitoring

---

**Note:** The current `firebase_options.dart` contains placeholder values. Run `flutterfire configure` to generate the real configuration with your Firebase project credentials.
