plugins {
  id("com.android.application")
  id("kotlin-android")
}

android {
  compileSdk = 30
  buildToolsVersion = "30.0.3"

  defaultConfig {
    applicationId = "qiuxiang.app"
    minSdk = 21
    targetSdk = 30
    versionCode = 1
    versionName = "1.0"
  }
  signingConfigs {
    named("debug") {
      storeFile = file("${System.getProperty("user.home")}/.android/debug.keystore")
      storePassword = "android"
      keyAlias = "androiddebugkey"
      keyPassword = "android"
    }
  }
  buildTypes {
    release {
      signingConfig = signingConfigs.getByName("debug")
      proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
    }
  }
  kotlinOptions {
    useIR = true
    jvmTarget = "1.8"
  }
  buildFeatures {
    compose = true
  }
}

dependencies {
  implementation("androidx.appcompat:appcompat:1.2.0")
  implementation("com.google.android.material:material:1.3.0")
  implementation("androidx.compose.ui:ui:1.0.0-beta04")
  implementation("androidx.compose.material:material:1.0.0-beta03")
  implementation("androidx.activity:activity-compose:1.3.0-alpha05")
  implementation("com.tencent.map:tencent-map-vector-sdk:4.4.1")
}