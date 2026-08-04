# Fix: Galaxy Watch 4 crashes on Realme X2 (Android 11) with `IllegalAccessError: View.isDebugVersion()`

> **Devices**
>
> * Samsung Galaxy Watch 4 (SM-R860)
> * Realme X2 (RMX1993)
> * Android 11
>
> **Affected component**
>
> `com.samsung.android.waterplugin`
>
> **Working plugin version**
>
> `2.2.11.25070451`

---

# Problem

After several years of stable operation, **Galaxy Wearable** suddenly became unusable.

The watch continued to work, but the phone application crashed immediately after pairing.

Typical symptoms:

* Galaxy Wearable starts normally.
* Pairing completes successfully.
* Initial setup finishes.
* Galaxy Wearable immediately closes.
* Every subsequent launch crashes again.
* Resetting the watch does not help.
* Clearing cache/data does not help.
* Reinstalling Galaxy Wearable does not help.
* Updating the watch firmware does not help.

At first glance it looks like Galaxy Wearable is crashing.

It is not.

---

# Environment

## Phone

* Realme X2 (RMX1993)
* Android 11

## Watch

* Samsung Galaxy Watch 4
* SM-R860

## Installed versions

Galaxy Wearable

```
2.2.70.26060861
```

Galaxy Watch Manager

```
2.2.11.26071051
```

---

# Root Cause

The first useful step was collecting an Android crash log.

Clear previous logs:

```bash
adb logcat -c
```

Capture crash log:

```bash
adb logcat -b crash > crash.txt
```

The important part of the log:

```text
FATAL EXCEPTION: main

Process:
com.samsung.android.waterplugin:plugin

java.lang.IllegalAccessError:

Method
android.view.View.isDebugVersion()

at
com.samsung.android.waterplugin.activity.HMLaunchActivity.initialSplashScreen()
```

This immediately identifies the problem.

**Galaxy Wearable is NOT crashing.**

The crashing process is

```
com.samsung.android.waterplugin
```

which is Galaxy Watch Manager (Galaxy Watch4 Plugin).

The exception is

```
IllegalAccessError
```

coming from Samsung's One UI Material library.

The newer plugin attempts to call

```
android.view.View.isDebugVersion()
```

which is incompatible with Android 11 on Realme UI.

---

# Solution

Do **NOT** downgrade Galaxy Wearable first.

Downgrade only **Galaxy Watch Manager**.

Working version:

```
2.2.11.25070451
```

Galaxy Wearable remained on the newest version:

```
2.2.70.26060861
```

---

# Installation

Stop running Samsung applications:

```bash
adb shell am force-stop com.samsung.android.app.watchmanager

adb shell am force-stop com.samsung.android.waterplugin
```

Remove only the plugin:

```bash
adb uninstall com.samsung.android.waterplugin
```

Install the older APK:

```bash
adb install GalaxyWatchManager-2.2.11.25070451.apk
```

Verify installation:

```bash
adb shell dumpsys package com.samsung.android.waterplugin \
| grep versionName
```

Expected result:

```
versionName=2.2.11.25070451
```

---

# First launch

After installing the older plugin:

* Galaxy Wearable opened correctly.
* Pairing completed successfully.
* Settings became available.

Initially watch face changes appeared to fail.

The first synchronization completed after:

1. Close Galaxy Wearable.
2. Turn Bluetooth OFF.
3. Turn Bluetooth ON.
4. Open Galaxy Wearable again.

After that:

* watch face changes worked;
* settings synchronized correctly;
* Galaxy Wearable remained stable.

---

# Final working configuration

Phone

* Realme X2 (RMX1993)
* Android 11

Watch

* Samsung Galaxy Watch 4 (SM-R860)

Applications

Galaxy Wearable

```
2.2.70.26060861
```

Galaxy Watch Manager

```
2.2.11.25070451
```

Status

* ✅ Stable
* ✅ Watch faces work
* ✅ Settings synchronize
* ✅ Notifications work
* ✅ Bluetooth reconnects normally

---

# Important

Disable automatic updates for **Galaxy Watch Manager**.

Otherwise Google Play may reinstall the newer plugin and the crash will return.

---

# Repository structure

```
README.md
install.sh
versions.md
```

Example `install.sh`:

```bash
#!/bin/bash

adb shell am force-stop com.samsung.android.app.watchmanager
adb shell am force-stop com.samsung.android.waterplugin

adb uninstall com.samsung.android.waterplugin

adb install GalaxyWatchManager-2.2.11.25070451.apk

adb shell dumpsys package com.samsung.android.waterplugin \
| grep versionName
```

---

# Keywords

Galaxy Watch 4

Galaxy Watch Manager

Galaxy Wearable

Realme X2

RMX1993

Android 11

Galaxy Watch4 Plugin

com.samsung.android.waterplugin

IllegalAccessError

View.isDebugVersion

FloatingGroupLayout

Galaxy Wearable crash

Galaxy Wearable closes immediately

Galaxy Wearable keeps crashing

Galaxy Watch Manager 2.2.11.26071051

Galaxy Watch Manager 2.2.11.25070451

ADB

logcat

---

Hopefully this saves someone several hours of reinstalling applications that were never actually responsible for the crash.
