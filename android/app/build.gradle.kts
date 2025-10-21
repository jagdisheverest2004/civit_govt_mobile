plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.civic_issue_app"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        // Set Java version to 17 for consistency with the Kotlin JVM target
        sourceCompatibility = JavaVersion.VERSION_17 
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        // Set JVM target to 17 to resolve the Inconsistent JVM-target error
        jvmTarget = JavaVersion.VERSION_17.toString() 
    }

    defaultConfig {
        applicationId = "com.example.civic_issue_app"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
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

dependencies {
    // FIX: Changed to a stable version (2.0.4) because 2.2.0 could not be found
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") 
}