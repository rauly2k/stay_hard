import 'package:flutter/services.dart';
import '../../../../shared/data/models/focus_session_model.dart';

/// Service for managing app blocking functionality via platform channels
class AppBlockingService {
  static const MethodChannel _channel =
      MethodChannel('com.stayhard/app_blocking');

  /// Start a focus session and enable app blocking
  Future<bool> startFocusSession({
    required String sessionId,
    required List<String> blockedApps,
    required bool blockNotifications,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('startFocusSession', {
        'sessionId': sessionId,
        'blockedApps': blockedApps,
        'blockNotifications': blockNotifications,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error starting focus session: ${e.message}');
      return false;
    }
  }

  /// Stop the active focus session and disable app blocking
  Future<bool> stopFocusSession() async {
    try {
      final result = await _channel.invokeMethod<bool>('stopFocusSession');
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error stopping focus session: ${e.message}');
      return false;
    }
  }

  /// Get list of installed apps on the device
  Future<List<InstalledAppInfo>> getInstalledApps() async {
    try {
      final result = await _channel.invokeMethod<List>('getInstalledApps');
      if (result == null) return [];

      return result
          .map((app) => InstalledAppInfo.fromJson(Map<String, dynamic>.from(app)))
          .toList();
    } on PlatformException catch (e) {
      print('Error getting installed apps: ${e.message}');
      return [];
    }
  }

  /// Check if accessibility service is enabled
  Future<bool> isAccessibilityServiceEnabled() async {
    try {
      final result =
          await _channel.invokeMethod<bool>('isAccessibilityServiceEnabled');
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error checking accessibility service: ${e.message}');
      return false;
    }
  }

  /// Open accessibility settings to enable the service
  Future<void> openAccessibilitySettings() async {
    try {
      await _channel.invokeMethod('openAccessibilitySettings');
    } on PlatformException catch (e) {
      print('Error opening accessibility settings: ${e.message}');
    }
  }

  /// Check if the app has usage stats permission
  Future<bool> hasUsageStatsPermission() async {
    try {
      final result =
          await _channel.invokeMethod<bool>('hasUsageStatsPermission');
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error checking usage stats permission: ${e.message}');
      return false;
    }
  }

  /// Request usage stats permission
  Future<void> requestUsageStatsPermission() async {
    try {
      await _channel.invokeMethod('requestUsageStatsPermission');
    } on PlatformException catch (e) {
      print('Error requesting usage stats permission: ${e.message}');
    }
  }

  /// Get app icon as base64 string
  Future<String?> getAppIcon(String packageName) async {
    try {
      final result = await _channel.invokeMethod<String>('getAppIcon', {
        'packageName': packageName,
      });
      return result;
    } on PlatformException catch (e) {
      print('Error getting app icon: ${e.message}');
      return null;
    }
  }

  /// Check if a specific app is currently blocked
  Future<bool> isAppBlocked(String packageName) async {
    try {
      final result = await _channel.invokeMethod<bool>('isAppBlocked', {
        'packageName': packageName,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error checking if app is blocked: ${e.message}');
      return false;
    }
  }

  /// Get the current active session ID from the native side
  Future<String?> getActiveSessionId() async {
    try {
      final result = await _channel.invokeMethod<String>('getActiveSessionId');
      return result;
    } on PlatformException catch (e) {
      print('Error getting active session ID: ${e.message}');
      return null;
    }
  }

  /// Update the list of blocked apps for the current session
  Future<bool> updateBlockedApps(List<String> blockedApps) async {
    try {
      final result = await _channel.invokeMethod<bool>('updateBlockedApps', {
        'blockedApps': blockedApps,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error updating blocked apps: ${e.message}');
      return false;
    }
  }

  /// Get common app categories with their package names
  Map<String, List<String>> getCommonAppCategories() {
    return {
      'Social Media': [
        'com.facebook.katana',
        'com.instagram.android',
        'com.twitter.android',
        'com.snapchat.android',
        'com.zhiliaoapp.musically', // TikTok
        'com.reddit.frontpage',
        'com.linkedin.android',
        'com.pinterest',
      ],
      'Messaging': [
        'com.whatsapp',
        'com.facebook.orca', // Messenger
        'org.telegram.messenger',
        'com.discord',
        'com.viber.voip',
        'com.skype.raider',
      ],
      'Entertainment': [
        'com.google.android.youtube',
        'com.netflix.mediaclient',
        'com.spotify.music',
        'com.amazon.avod.thirdpartyclient', // Prime Video
        'com.hulu.plus',
        'com.disney.disneyplus',
      ],
      'Games': [
        'com.supercell.clashofclans',
        'com.mojang.minecraftpe',
        'com.ea.game.pvz2_row',
        'com.king.candycrushsaga',
        'com.roblox.client',
      ],
      'Shopping': [
        'com.amazon.mShop.android.shopping',
        'com.ebay.mobile',
        'com.alibaba.aliexpresshd',
        'com.etsy.android',
      ],
    };
  }

  /// Get preset blocked apps for different focus modes
  List<String> getPresetBlockedApps(FocusMode mode) {
    final categories = getCommonAppCategories();

    switch (mode) {
      case FocusMode.deepWork:
        return [
          ...categories['Social Media'] ?? [],
          ...categories['Messaging'] ?? [],
          ...categories['Games'] ?? [],
        ];

      case FocusMode.study:
        return [
          ...categories['Social Media'] ?? [],
          ...categories['Entertainment'] ?? [],
          ...categories['Games'] ?? [],
        ];

      case FocusMode.bedtime:
        // Block everything except essential apps
        return [
          ...categories['Social Media'] ?? [],
          ...categories['Messaging'] ?? [],
          ...categories['Entertainment'] ?? [],
          ...categories['Games'] ?? [],
          ...categories['Shopping'] ?? [],
        ];

      case FocusMode.minimalDistraction:
        return [
          ...categories['Social Media'] ?? [],
          ...categories['Games'] ?? [],
        ];

      case FocusMode.custom:
        return [];
    }
  }
}
