# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**품은기도 (Pumeun Gido)** - A Flutter prayer management app that helps users organize prayer requests from friends and track answered prayers. Built with Supabase backend and Google authentication.

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
│   └── services/      # SupabaseService, AuthService
├── presentation/      # Screens and ViewModels by feature
│   ├── home/         # Main prayer list
│   ├── prayer/       # Detail and form screens
│   ├── people/       # Requester list
│   ├── login/
│   ├── splash/
│   └── settings/
└── shared/           # Shared widgets and utilities
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
- `.env` and `.env.beta` files for Supabase credentials
- Loaded via `flutter_dotenv` in `AppConfig.loadEnv()`
