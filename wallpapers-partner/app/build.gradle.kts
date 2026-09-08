plugins {
    id("com.android.application")
}

android {
    namespace = "com.goreecloud.wallpapers.partner"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.goreecloud.wallpapers.partner"
        minSdk = 23
        targetSdk = 36
        versionCode = 1
        versionName = "0.1.0-dev"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
        }
    }
}
