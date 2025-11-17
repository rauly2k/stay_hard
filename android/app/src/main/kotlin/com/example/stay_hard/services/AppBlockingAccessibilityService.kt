package com.example.stay_hard.services

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.Intent
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import com.example.stay_hard.activities.BlockingOverlayActivity

/**
 * Accessibility service that monitors app launches and blocks configured apps
 * during active focus sessions.
 */
class AppBlockingAccessibilityService : AccessibilityService() {

    companion object {
        private const val TAG = "AppBlockingService"
        private var instance: AppBlockingAccessibilityService? = null
        private val blockedApps = mutableSetOf<String>()
        private var isSessionActive = false
        private var currentSessionId: String? = null
        private var lastBlockedPackage: String? = null
        private var lastBlockTime: Long = 0

        fun getInstance(): AppBlockingAccessibilityService? = instance

        fun startSession(sessionId: String, apps: List<String>) {
            Log.d(TAG, "Starting session: $sessionId with ${apps.size} blocked apps")
            blockedApps.clear()
            blockedApps.addAll(apps)
            currentSessionId = sessionId
            isSessionActive = true

            // Log all blocked apps for debugging
            apps.forEach { Log.d(TAG, "Blocking app: $it") }
        }

        fun stopSession() {
            Log.d(TAG, "Stopping session: $currentSessionId")
            blockedApps.clear()
            currentSessionId = null
            isSessionActive = false
            lastBlockedPackage = null
        }

        fun updateBlockedApps(apps: List<String>) {
            Log.d(TAG, "Updating blocked apps: ${apps.size} apps")
            blockedApps.clear()
            blockedApps.addAll(apps)
            apps.forEach { Log.d(TAG, "Updated blocking app: $it") }
        }

        fun isActive(): Boolean = isSessionActive

        fun getSessionId(): String? = currentSessionId

        fun getBlockedApps(): Set<String> = blockedApps.toSet()
    }

    override fun onServiceConnected() {
        instance = this
        Log.d(TAG, "Accessibility service connected")

        val info = AccessibilityServiceInfo().apply {
            eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            flags = AccessibilityServiceInfo.FLAG_RETRIEVE_INTERACTIVE_WINDOWS
            notificationTimeout = 100
        }

        serviceInfo = info
        Log.d(TAG, "Service info configured successfully")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            return
        }

        val packageName = event.packageName?.toString() ?: return

        // Log all window changes for debugging (only if session is active)
        if (isSessionActive) {
            Log.d(TAG, "Window changed to: $packageName")
        }

        if (!isSessionActive || blockedApps.isEmpty()) {
            return
        }

        // Don't block our own app or the blocking overlay
        if (packageName == applicationContext.packageName ||
            packageName == "com.example.stay_hard") {
            return
        }

        // Check if the app should be blocked
        if (blockedApps.contains(packageName)) {
            // Prevent rapid re-triggering for the same app
            val currentTime = System.currentTimeMillis()
            val shouldBlock = lastBlockedPackage != packageName ||
                             (currentTime - lastBlockTime) > 500 // 500ms debounce

            if (shouldBlock) {
                Log.d(TAG, "BLOCKING APP: $packageName")
                lastBlockedPackage = packageName
                lastBlockTime = currentTime

                // Launch blocking overlay - this will be triggered repeatedly
                // as long as the user tries to access the blocked app
                showBlockingOverlay(packageName)
            } else {
                Log.d(TAG, "Debounced block for: $packageName")
            }
        }
    }

    private fun showBlockingOverlay(packageName: String) {
        try {
            Log.d(TAG, "Launching blocking overlay for: $packageName")
            val intent = Intent(this, BlockingOverlayActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TASK or
                        Intent.FLAG_ACTIVITY_NO_HISTORY
                putExtra("blocked_package", packageName)
                putExtra("session_id", currentSessionId)
            }
            startActivity(intent)
            Log.d(TAG, "Blocking overlay launched successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Error launching blocking overlay", e)
        }
    }

    override fun onInterrupt() {
        Log.w(TAG, "Accessibility service interrupted")
    }

    override fun onDestroy() {
        Log.d(TAG, "Accessibility service destroyed")
        instance = null
        super.onDestroy()
    }
}
