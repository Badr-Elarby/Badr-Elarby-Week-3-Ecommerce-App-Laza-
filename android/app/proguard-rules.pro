# ProGuard configuration for Laza E-Commerce App
# OPTIMIZATION: Enables code shrinking and obfuscation for release builds

# Keep Flutter classes and prevent optimization issues
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Material Design classes
-keep class com.google.android.material.** { *; }
-keepclassmembers class com.google.android.material.** {
    public <methods>;
}

# Keep app's main classes
-keep class com.example.laza.** { *; }

# Keep Dio and networking classes
-keep class retrofit2.** { *; }
-keep interface retrofit2.** { *; }

# Keep OkHttp classes (used by Dio)
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Keep shared preferences
-keep class android.content.SharedPreferences { *; }

# Keep Flutter plugins
-keep class * implements io.flutter.embedding.engine.FlutterPlugin

# Allow method removal and class shrinking (safe for most apps)
-optimizationpasses 5
-dontusemixedcaseclassnames
-verbose

# Preserve line numbers for debugging in case of crashes
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Keep exceptions for crash analysis
-keepattributes *Annotation*

# JSON serialization support (if using json_serializable)
-keepattributes *Annotation*
-keep class **.*.model.** { *; }
-keep class **.*.models.** { *; }
