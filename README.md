# 품은기도 (Pumeun Gido)

![License](https://img.shields.io/badge/license-Proprietary-red)
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.9+-02569B?logo=flutter)

지인의 기도 제목을 마음에 품고 기도하는 앱

## 소개

품은기도는 친구, 가족, 지인들의 기도 제목을 기록하고 관리할 수 있는 Flutter 기반 모바일 앱입니다. 기도 요청을 체계적으로 관리하고, 응답받은 기도를 추적하여 감사의 기록을 남길 수 있습니다.

### 주요 기능

- **기도 제목 관리**: 기도 제목 등록, 수정, 삭제
- **기도 상태 추적**: 기도 중 / 응답받음 상태 관리
- **카테고리 분류**: 일반, 건강, 직장, 가정, 관계, 신앙 등 카테고리별 분류
- **중보 대상 관리**: 기도 요청자(지인) 정보 관리
- **소셜 로그인**: Google / Apple 계정으로 간편 로그인

## 스크린샷

<!-- 앱 스크린샷 추가 예정 -->

## 기술 스택

| 분류 | 기술 |
|------|------|
| **Framework** | Flutter 3.9+ |
| **Language** | Dart |
| **State Management** | Riverpod + Freezed |
| **Backend** | Supabase |
| **Authentication** | Google Sign-In, Apple Sign-In |
| **Routing** | GoRouter |
| **Analytics** | Firebase Analytics, Crashlytics |

## 앱 정보

| 플랫폼 | Bundle ID |
|--------|-----------|
| **Android** | `com.jc.pumeun_gido` |
| **iOS** | `com.jc.pumeun-gido` |

## 프로젝트 구조

```
lib/
├── core/
│   ├── config/        # 앱 설정, 테마 (색상, 텍스트 스타일)
│   ├── di/            # Riverpod 프로바이더 (서비스, 레포지토리)
│   └── router/        # GoRouter 라우팅 설정
├── data/
│   ├── models/        # 데이터 모델 (PrayerRequest, Requester, User)
│   ├── repositories/  # 데이터 접근 레이어 (인터페이스/구현)
│   └── services/      # Supabase, Auth, Analytics 서비스
├── presentation/      # 화면별 UI 및 ViewModel
│   ├── home/          # 메인 기도 목록
│   ├── prayer/        # 기도 상세/작성 화면
│   ├── people/        # 중보 대상 목록
│   ├── login/         # 로그인
│   ├── splash/        # 스플래시
│   └── settings/      # 설정
└── shared/            # 공용 위젯 및 유틸리티
```

## 시작하기

### 사전 요구 사항

- Flutter SDK 3.9.2 이상
- Dart SDK 3.9.2 이상
- Supabase 프로젝트 (환경 변수 설정 필요)
- Firebase 프로젝트 (Analytics, Crashlytics)

### 설치

1. **저장소 클론**
   ```bash
   git clone https://github.com/your-username/pumeun_gido.git
   cd pumeun_gido
   ```

2. **환경 변수 설정**

   `.env` 파일을 프로젝트 루트에 생성:
   ```
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

3. **의존성 설치**
   ```bash
   flutter pub get
   ```

4. **코드 생성 실행**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **앱 실행**
   ```bash
   flutter run
   ```

## 개발 명령어

```bash
# 의존성 설치
flutter pub get

# 코드 생성 (freezed, riverpod_generator, json_serializable)
dart run build_runner build --delete-conflicting-outputs

# 코드 생성 (watch 모드)
dart run build_runner watch --delete-conflicting-outputs

# 코드 분석
flutter analyze

# 테스트 실행
flutter test

