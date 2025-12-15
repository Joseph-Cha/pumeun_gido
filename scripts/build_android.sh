#!/bin/bash

# ============================================================================
# Android 스토어 배포용 빌드 스크립트
# ============================================================================
# 사용법: ./scripts/build_android.sh [옵션]
# 옵션:
#   --aab-only    App Bundle만 생성 (기본값)
#   --apk-only    APK만 생성
#   --all         App Bundle과 APK 모두 생성
#   --clean       빌드 전 clean 실행
#   --skip-gen    코드 생성 스킵
# ============================================================================

set -e  # 오류 발생 시 스크립트 중단

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 프로젝트 루트 디렉토리로 이동
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

# 앱 정보 추출
APP_NAME="pumeun_gido"
VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //' | tr -d '[:space:]')
VERSION_NAME=$(echo $VERSION | cut -d'+' -f1)
BUILD_NUMBER=$(echo $VERSION | cut -d'+' -f2)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# archive 디렉토리
ARCHIVE_DIR="$PROJECT_ROOT/archive/android"

# 기본 옵션
BUILD_AAB=true
BUILD_APK=false
DO_CLEAN=false
SKIP_GEN=false

# 인자 파싱
for arg in "$@"; do
    case $arg in
        --aab-only)
            BUILD_AAB=true
            BUILD_APK=false
            ;;
        --apk-only)
            BUILD_AAB=false
            BUILD_APK=true
            ;;
        --all)
            BUILD_AAB=true
            BUILD_APK=true
            ;;
        --clean)
            DO_CLEAN=true
            ;;
        --skip-gen)
            SKIP_GEN=true
            ;;
        --help)
            echo "사용법: ./scripts/build_android.sh [옵션]"
            echo ""
            echo "옵션:"
            echo "  --aab-only    App Bundle만 생성 (기본값)"
            echo "  --apk-only    APK만 생성"
            echo "  --all         App Bundle과 APK 모두 생성"
            echo "  --clean       빌드 전 clean 실행"
            echo "  --skip-gen    코드 생성 스킵"
            echo "  --help        도움말 표시"
            exit 0
            ;;
        *)
            echo -e "${RED}알 수 없는 옵션: $arg${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  품은기도 Android 빌드 스크립트${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo -e "  앱 이름: ${APP_NAME}"
echo -e "  버전: ${VERSION_NAME} (${BUILD_NUMBER})"
echo -e "  타임스탬프: ${TIMESTAMP}"
echo ""

# ============================================================================
# 1. 환경 검증
# ============================================================================
echo -e "${YELLOW}[1/7] 환경 검증 중...${NC}"

# Flutter 확인
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}오류: Flutter가 설치되어 있지 않습니다.${NC}"
    exit 1
fi
echo -e "  ✓ Flutter: $(flutter --version | head -n 1)"

# key.properties 확인
if [ ! -f "android/key.properties" ]; then
    echo -e "${RED}오류: android/key.properties 파일이 없습니다.${NC}"
    echo -e "${YELLOW}키스토어 설정이 필요합니다.${NC}"
    exit 1
fi
echo -e "  ✓ key.properties 확인됨"

# .env 파일 확인 (배포용)
if [ ! -f ".env" ]; then
    echo -e "${RED}오류: .env 파일이 없습니다.${NC}"
    exit 1
fi
echo -e "  ✓ .env (배포용) 확인됨"

echo ""

# ============================================================================
# 2. Archive 디렉토리 생성
# ============================================================================
echo -e "${YELLOW}[2/7] Archive 디렉토리 준비 중...${NC}"
mkdir -p "$ARCHIVE_DIR"
echo -e "  ✓ $ARCHIVE_DIR"
echo ""

# ============================================================================
# 3. Clean (선택적)
# ============================================================================
if [ "$DO_CLEAN" = true ]; then
    echo -e "${YELLOW}[3/7] 프로젝트 클린 중...${NC}"
    flutter clean
    echo -e "  ✓ Clean 완료"
    echo ""
