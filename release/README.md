# Android release

This directory contains the signed, optimized Android APK for direct testing.

| Property | Value |
| --- | --- |
| Version | `2.0.0+6` |
| Package | `br.uasleep` |
| Minimum Android API | `24` |
| Target Android API | `36` |
| Signing | RSA 2048, APK Signature Scheme v2 |

Download `uAsleep-2.0.0+6-android-release.apk` and open it on an Android device.
The device may ask for permission to install apps from the browser, file
manager, or messaging application used to receive it.

Validate the file before installation:

```powershell
Get-FileHash -Algorithm SHA256 uAsleep-2.0.0+6-android-release.apk
```

The result must match `SHA256SUMS.txt`.

For public distribution, prefer attaching the APK to a GitHub Release instead
of adding future binaries directly to Git history.
