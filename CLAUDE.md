# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**품은기도 (Pumeun Gido)** - A Flutter prayer management app that helps users organize prayer requests from friends and track answered prayers. Built with Supabase backend and Google/Apple authentication.

### App Information
| Platform | Bundle ID |
|----------|-----------|
| Android | `com.jc.pumeun_gido` |
| iOS | `com.jc.pumeun-gido` |

## Build & Run Commands

```bash
# Install dependencies
flutter pub get

# Run code generation (freezed, riverpod_generator, json_serializable)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
dart run build_runner watch --delete-conflicting-outputs

# Run the app
flutter run

# Analyze code
flutter analyze

# Run tests
flutter test

# Generate app icons
dart run flutter_launcher_icons
```

## Release Build Scripts

### Android Build
```bash
# App Bundle (기본)
./scripts/build_android.sh

# App Bundle + APK
./scripts/build_android.sh --all

# Clean 후 빌드
./scripts/build_android.sh --clean

# 코드 생성 스킵
./scripts/build_android.sh --skip-gen
```

### iOS Build
```bash
# 기본 빌드 (코드 서명 포함, 배포용)
./scripts/build_ios.sh

# Clean 후 빌드
./scripts/build_ios.sh --clean

# 코드 생성 스킵
./scripts/build_ios.sh --skip-gen

# 코드 서명 없이 (테스트용)
./scripts/build_ios.sh --no-codesign
```

### Build Output
- Android: `archive/android/pumeun_gido_v{version}_{build}_{timestamp}.aab`
- iOS: `~/Library/Developer/Xcode/Archives/YYYY-MM-DD/` (Xcode Organizer)

## Architecture

### State Management: Riverpod + Freezed
- Uses `flutter_riverpod` for state management with code-generated providers via `riverpod_annotation`
- State classes are immutable using `freezed` package
- ViewModels use `@riverpod` annotation and expose state via `AsyncValue<T>`

### Dependency Injection Flow
1. `SupabaseService` initialized in `main.dart` and injected via `supabaseServiceProvider.overrideWithValue()`
2. `AuthService` depends on `SupabaseService` via provider watching
3. Repositories (`IPrayerRepository`, `IRequesterRepository`) access Supabase through injected service

### Layer Structure
```
lib/
├── core/
│   ├── config/        # AppConfig, theme (colors, text styles)
│   ├── di/            # Riverpod providers (services, repositories)
│   └── router/        # GoRouter configuration
├── data/
│   ├── models/        # Data models (PrayerRequestModel, RequesterModel, UserModel)
│   ├── repositories/  # interfaces/ and impl/ for data access
│   └── services/      # SupabaseService, AuthService, AdService, AnalyticsService
├── presentation/      # Screens and ViewModels by feature
│   ├── home/         # Main prayer list
│   ├── prayer/       # Detail and form screens
│   ├── people/       # Requester list
│   ├── login/
│   ├── splash/
│   └── settings/
└── shared/           # Shared widgets and utilities
    └── widgets/      # BannerAdWidget, etc.
```

### Routing: GoRouter
- Routes defined in `lib/core/router/app_router.dart`
- Key routes: `/` (splash), `/login`, `/home`, `/prayer/:id`, `/prayer/form`, `/people`, `/settings`

## Data Models

### PrayerRequestModel
- Status: `PrayerStatus.praying` or `PrayerStatus.answered`
- Categories: general, health, career, family, relationship, faith, other
- Includes `RequesterModel` via Supabase JOIN (`requesters(*)`)

### Database Tables (Supabase)
- `users` - User profiles (linked to Supabase Auth)
- `requesters` - People who request prayers
- `prayer_requests` - Prayer items with soft delete

## Key Implementation Patterns

### Supabase Query with JOIN
When fetching prayer requests, always use `select('*, requesters(*)')` to include all requester fields. Partial field selection causes parsing errors.

### Generated Files
Files ending in `.freezed.dart` and `.g.dart` are auto-generated. Run `dart run build_runner build` after modifying annotated classes.

### Environment Configuration
- `.env` - Production environment (real Supabase, real AdMob IDs)
- `.env.beta` - Development/test environment (test AdMob IDs)
- Loaded via `flutter_dotenv` in `AppConfig.loadEnv()`

