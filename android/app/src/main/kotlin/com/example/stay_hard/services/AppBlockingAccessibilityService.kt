package com.example.stay_hard.services

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.Intent
import android.view.accessibility.AccessibilityEvent
import com.example.stay_hard.activities.BlockingOverlayActivity

/**
 * Accessibility service that monitors app launches and blocks configured apps
 * during active focus sessions.
 */
class AppBlockingAccessibilityService : AccessibilityService() {

    companion object {
        private var instance: AppBlockingAccessibilityService? = null
        private val blockedApps = mutableSetOf<String>()
        private var isSessionActive = false
        private var currentSessionId: String? = null

        fun getInstance(): AppBlockingAccessibilityService? = instance

        fun startSession(sessionId: String, apps: List<String>) {
            blockedApps.clear()
            blockedApps.addAll(apps)
            currentSessionId = sessionId
            isSessionActive = true
        }

        fun stopSession() {
            blockedApps.clear()
            currentSessionId = null
            isSessionActive = false
        }

        fun updateBlockedApps(apps: List<String>) {
            blockedApps.clear()
            blockedApps.addAll(apps)
        }

        fun isActive(): Boolean = isSessionActive

        fun getSessionId(): String? = currentSessionId

        fun getBlockedApps(): Set<String> = blockedApps.toSet()
    }

    override fun onServiceConnected() {
        instance = this

        val info = AccessibilityServiceInfo().apply {
            eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            flags = AccessibilityServiceInfo.FLAG_RETRIEVE_INTERACTIVE_WINDOWS
            notificationTimeout = 100
        }

        serviceInfo = info
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            return
        }

        if (!isSessionActive || blockedApps.isEmpty()) {
            return
        }

        val packageName = event.packageName?.toString() ?: return

        // Don't block our own app
        if (packageName == applicationContext.packageName) {
            return
        }

        // Check if the app should be blocked
        if (blockedApps.contains(packageName)) {
            // Launch blocking overlay
            showBlockingOverlay(packageName)
        }
    }

    private fun showBlockingOverlay(packageName: String) {
        val intent = Intent(this, BlockingOverlayActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TASK or
                    Intent.FLAG_ACTIVITY_NO_HISTORY
            putExtra("blocked_package", packageName)
            putExtra("session_id", currentSessionId)
        }
        startActivity(intent)
    }

    override fun onInterrupt() {
        // Service interrupted
    }

    override fun onDestroy() {
        instance = null
        super.onDestroy()
    }
}
