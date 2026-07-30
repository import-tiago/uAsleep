# uAsleep visual identity

The uAsleep identity combines a battery with a crescent moon to communicate
battery autonomy, sleep cycles, and low-power embedded systems.

## Core palette

| Role | Color |
| --- | --- |
| Deep navy | `#071A33` |
| Navy | `#0B2A4A` |
| Electric blue | `#2F80ED` |
| Cyan accent | `#38BDF8` |
| Off-white | `#F8FAFC` |

The navy colors define backgrounds and structure. Electric blue identifies
primary actions, while cyan is reserved for focused states and energy-related
accents. Purple and magenta are not part of the brand palette.

## Assets

- App icon source: `src/assets/branding/app_icon.png`
- Repository banner: `docs/brand/uasleep-banner.png`
- Android splash marks: `src/android/app/src/main/res/mipmap-*/launch_image.png`
- iOS splash marks: `src/ios/Runner/Assets.xcassets/SplashMark.imageset`
- Dynamic iOS splash background:
  `src/ios/Runner/Assets.xcassets/SplashBackground.colorset`

Platform-specific Android and iOS icon sizes are generated from the app icon
source with `flutter_launcher_icons`.

The native splash uses the neutral `#F8FAFC` background in every
operating-system appearance. Flutter theme preferences are loaded only after
the native launch screen has finished.
