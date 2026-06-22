plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val freeApplicationIdSuffix = providers
    .gradleProperty("FOXTALK_FREE_APPLICATION_ID_SUFFIX")
    .orNull

android {
    namespace = "com.chatim.foxtalk"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.chatim.foxtalk"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "edition"
    productFlavors {
        create("free") {
            dimension = "edition"
            if (!freeApplicationIdSuffix.isNullOrBlank()) {
                applicationIdSuffix = freeApplicationIdSuffix
            }
            manifestPlaceholders["edition"] = "free"
        }
        create("pro") {
            dimension = "edition"
            manifestPlaceholders["edition"] = "pro"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.zxing:core:3.5.3")
    // 高德 Android SDK 是收费 location 模块 native 依赖，只进入 pro sourceSet。
    // free 包不能带 jar/.so/Manifest 权限，否则只是隐藏入口而不是真裁剪。
    add("proImplementation", files("src/pro/libs/AMap_Android_SDK.jar"))
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