# 앱 아이콘 생성
dart run flutter_launcher_icons
```

## 배포 빌드

빌드 결과물은 `archive/` 폴더에 버전 및 타임스탬프가 포함된 이름으로 저장됩니다.

### 파일명 규칙

**형식:** `{앱이름}_v{버전}_{빌드번호}_{타임스탬프}.{확장자}`

| 구성요소 | 설명 | 예시 |
|----------|------|------|
| 앱이름 | 프로젝트 이름 | `pumeun_gido` |
| 버전 | pubspec.yaml의 version (+ 앞부분) | `1.0.0` |
| 빌드번호 | pubspec.yaml의 version (+ 뒷부분) | `1` |
| 타임스탬프 | 빌드 시간 (YYYYMMDD_HHMMSS) | `20241215_143052` |
| 확장자 | 빌드 타입에 따른 확장자 | `aab`, `apk`, `xcarchive`, `app` |

**빌드 결과물 예시:**

| 플랫폼 | 타입 | 파일명 |
|--------|------|--------|
| Android | App Bundle | `pumeun_gido_v1.0.0_1_20241215_143052.aab` |
| Android | APK | `pumeun_gido_v1.0.0_1_20241215_143052.apk` |
| iOS | Xcode Archive | `pumeun_gido_v1.0.0_1_20241215_143052.xcarchive` |
| iOS | Runner App | `pumeun_gido_v1.0.0_1_20241215_143052.app` |

### Android (Google Play Store)

```bash
# 기본 실행 (App Bundle 생성)
./scripts/build_android.sh

# App Bundle + APK 모두 생성
./scripts/build_android.sh --all

# Clean 후 빌드
./scripts/build_android.sh --clean

# 코드 생성 스킵 (이미 생성된 경우)
./scripts/build_android.sh --skip-gen
```

**옵션:**
| 옵션 | 설명 |
|------|------|
| `--aab-only` | App Bundle만 생성 (기본값) |
| `--apk-only` | APK만 생성 |
| `--all` | App Bundle과 APK 모두 생성 |
| `--clean` | 빌드 전 clean 실행 |
| `--skip-gen` | 코드 생성 스킵 |

**빌드 결과물:** `archive/android/`

> **참고:** 빌드 전 `android/key.properties` 파일에 키스토어 설정이 필요합니다.

### iOS (App Store)

```bash
# 기본 실행
./scripts/build_ios.sh

# Clean 후 빌드
./scripts/build_ios.sh --clean

# 코드 생성 스킵
./scripts/build_ios.sh --skip-gen

# Xcode Archive 스킵
./scripts/build_ios.sh --no-archive
```

**옵션:**
| 옵션 | 설명 |
|------|------|
| `--clean` | 빌드 전 clean 실행 |
| `--skip-gen` | 코드 생성 스킵 |
| `--no-archive` | Xcode Archive 스킵 |
| `--no-codesign` | 코드 서명 스킵 (테스트용, 배포 불가) |

**빌드 결과물:**
- Xcode Organizer: `~/Library/Developer/Xcode/Archives/YYYY-MM-DD/`

> **참고:** iOS 빌드는 macOS에서만 가능합니다. 빌드 완료 후 Xcode > Window > Organizer에서 Archive를 선택하여 App Store Connect에 업로드할 수 있습니다.

## 데이터 모델

### PrayerRequest (기도 제목)
- `id`: 고유 식별자
- `title`: 기도 제목
- `content`: 상세 내용
- `status`: 기도 상태 (praying / answered)
- `category`: 카테고리 (general, health, career, family, relationship, faith, other)
- `requester`: 기도 요청자 정보

### Requester (중보 대상)
- `id`: 고유 식별자
- `name`: 이름
- `profileImageUrl`: 프로필 이미지 (선택)

## 라이선스

**Copyright (c) 2025 JC. All Rights Reserved.**

이 프로젝트는 **독점 라이선스(Proprietary License)** 하에 보호됩니다.

- 무단 복제, 수정, 배포, 판매 금지
- 역공학, 디컴파일, 역어셈블 금지
- 사전 서면 허가 없이 상업적 사용 금지

자세한 내용은 [LICENSE](./LICENSE) 파일을 참조하세요.

## 문의

라이선스 관련 문의 또는 프로젝트에 대한 질문이 있으시면 이슈를 등록해 주세요.
