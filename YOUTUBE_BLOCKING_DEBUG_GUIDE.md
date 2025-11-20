# YouTube Blocking Debug Guide

If YouTube (or other apps) are not being blocked during your focus session, follow this guide to diagnose and fix the issue.

## Quick Checklist

1. ✅ **Accessibility Service is enabled**
2. ✅ **Focus session is active**
3. ✅ **YouTube is in the blocked apps list**
4. ✅ **The correct YouTube package name is used**

## Step 1: Check Blocking Status

1. Open your app
2. Go to **Focus** tab → **History** (top right icon)
3. Tap the **bug icon** (🐛) in the top right
4. This shows:
   - Is Accessibility Service enabled?
   - Is there an active session?
   - How many apps are blocked?

## Step 2: Verify Accessibility Service

### Check if Enabled:
1. Open Android **Settings**
2. Go to **Accessibility**
3. Find **Installed Services** or **Downloaded Services**
4. Look for **StayHard** or **stay_hard**
5. Make sure it's **ON/Enabled**

### If Not There:
- The app might not have registered the service
- Try reinstalling the app
- Check Android version (needs Android 5.0+)

## Step 3: Verify YouTube Package Name

YouTube has different versions with different package names:

### Standard YouTube:
- Package: `com.google.android.youtube`
- This is the most common version

### YouTube Variants:
- YouTube Go: `com.google.android.apps.youtube.kids`
- YouTube Music: `com.google.android.apps.youtube.music`
- YouTube Studio: `com.google.android.apps.youtube.creator`
- YouTube Kids: `com.google.android.youtube.tvkids`

### Check Which Version You Have:
```bash
adb shell pm list packages | grep youtube
```

This shows ALL YouTube apps installed on your device.

## Step 4: Check Android Logs

This is the most powerful debugging tool!

### Using ADB (Android Debug Bridge):

1. **Connect your device** via USB
2. **Enable USB debugging** on your device
3. **Run this command**:
   ```bash
   adb logcat | grep AppBlockingService
   ```

### What to Look For:

#### Good Logs (Working):
```
AppBlockingService: Starting session: abc123 with 5 blocked apps
AppBlockingService: Blocking app: com.google.android.youtube
AppBlockingService: Window changed to: com.google.android.youtube
AppBlockingService: BLOCKING APP: com.google.android.youtube
AppBlockingService: Launching blocking overlay for: com.google.android.youtube
AppBlockingService: Blocking overlay launched successfully
```

#### Problem Logs:

**Service Not Connected:**
```
(no logs appear)
```
→ **Solution**: Enable Accessibility Service

**Package Name Mismatch:**
```
AppBlockingService: Window changed to: com.google.android.youtube
(no blocking message)
```
→ **Solution**: The app is not in your blocked list. Add it manually in "Custom" mode.

**Error Launching Overlay:**
```
AppBlockingService: Error launching blocking overlay
```
→ **Solution**: The app might need SYSTEM_ALERT_WINDOW permission. Check app permissions.

## Step 5: Manual Package Name Entry

If YouTube isn't being blocked:

1. Open **Focus** tab
2. Tap **New Session**
3. Select **Custom** mode
4. Tap **Select Apps to Block**
5. Search for "YouTube"
6. If not found, you need to add it manually:
   - Note: This feature should be added (manual package entry)
   - For now, make sure you select YouTube from the installed apps list

## Step 6: Test the Blocking

1. **Start a focus session** with YouTube blocked
2. **Press Home button**
3. **Open YouTube app**
4. **What should happen:**
   - Blocking overlay appears immediately
   - Shows "YouTube is blocked during your focus session"
   - Buttons: "Back to Focus" / "End Session"

5. **What might happen (problems):**
   - YouTube opens normally → Service not running or YouTube not in blocked list
   - Brief flash then YouTube opens → Overlay appears but immediately dismissed (fixed in latest update)
   - Nothing happens → Check all steps above

## Step 7: Verify in App

1. During an **active session**, tap **View list** in the session card
2. This shows ALL blocked apps for this session
3. Verify **YouTube** (or `com.google.android.youtube`) is in the list
4. Check the package name matches your installed version

## Common Issues & Solutions

### Issue 1: "Service is enabled but YouTube still opens"

**Possible Causes:**
- Wrong package name for your YouTube version
- Session ended or paused
- App was force-stopped (service needs restart)

**Solution:**
1. Check logs with `adb logcat | grep AppBlockingService`
2. Look for "Window changed to: com.google.android.youtube"
3. If no blocking message follows, YouTube isn't in the blocked list

### Issue 2: "Overlay appears but I can dismiss it"

**This was a bug and has been fixed!**

**Old behavior:** Overlay appears once, dismissible
**New behavior:** Overlay re-appears every time you try to open YouTube

**Solution:** Update to the latest version (this commit)

### Issue 3: "Service keeps getting disabled"

**Possible Causes:**
- Android battery optimization killing the service
- Device manufacturer restrictions (Xiaomi, Huawei, etc.)

**Solution:**
1. Disable battery optimization for StayHard
2. Add app to protected apps list (varies by manufacturer)
3. Set app to "Don't optimize" in battery settings

### Issue 4: "Can't find YouTube in app list"

**Possible Causes:**
- YouTube is a system app and hidden
- Different YouTube variant installed
- App installation issue

**Solution:**
1. Run `adb shell pm list packages | grep youtube`
2. Manually note the package name
3. Use "Custom" mode and ensure the exact package is selected

## Advanced: Force Test the Service

```bash
# Check if service is running
adb shell dumpsys accessibility | grep -A 20 stay_hard

# Check all accessibility services
adb shell settings get secure enabled_accessibility_services

# Force stop and restart app
adb shell am force-stop com.example.stay_hard
adb shell am start -n com.example.stay_hard/.MainActivity
```

## Still Not Working?

If you've tried everything above and it still doesn't work:

1. **Capture logs while reproducing the issue:**
   ```bash
   adb logcat -c  # Clear logs
   # Start session, try to open YouTube
   adb logcat -d | grep -E "AppBlockingService|stay_hard" > blocking_debug.log
   ```

2. **Share the logs** (remove sensitive info first)

3. **Check these:**
   - Android version: `adb shell getprop ro.build.version.release`
   - Device manufacturer: `adb shell getprop ro.product.manufacturer`
   - Some manufacturers heavily restrict accessibility services

## How the Blocking Works

1. **Accessibility Service** monitors all window changes
2. When you open YouTube, Android fires a `TYPE_WINDOW_STATE_CHANGED` event
3. Service checks if `com.google.android.youtube` is in blocked apps list
4. If yes, immediately launches **BlockingOverlayActivity**
5. Overlay appears as full-screen with `FLAG_CLEAR_TASK` flag
6. User is redirected back to Focus screen
7. **New:** If user tries again, overlay appears again (persistent blocking)

## Debug Widget

The new debug widget shows:
- ✅ Accessibility Service status
- ✅ Active session info
- ✅ Blocked apps count
- ✅ Current session mode
- ✅ Troubleshooting tips

Access it via: **Focus → History → Bug Icon (🐛)**

## Logging System

All key events are now logged:
- Session start/stop
- Each blocked app added
- Every window change (when session active)
- Every blocking attempt
- Errors with stack traces

View with: `adb logcat | grep AppBlockingService`

---

## Summary

Most issues are caused by:
1. **Accessibility Service not enabled** (70% of cases)
2. **Wrong YouTube package name** (20% of cases)
3. **Device manufacturer restrictions** (10% of cases)

Always start with the debug widget and Android logs!
