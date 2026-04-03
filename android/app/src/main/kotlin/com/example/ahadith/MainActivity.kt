package com.example.ahadith

import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsControllerCompat
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		applySystemBars()
	}

	override fun onPostResume() {
		super.onPostResume()
		applySystemBars()
	}

	override fun onWindowFocusChanged(hasFocus: Boolean) {
		super.onWindowFocusChanged(hasFocus)
		if (hasFocus) {
			applySystemBars()
		}
	}

	private fun applySystemBars() {
		WindowCompat.setDecorFitsSystemWindows(window, true)
		window.setBackgroundDrawable(ColorDrawable(Color.parseColor("#F8F5F2")))
		window.statusBarColor = Color.TRANSPARENT
		window.navigationBarColor = Color.parseColor("#F8F5F2")
		window.navigationBarDividerColor = Color.TRANSPARENT

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
			WindowInsetsControllerCompat(window, window.decorView).isAppearanceLightNavigationBars = true
		}

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
			WindowInsetsControllerCompat(window, window.decorView).isAppearanceLightStatusBars = true
		}

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
			window.isNavigationBarContrastEnforced = false
			window.isStatusBarContrastEnforced = false
		}
	}
}
