plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")  // Flutter Gradle Plugin
}

android {
    namespace = "com.qaltrix.qaltrix"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
    applicationId = "com.qaltrix.qaltrix"
    minSdk = flutter.minSdkVersion          // minimum SDK for uni_links
    targetSdk = 33       // recommended target SDK
    versionCode = flutter.versionCode
    versionName = flutter.versionName
}


    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
