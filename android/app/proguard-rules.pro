# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# SQLite
-keep class org.sqlite.** { *; }
-keep class org.sqlite.database.** { *; }

# HTTP
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Gson (if used)
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }

# Keep model classes
-keep class com.shoppingapp.shopping_app.models.** { *; }
