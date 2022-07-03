# No idea why this is required here, and is not automatically applied to protobuf dependency.
# (to test: use release mode on a device and write to e.g. unauthenticated storage)
-keepclassmembers class * extends com.google.protobuf.GeneratedMessageLite {
  <fields>;
}
# Required for androidx.security 1.0.0-rc02
# https://github.com/google/tink/issues/361
-keepclassmembers class * extends com.google.crypto.tink.shaded.protobuf.GeneratedMessageLite {
  <fields>;
}

-keepclasseswithmembers class * {
    @com.squareup.moshi.* <methods>;
}
-keep @com.squareup.moshi.JsonQualifier interface *
-dontwarn org.jetbrains.annotations.**
-keep class kotlin.Metadata { *; }
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

-keepclassmembers class ** {
    @com.squareup.moshi.FromJson *;
    @com.squareup.moshi.ToJson *;
}

-keepclassmembers class com.squareup.moshi.internal.Util {
    private static java.lang.String getKotlinMetadataClassName();
}