package works.end.LoveLust

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        // Disable the Android splash screen fade out animation to avoid
        // a flicker before the similar frame is drawn in Flutter.
        splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
    }
}
