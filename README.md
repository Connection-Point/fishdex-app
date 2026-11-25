# FishDex — Android app

Flutter app for **FishDex**: photograph real fish, identify them with AI, and collect them as premium trading cards. Malaysian freshwater and marine species first.

> **Status:** closed beta, Android only. Milestone M2 (app shell, auth, catalogue) is done; scanning and the FishDex grid are next. The backend lives in a separate repository, **fishdex-api**, together with the architecture docs.

---

## Contents

- [Features](#features)
- [Tech stack](#tech-stack)
- [Getting started](#getting-started)
- [Configuration](#configuration)
- [Running](#running)
- [Testing](#testing)
- [Project structure](#project-structure)
- [Building a release](#building-a-release)
- [Roadmap](#roadmap)
- [License](#license)

---

## Features

- **Original TCG look:** dark-ocean theme, FishDex card frame with rarity-coloured borders and a foil sheen on rarer cards (disabled when the OS asks to reduce motion)
- **Accounts:** sign in or register with email, Google sign-in (when configured), password reset, session restore, automatic sign-out on expired tokens, in-app account deletion
- **Catalogue:** search in English, Bahasa Malaysia, local names or scientific names; water-type and origin filters; infinite scroll; species page with card, identification notes, habitat, distribution, conservation status, look-alikes and protected-species notices
- **Beta AI consent:** the Scan tab requires the closed-beta AI notice before scanning
- **Bilingual:** English and Bahasa Malaysia, starting from the device language and saved to the user's profile
- **Accessible rarity:** colour plus icon plus label, never colour alone

## Tech stack

| Area | Choice |
|---|---|
| Framework | Flutter 3.50 · Dart 3.14 |
| UI | Material 3 via `material_ui` (Material moved out of the Flutter SDK in 3.47) |
| State | Riverpod 3 |
| Navigation | go_router 18 (auth redirect, tabbed shell) |
| HTTP | Dio, with typed RFC 9457 problem+json errors |
| Storage | flutter_secure_storage (Android Keystore) |
| Auth | Email + Google Sign-In 7 → Laravel Sanctum tokens |
| i18n | Flutter gen-l10n (ARB files) |

## Getting started

### Prerequisites

- Flutter **3.50+** (`flutter doctor` green for Android)
- Android Studio with an emulator, or an Android 8.0+ phone with USB debugging
- A running **fishdex-api** backend (`php artisan serve` plus the queue worker)

### Install

```bash
git clone <this-repo> fishdex-app
cd fishdex-app
flutter pub get
```

## Configuration

Settings are passed at build time with `--dart-define`. Copy `dart_defines.example.json` to `dart_defines.json` (git-ignored) and edit it, or pass values directly:

| Key | Default | Purpose |
|---|---|---|
| `API_BASE_URL` | `http://10.0.2.2:8000/api/v1` | Backend URL. `10.0.2.2` is your PC as seen from the Android emulator |
| `GOOGLE_SERVER_CLIENT_ID` | *(empty)* | **Web** OAuth client ID. Empty hides the Google button |
| `APP_VERSION` | `1.0.0+1` | Sent as `X-App-Version`; the backend rejects versions below its minimum |

### Google Sign-In (optional)

1. In Google Cloud, create an **Android** OAuth client (package `app.fishdex` + your SHA-1 from `cd android && ./gradlew signingReport`) and a **Web** OAuth client.
2. Pass the web client ID as `GOOGLE_SERVER_CLIENT_ID`.
3. Add the same web client ID to the backend's `GOOGLE_CLIENT_IDS`.

## Running

```bash
# Android emulator
flutter run --dart-define-from-file=dart_defines.json

# Real phone over USB: forward the port, then point the app at localhost
adb reverse tcp:8000 tcp:8000
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1
```

VS Code launch configurations for both are in `.vscode/launch.json`.

Debug and profile builds allow plain HTTP to a local dev server; release builds are HTTPS-only.

## Testing

```bash
flutter analyze
dart format --output=none --set-exit-if-changed lib test
flutter test test/unit test/widget
```

- **Unit tests** parse real JSON captured from the backend (`test/fixtures/`), so any drift between the app's models and the API fails a test. After API changes, regenerate the fixtures with `tool/capture_fixtures.sh` (Git Bash on Windows) against a freshly seeded backend.
- **Widget tests** cover login, registration with server-side field errors, session restore and sign-out, catalogue search and filters, species detail, the AI-consent gate, and switching to Bahasa Malaysia.
- **Contract test** runs the real repositories against a live backend:

  ```bash
  # PowerShell: $env:FISHDEX_API="http://127.0.0.1:8000/api/v1"; flutter test test/contract
  FISHDEX_API=http://127.0.0.1:8000/api/v1 flutter test test/contract
  ```

GitHub Actions (`.github/workflows/ci.yml`) runs format, analyze and tests on every push and builds a debug APK as a downloadable artifact.

## Project structure

```
lib/
  app/              app.dart (MaterialApp + l10n), router.dart (auth redirect, tabs), providers.dart (DI)
  core/             API client, problem+json errors, secure token store, build config
  design_system/    colour tokens, theme, FishCardView, RarityBadge, loading/error/empty states
  features/
    auth/           session controller, repository, Google wrapper, login/register/consent screens
    catalogue/      models, repository, list/detail providers and screens
    config/         /app/config model
    profile/        profile, language, sign out, delete account
    shell/          bottom navigation; placeholders for FishDex, Scan and Journal
  l10n/             app_en.arb, app_ms.arb (+ generated Dart)
test/
  fixtures/         real backend responses
  unit/             model and error parsing
  widget/           UI flows with fake repositories
  contract/         live-backend tests (opt-in)
tool/               fixture capture script
```

Conventions:
- Import `package:material_ui/material_ui.dart`, not `package:flutter/material.dart` (deprecated).
- Models are plain Dart classes with `fromJson` factories (no code generation).
- All user-facing text goes in both ARB files.

## Building a release

1. Create an upload keystore and `android/key.properties` (both git-ignored); see [Flutter's Android signing guide](https://docs.flutter.dev/deployment/android#sign-the-app).
2. Build an app bundle against the production API:

   ```bash
   flutter build appbundle --release --obfuscate --split-debug-info=build/symbols \
     --dart-define=API_BASE_URL=https://api.fishdex.app/api/v1 \
     --dart-define=GOOGLE_SERVER_CLIENT_ID=<web-client-id> \
     --dart-define=APP_VERSION=1.0.0+1
   ```

3. Keep `build/symbols` somewhere safe (needed to read crash reports), then upload the `.aab` to the Google Play closed-testing track.

## Roadmap

| Milestone | Scope |
|---|---|
| **M4** | Camera scanner, upload, waiting/queued states, result and candidate picker, Collect/Release, card reveal animation, offline scan queue |
| **M5** | FishDex card grid, journal and trips, stats, personal bests |
| **M6** | Push notifications, Crashlytics/Analytics, force-update screen, Play Integrity |
| **M7** | Closed beta on Google Play |

## License

Proprietary. Copyright © 2026 FishDex. All rights reserved. No permission is granted to use, copy, modify or distribute this software without written consent.
