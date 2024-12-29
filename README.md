# weather_me_flutter

A new Flutter application.

<a href="http://resume.alperkurtul.com/wp-content/uploads/2021/09/weather-me.mp4" target="_blank">Demo Video<br><img src="readme_assets/weather-me-screen-shot.png" height="450"></a><br>

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## pubsbec.yaml

```
name: weather_me_flutter
description: A new Flutter application.

publish_to: 'none' # Remove this line if you wish to publish to pub.dev
```

## ANDROID Settings
```
/android/app/build.gradle
  - applicationId "com.alperkurtul.weather_me"  ==> CHANGE THIS LINE
```

```
/android/app/src/debug/AndroidManifest.xml
  - <manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.alperkurtul.weather_me">  ==> CHANGE THIS LINE
```

```
/android/app/src/main/AndroidManifest.xml
  - <manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.alperkurtul.weather_me">  ==> CHANGE THIS LINE
  - <uses-permission android:name="android.permission.INTERNET"/>  ==> ADD THIS LINE
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />  ==> ADD THIS LINE
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />  ==> ADD THIS LINE
    <application
        android:name="io.flutter.app.FlutterApplication"
        android:label="Weather ME"  ==> CHANGE THIS LINE
        android:icon="@mipmap/ic_launcher">
```

```
/android/app/src/main/ic_launcher-playstore.png  ==> COPY THIS
```

```
/android/app/src/main/kotlin/com/example/weather_me_flutter/MainActivity.kt
  - package com.alperkurtul.weather_me  ==> CHANGE THIS LINE
```

```
/android/app/src/main/res/drawable*  ==> COPY THESE
/android/app/src/main/res/mipmap*  ==> COPY THESE
/android/app/src/main/res/values/colors.xml  ==> ADD THIS
```

```
/android/app/src/profile/AndroidManifest.xml
  - <manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.weather_me_flutter">    ==> NOT SURE TO CHANGE THIS LINE
```

## iOS Settings

```
/ios/Runner/Info.plist
  - <key>CFBundleName</key>
	<string>Weather ME</string>  ==> CHANGE THIS LINE
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>$(FLUTTER_BUILD_NAME)</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleVersion</key>
	<string>$(FLUTTER_BUILD_NUMBER)</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>NSLocationAlwaysUsageDescription</key>  ==> ADD THIS LINE
	<string>This app needs access to location when in the background.</string>  ==> ADD THIS LINE
	<key>NSLocationWhenInUseUsageDescription</key>  ==> ADD THIS LINE
	<string>This app needs access to location when open.</string>  ==> ADD THIS LINE
	<key>UILaunchStoryboardName</key>
	<string>LaunchScreen</string>
```

```
/ios/Runner/Assets.xcassets/AppIcon.appiconset  ==> COPY THESE
/ios/Runner/Assets.xcassets/LaunchImage.imageset  ==> COPY THESE
```

```
XCODE ==> Runner ==> General
  - Display Name : Weather ME
  - Bundle Identifier : com.alperkurtul.weatherMe
```

## SPLASH Page Background Color

`#5A73EF`

## Build iOS app for deployment

```
- See the page: https://docs.flutter.dev/deployment/ios
- Read titles, 
  - "Update the app's build and version numbers" , 
  - "Create an app bundle" , 
  - "Upload the app bundle to App Store Connect" : 3. method => which is 'Or open build/ios/archive/MyApp.xcarchive in Xcode.'
-
- Open build/ios/archive/MyApp.xcarchive in Xcode.  ==> DONOT DO THIS
- DO THIS ==> Open Xcode. Then Open weather_me_flutter/ios. After that, open menu item  Product >> Archive
- First, Validate App. Then, Distribute App.

- version: 1.2.10
- /Users/alperkurtul/development/flutter_macos_arm64_3.27.1-stable/bin/flutter clean
- /Users/alperkurtul/development/flutter_macos_arm64_3.27.1-stable/bin/flutter build ipa
```

## Build Android app for deployment

```
- See the page: https://docs.flutter.dev/deployment/android
- Read title, "Build an app bundle"
-
- Upload the file "build/app/outputs/bundle/release/app-release.aab" to Google Play Console

- version: 1.2.10+17
- /Users/alperkurtul/development/flutter_macos_arm64_3.27.1-stable/bin/flutter clean
- /Users/alperkurtul/development/flutter_macos_arm64_3.27.1-stable/bin/flutter build appbundle
```