else
    echo -e "${YELLOW}[3/7] Clean 스킵${NC}"
    echo ""
fi

# ============================================================================
# 4. 의존성 설치
# ============================================================================
echo -e "${YELLOW}[4/7] 의존성 설치 중...${NC}"
flutter pub get
echo -e "  ✓ 의존성 설치 완료"
echo ""

# ============================================================================
# 5. 코드 생성 (freezed, riverpod_generator 등)
# ============================================================================
if [ "$SKIP_GEN" = true ]; then
    echo -e "${YELLOW}[5/7] 코드 생성 스킵${NC}"
    echo ""
else
    echo -e "${YELLOW}[5/7] 코드 생성 중...${NC}"
    dart run build_runner build --delete-conflicting-outputs
    echo -e "  ✓ 코드 생성 완료"
    echo ""
fi

# ============================================================================
# 6. 빌드
# ============================================================================
echo -e "${YELLOW}[6/7] 빌드 중...${NC}"

# 빌드 시작 시간
BUILD_START=$(date +%s)

# App Bundle 빌드
if [ "$BUILD_AAB" = true ]; then
    echo -e "  → App Bundle (.aab) 빌드 중..."
    flutter build appbundle --release
    echo -e "  ✓ App Bundle 빌드 완료"
fi

# APK 빌드
if [ "$BUILD_APK" = true ]; then
    echo -e "  → APK 빌드 중..."
    flutter build apk --release
    echo -e "  ✓ APK 빌드 완료"
fi

# 빌드 종료 시간
BUILD_END=$(date +%s)
BUILD_TIME=$((BUILD_END - BUILD_START))

echo ""

# ============================================================================
# 7. 결과물 복사 및 이름 변경
# ============================================================================
echo -e "${YELLOW}[7/7] 빌드 결과물 정리 중...${NC}"

AAB_ARCHIVED=""
APK_ARCHIVED=""

if [ "$BUILD_AAB" = true ]; then
    AAB_SRC="build/app/outputs/bundle/release/app-release.aab"
    if [ -f "$AAB_SRC" ]; then
        AAB_DEST="${ARCHIVE_DIR}/${APP_NAME}_v${VERSION_NAME}_${BUILD_NUMBER}_${TIMESTAMP}.aab"
        cp "$AAB_SRC" "$AAB_DEST"
        AAB_ARCHIVED="$AAB_DEST"
        echo -e "  ✓ App Bundle 복사 완료"
    fi
fi

if [ "$BUILD_APK" = true ]; then
    APK_SRC="build/app/outputs/flutter-apk/app-release.apk"
    if [ -f "$APK_SRC" ]; then
        APK_DEST="${ARCHIVE_DIR}/${APP_NAME}_v${VERSION_NAME}_${BUILD_NUMBER}_${TIMESTAMP}.apk"
        cp "$APK_SRC" "$APK_DEST"
        APK_ARCHIVED="$APK_DEST"
        echo -e "  ✓ APK 복사 완료"
    fi
fi

echo ""

# ============================================================================
# 결과 출력
# ============================================================================
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  빌드 완료!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "  빌드 시간: ${BUILD_TIME}초"
echo ""

if [ -n "$AAB_ARCHIVED" ]; then
    AAB_SIZE=$(du -h "$AAB_ARCHIVED" | cut -f1)
    echo -e "  ${GREEN}App Bundle:${NC}"
    echo -e "    경로: $AAB_ARCHIVED"
    echo -e "    크기: $AAB_SIZE"
    echo ""
fi

if [ -n "$APK_ARCHIVED" ]; then
    APK_SIZE=$(du -h "$APK_ARCHIVED" | cut -f1)
    echo -e "  ${GREEN}APK:${NC}"
    echo -e "    경로: $APK_ARCHIVED"
    echo -e "    크기: $APK_SIZE"
    echo ""
fi

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Google Play Console에 업로드하세요!${NC}"
echo -e "${BLUE}  https://play.google.com/console${NC}"
echo -e "${BLUE}============================================${NC}"
