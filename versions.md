# Galaxy Watch 4 Compatibility Matrix

## Test Environment

| Component | Value                            |
| --------- | -------------------------------- |
| Phone     | Realme X2 (RMX1993)              |
| Android   | 11                               |
| Watch     | Samsung Galaxy Watch 4 (SM-R860) |

---

# Tested Versions

## Galaxy Wearable

| Version             | Status    | Notes                                                                  |
| ------------------- | --------- | ---------------------------------------------------------------------- |
| **2.2.70.26060861** | ✅ Working | No crashes. Works correctly with Galaxy Watch Manager 2.2.11.25070451. |

---

## Galaxy Watch Manager (Galaxy Watch4 Plugin)

Package:

```text
com.samsung.android.waterplugin
```

| Version             | Status    | Notes                              |
| ------------------- | --------- | ---------------------------------- |
| **2.2.11.26071051** | ❌ Broken  | Crashes immediately after pairing. |
| **2.2.11.25070451** | ✅ Working | Stable. Recommended version.       |

---

# Crash Details

Broken version:

```text
Galaxy Watch Manager
2.2.11.26071051
```

Crash:

```text
java.lang.IllegalAccessError

Method:

android.view.View.isDebugVersion()

Process:

com.samsung.android.waterplugin:plugin
```

Crash location:

```text
com.samsung.android.waterplugin.activity.HMLaunchActivity.initialSplashScreen()
```

---

# Working Configuration

Galaxy Wearable

```text
2.2.70.26060861
```

Galaxy Watch Manager

```text
2.2.11.25070451
```

Result

* Galaxy Wearable starts normally.
* Watch pairing succeeds.
* Watch faces synchronize.
* Settings synchronize.
* Notifications work.
* Bluetooth reconnect works.

---

# ADB Commands

## Installed versions

```bash
adb shell dumpsys package com.samsung.android.app.watchmanager \
| grep -E "versionName|versionCode"

adb shell dumpsys package com.samsung.android.waterplugin \
| grep -E "versionName|versionCode"
```

---

## Capture crash log

```bash
adb logcat -c

adb logcat -b crash > crash.txt
```

---

## Stop Samsung applications

```bash
adb shell am force-stop com.samsung.android.app.watchmanager

adb shell am force-stop com.samsung.android.waterplugin
```

---

## Remove plugin

```bash
adb uninstall com.samsung.android.waterplugin
```

---

## Install working version

```bash
adb install GalaxyWatchManager-2.2.11.25070451.apk
```

---

# Timeline

| Date       | Action                                             | Result                |
| ---------- | -------------------------------------------------- | --------------------- |
| 2026-08-04 | Galaxy Wearable started crashing after pairing     | Failed                |
| 2026-08-04 | Cleared cache and data                             | Failed                |
| 2026-08-04 | Reinstalled Galaxy Wearable                        | Failed                |
| 2026-08-04 | Reset Galaxy Watch 4                               | Failed                |
| 2026-08-04 | Captured ADB crash log                             | Root cause identified |
| 2026-08-04 | Downgraded Galaxy Watch Manager to 2.2.11.25070451 | Success               |

---

# Notes

* The issue is caused by **Galaxy Watch Manager**, not Galaxy Wearable.
* The crashing process is:

```text
com.samsung.android.waterplugin
```

* The failure is reproducible on Android 11 (Realme X2).
* Downgrading only the plugin is sufficient.
* Galaxy Wearable does not need to be downgraded.

---

# TODO

Future versions to test:

* [ ] Galaxy Watch Manager 2.2.11.2509xxxx
* [ ] Galaxy Watch Manager 2.2.11.2512xxxx
* [ ] Galaxy Watch Manager 2.2.11.2607xxxx (fixed release, if Samsung publishes one)

Update this file whenever a newer version is verified.

