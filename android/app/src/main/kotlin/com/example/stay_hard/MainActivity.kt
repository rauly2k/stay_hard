package com.example.stay_hard

import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Base64
import androidx.annotation.NonNull
import com.example.stay_hard.services.AppBlockingAccessibilityService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.stayhard/app_blocking"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startFocusSession" -> {
                    val sessionId = call.argument<String>("sessionId")
                    val blockedApps = call.argument<List<String>>("blockedApps")
                    val blockNotifications = call.argument<Boolean>("blockNotifications") ?: false

                    if (sessionId != null && blockedApps != null) {
                        AppBlockingAccessibilityService.startSession(sessionId, blockedApps)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGS", "Missing required arguments", null)
                    }
                }

                "stopFocusSession" -> {
                    AppBlockingAccessibilityService.stopSession()
                    result.success(true)
                }

                "getInstalledApps" -> {
                    val apps = getInstalledApps()
                    result.success(apps)
                }

                "isAccessibilityServiceEnabled" -> {
                    val isEnabled = isAccessibilityServiceEnabled()
                    result.success(isEnabled)
                }

                "openAccessibilitySettings" -> {
                    openAccessibilitySettings()
                    result.success(null)
                }

                "hasUsageStatsPermission" -> {
                    val hasPermission = hasUsageStatsPermission()
                    result.success(hasPermission)
                }

                "requestUsageStatsPermission" -> {
                    requestUsageStatsPermission()
                    result.success(null)
                }

                "getAppIcon" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        val icon = getAppIcon(packageName)
                        result.success(icon)
                    } else {
                        result.error("INVALID_ARGS", "Package name required", null)
                    }
                }

                "isAppBlocked" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        val isBlocked = AppBlockingAccessibilityService.getBlockedApps().contains(packageName)
                        result.success(isBlocked)
                    } else {
                        result.error("INVALID_ARGS", "Package name required", null)
                    }
                }

                "getActiveSessionId" -> {
                    val sessionId = AppBlockingAccessibilityService.getSessionId()
                    result.success(sessionId)
                }

                "updateBlockedApps" -> {
                    val blockedApps = call.argument<List<String>>("blockedApps")
                    if (blockedApps != null) {
                        AppBlockingAccessibilityService.updateBlockedApps(blockedApps)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGS", "Blocked apps list required", null)
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getInstalledApps(): List<Map<String, String>> {
        val packageManager = packageManager
        val packages = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
        val appsList = mutableListOf<Map<String, String>>()

        for (packageInfo in packages) {
            // Include all apps (both system and user apps) except the launcher
            // Filter out apps without a launch intent (background services, etc.)
            if (packageManager.getLaunchIntentForPackage(packageInfo.packageName) != null) {
                val appInfo = mapOf(
                    "packageName" to packageInfo.packageName,
                    "name" to packageManager.getApplicationLabel(packageInfo).toString(),
                    "icon" to getAppIconAsBase64(packageInfo.packageName)
                )
                appsList.add(appInfo)
            }
        }

        return appsList.sortedBy { it["name"] }
    }

    private fun getAppIcon(packageName: String): String? {
        return getAppIconAsBase64(packageName)
    }

    private fun getAppIconAsBase64(packageName: String): String {
        return try {
            val icon = packageManager.getApplicationIcon(packageName)
            val bitmap = drawableToBitmap(icon)
            val outputStream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
            val byteArray = outputStream.toByteArray()
            Base64.encodeToString(byteArray, Base64.DEFAULT)
        } catch (e: Exception) {
            ""
        }
    }

    private fun drawableToBitmap(drawable: Drawable): Bitmap {
        if (drawable is BitmapDrawable) {
            return drawable.bitmap
        }

        val bitmap = Bitmap.createBitmap(
            drawable.intrinsicWidth,
            drawable.intrinsicHeight,
            Bitmap.Config.ARGB_8888
        )
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)
        return bitmap
    }

    private fun isAccessibilityServiceEnabled(): Boolean {
        val service = "${packageName}/${AppBlockingAccessibilityService::class.java.canonicalName}"
        val enabledServices = Settings.Secure.getString(
            contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        )
        return enabledServices?.contains(service) == true
    }

    private fun openAccessibilitySettings() {
        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)
    }

    private fun hasUsageStatsPermission(): Boolean {
        val appOpsManager = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOpsManager.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(),
                packageName
            )
        } else {
            @Suppress("DEPRECATION")
            appOpsManager.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(),
                packageName
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun requestUsageStatsPermission() {
        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
        intent.data = Uri.parse("package:$packageName")
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)
    }

    override fun onDestroy() {
        methodChannel?.setMethodCallHandler(null)
        super.onDestroy()
    }
}
