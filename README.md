# nada_cilik

A Flutter mobile application project for learning and demo purposes.

## Project Overview

This repository contains a Flutter app with multiple screens, custom widgets, and cross-platform support for Android, iOS, web, Linux, macOS, and Windows.

## Folder Structure

- `android/` - Android native build configuration and Gradle files.
- `ios/` - iOS native build configuration and Xcode project files.
- `linux/`, `macos/`, `windows/`, `web/` - Platform-specific support for desktop and web builds.
- `lib/` - Main Dart source code.
  - `lib/screens/` - App screens such as login, home, music player, profile edit, and favorites.
  - `lib/models/` - Data models used in the app, for example `song.dart`.
  - `lib/widgets/` - Reusable UI widgets used across screens.
- `assets/images/` - Image assets used in the UI.
- `test/` - Widget and unit tests.
- `pubspec.yaml` - Flutter and Dart dependencies, assets, fonts, and metadata.
- `analysis_options.yaml` - Dart analyzer rules and lint settings.

## Recent Update

The latest update improved `lib/screens/edit_profile_screen.dart` by:

- Removing the generic `AppBar` from `EditProfileScreen`.
- Replacing it with a consistent header card inside the page layout.
- Fixing the layout issue and making the screen visually consistent with other pages.

This change makes the profile edit screen more stable and easier to maintain.
