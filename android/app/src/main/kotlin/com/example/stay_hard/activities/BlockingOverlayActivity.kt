package com.example.stay_hard.activities

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Bundle
import android.view.WindowManager
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.example.stay_hard.R
import com.example.stay_hard.MainActivity

/**
 * Full-screen overlay activity that blocks access to apps during focus sessions.
 * This activity is launched when a user tries to open a blocked app.
 */
class BlockingOverlayActivity : Activity() {

    companion object {
        fun createIntent(context: Context, packageName: String, sessionId: String?): Intent {
            return Intent(context, BlockingOverlayActivity::class.java).apply {
                putExtra("blocked_package", packageName)
                putExtra("session_id", sessionId)
            }
        }
    }

    private var blockedPackage: String? = null
    private var sessionId: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_blocking_overlay)

        // Make this activity full-screen and show over lockscreen
        window.addFlags(
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
            WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
        )

        blockedPackage = intent.getStringExtra("blocked_package")
        sessionId = intent.getStringExtra("session_id")

        setupUI()
    }

    private fun setupUI() {
        val appIcon = findViewById<ImageView>(R.id.blocked_app_icon)
        val appName = findViewById<TextView>(R.id.blocked_app_name)
        val message = findViewById<TextView>(R.id.blocking_message)
        val backToFocusButton = findViewById<Button>(R.id.back_to_focus_button)
        val endSessionButton = findViewById<Button>(R.id.end_session_button)

        // Get blocked app info
        blockedPackage?.let { packageName ->
            try {
                val pm = packageManager
                val appInfo: ApplicationInfo = pm.getApplicationInfo(packageName, 0)

                appIcon.setImageDrawable(pm.getApplicationIcon(appInfo))
                appName.text = pm.getApplicationLabel(appInfo).toString()

                message.text = "\"${pm.getApplicationLabel(appInfo)}\" is blocked during your focus session"
            } catch (e: PackageManager.NameNotFoundException) {
                appName.text = "This app"
                message.text = "This app is blocked during your focus session"
            }
        }

        backToFocusButton.setOnClickListener {
            returnToFocusScreen()
        }

        endSessionButton.setOnClickListener {
            // Return to main app with a flag to show end session dialog
            returnToFocusScreen()
        }
    }

    private fun returnToFocusScreen() {
        // Launch main activity and navigate to focus screen
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra("navigate_to", "focus")
            putExtra("session_id", sessionId)
        }
        startActivity(intent)
        finish()
    }

    @Deprecated("Deprecated in Java", ReplaceWith("returnToFocusScreen()"))
    override fun onBackPressed() {
        // Disable back button to prevent escaping the blocking screen
        returnToFocusScreen()
    }

    override fun onUserLeaveHint() {
        // User tried to leave (home button, recents, etc.)
        // Finish the activity but the accessibility service will continue
        // to monitor and re-block if they try to open the blocked app again
        finish()
    }

    override fun onResume() {
        super.onResume()
        // Ensure we're on top when resumed
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
    }
}