**Environment Variables:**
```
SUPABASE_URL
SUPABASE_ANON_KEY
GOOGLE_WEB_CLIENT_ID
GOOGLE_IOS_CLIENT_ID
ADMOB_ANDROID_BANNER_ID
ADMOB_ANDROID_INTERSTITIAL_ID
ADMOB_IOS_BANNER_ID
ADMOB_IOS_INTERSTITIAL_ID
```

## Advertising (AdMob)

### Ad Service (`lib/data/services/ad_service.dart`)
- Singleton pattern for ad management
- Banner ads: Settings screen only
- Interstitial ads: Every 5 new prayer saves (tracked via SharedPreferences)
- ATT (App Tracking Transparency) for iOS 14.5+

### Ad Configuration
| Platform | Config File | Key |
|----------|-------------|-----|
| Android | `AndroidManifest.xml` | `com.google.android.gms.ads.APPLICATION_ID` |
| iOS | `Info.plist` | `GADApplicationIdentifier` |

### ATT (App Tracking Transparency)
- Package: `app_tracking_transparency`
- iOS Info.plist: `NSUserTrackingUsageDescription` key required
- Request shown before ad initialization on iOS

### Ad Unit IDs
- **Test IDs**: Used in `.env.beta` for development
- **Real IDs**: Used in `.env` for production
- **App ID**: Must be updated in `AndroidManifest.xml` and `Info.plist` before release

## Firebase Integration

### Services
- **Firebase Analytics**: User event tracking (`lib/data/services/analytics_service.dart`)
- **Firebase Crashlytics**: Crash reporting

### Configuration Files
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

## Authentication

### Supported Methods
- Google Sign-In
- Apple Sign-In (iOS only)

### iOS URL Scheme
Google Sign-In requires reversed client ID in `Info.plist`:
```xml
<key>CFBundleURLSchemes</key>
<array>
    <string>com.googleusercontent.apps.{CLIENT_ID}</string>
</array>
```

## Theme & Colors

### Primary Color Palette (`lib/core/config/theme/app_colors.dart`)
| Color | Hex | Usage |
|-------|-----|-------|
| Primary | `#8B7355` | Main brown |
| Accent | `#C4956A` | Gold brown (highlights, praying status) |
| Background | `#FAF8F5` | App background |
| Success | `#7A9E7E` | Sage green (answered status) |

### Design Concept
"고요한 성소" (Quiet Sanctuary) - Warm and restrained spirituality

## Git Workflow

### 자동 Commit 규칙 (Claude Code 필수)
**Claude Code는 각 작업 완료 시 사용자 확인 없이 자동으로 git commit을 진행해야 합니다.**

```bash
# 커밋 메시지 형식
git commit -m "#<type>: <description>"

# 타입 종류
# feat: 새로운 기능 추가
# fix: 버그 수정
# refactor: 코드 리팩토링
# style: UI/스타일 변경
# docs: 문서 수정
# chore: 빌드, 설정 파일 변경
```

### Commit 자동화 지침
- 기능 구현 완료 → 즉시 자동 commit
- 버그 수정 완료 → 즉시 자동 commit
- 여러 파일 수정 시 → 관련 변경사항을 하나의 commit으로 묶어서 자동 commit
- commit 전 `flutter analyze` 실행하여 오류 없음 확인 후 commit
- **사용자에게 commit 여부를 묻지 말고 바로 진행할 것**

## Release Checklist

### Before App Store Submission
- [ ] Update AdMob App ID (test → production) in `AndroidManifest.xml` and `Info.plist`
- [ ] Verify `.env` has production values
- [ ] Run `flutter analyze` and fix issues
- [ ] Test on real devices
- [ ] Prepare screenshots and App Store metadata
- [ ] Host privacy policy URL
- [ ] iOS: Test via TestFlight before submission

### Documentation
- `docs/앱 스토어 제출 항목.md` - App Store submission checklist
- `docs/PRIVACY_POLICY.md` - Privacy policy
- `docs/TERMS_OF_SERVICE.md` - Terms of service

## License

**Copyright (c) 2025 JC. All Rights Reserved.**

This project is protected under a **Proprietary License**.

- NO copying, modifying, distributing, or selling
- NO reverse engineering, decompiling, or disassembling
- NO commercial use without prior written permission

See [LICENSE](./LICENSE) for details.
