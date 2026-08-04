#!/bin/bash

APK="GalaxyWatchManager-2.2.11.25070451.apk"

echo "Stopping Samsung applications..."

adb shell am force-stop com.samsung.android.app.watchmanager
adb shell am force-stop com.samsung.android.waterplugin

echo "Removing current plugin..."

adb uninstall com.samsung.android.waterplugin

echo "Installing working version..."

adb install "$APK"

echo
echo "Installed version:"

adb shell dumpsys package com.samsung.android.waterplugin \
| grep versionName

