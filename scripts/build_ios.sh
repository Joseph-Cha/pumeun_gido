#!/bin/bash

# ============================================================================
# iOS App Store 배포용 빌드 스크립트
# ============================================================================
# 사용법: ./scripts/build_ios.sh [옵션]
# 옵션:
#   --clean        빌드 전 clean 실행
#   --skip-gen     코드 생성 스킵
#   --no-archive   Xcode Archive 스킵
#   --no-codesign  코드 서명 스킵 (테스트용, 배포 불가)
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

# Xcode Archives 디렉토리 (Organizer에서 보이게 하기 위함)
XCODE_ARCHIVES_DIR="$HOME/Library/Developer/Xcode/Archives/$(date +%Y-%m-%d)"

# 기본 옵션
DO_CLEAN=false
SKIP_GEN=false
DO_ARCHIVE=true
NO_CODESIGN=false

# 인자 파싱
for arg in "$@"; do
    case $arg in
        --clean)
            DO_CLEAN=true
            ;;
        --skip-gen)
            SKIP_GEN=true
            ;;
        --no-archive)
            DO_ARCHIVE=false
            ;;
        --no-codesign)
            NO_CODESIGN=true
            ;;
        --help)
            echo "사용법: ./scripts/build_ios.sh [옵션]"
            echo ""
            echo "옵션:"
            echo "  --clean        빌드 전 clean 실행"
            echo "  --skip-gen     코드 생성 스킵"
            echo "  --no-archive   Xcode Archive 스킵"
            echo "  --no-codesign  코드 서명 스킵 (테스트용, 배포 불가)"
            echo "  --help         도움말 표시"
            exit 0
            ;;
        *)
            echo -e "${RED}알 수 없는 옵션: $arg${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  품은기도 iOS 빌드 스크립트${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo -e "  앱 이름: ${APP_NAME}"
echo -e "  버전: ${VERSION_NAME} (${BUILD_NUMBER})"
echo -e "  타임스탬프: ${TIMESTAMP}"
echo ""

# ============================================================================
# 1. 환경 검증
# ============================================================================
echo -e "${YELLOW}[1/8] 환경 검증 중...${NC}"

# macOS 확인
if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}오류: iOS 빌드는 macOS에서만 가능합니다.${NC}"
    exit 1
fi
echo -e "  ✓ macOS 확인됨"

# Flutter 확인
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}오류: Flutter가 설치되어 있지 않습니다.${NC}"
    exit 1
fi
echo -e "  ✓ Flutter: $(flutter --version | head -n 1)"

# Xcode 확인
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}오류: Xcode가 설치되어 있지 않습니다.${NC}"
    exit 1
fi
XCODE_VERSION=$(xcodebuild -version | head -n 1)
echo -e "  ✓ $XCODE_VERSION"

# .env 파일 확인 (배포용)
if [ ! -f ".env" ]; then
    echo -e "${RED}오류: .env 파일이 없습니다.${NC}"
    exit 1
fi
echo -e "  ✓ .env (배포용) 확인됨"

echo ""

# ============================================================================
# 2. Clean (선택적)
# ============================================================================
if [ "$DO_CLEAN" = true ]; then
    echo -e "${YELLOW}[2/7] 프로젝트 클린 중...${NC}"
    flutter clean
    echo -e "  ✓ Clean 완료"
    echo ""
else
    echo -e "${YELLOW}[2/7] Clean 스킵${NC}"
    echo ""
fi

# ============================================================================
# 3. 의존성 설치
# ============================================================================
echo -e "${YELLOW}[3/7] 의존성 설치 중...${NC}"
flutter pub get
echo -e "  ✓ 의존성 설치 완료"
echo ""

# ============================================================================
# 4. 코드 생성 (freezed, riverpod_generator 등)
# ============================================================================
if [ "$SKIP_GEN" = true ]; then
    echo -e "${YELLOW}[4/7] 코드 생성 스킵${NC}"
    echo ""
else
    echo -e "${YELLOW}[4/7] 코드 생성 중...${NC}"
    dart run build_runner build --delete-conflicting-outputs
    echo -e "  ✓ 코드 생성 완료"
    echo ""
fi

# ============================================================================
# 5. CocoaPods 설치
# ============================================================================
echo -e "${YELLOW}[5/7] CocoaPods 설치 중...${NC}"
cd ios
pod install --repo-update
cd ..
echo -e "  ✓ CocoaPods 설치 완료"
echo ""

# ============================================================================
# 6. 빌드
# ============================================================================
echo -e "${YELLOW}[6/7] iOS 빌드 중...${NC}"

# 빌드 시작 시간
BUILD_START=$(date +%s)

# iOS Release 빌드
echo -e "  → Flutter iOS 빌드 중..."
if [ "$NO_CODESIGN" = true ]; then
    flutter build ios --release --no-codesign
else
    flutter build ios --release
fi

# 빌드 종료 시간
BUILD_END=$(date +%s)
BUILD_TIME=$((BUILD_END - BUILD_START))

echo -e "  ✓ iOS 빌드 완료"
echo ""

# ============================================================================
# 7. Xcode Archive 생성
# ============================================================================
echo -e "${YELLOW}[7/7] Xcode Archive 생성 중...${NC}"

XCARCHIVE_PATH=""

if [ "$DO_ARCHIVE" = true ]; then
    XCARCHIVE_NAME="${APP_NAME}_v${VERSION_NAME}_${BUILD_NUMBER}_${TIMESTAMP}.xcarchive"
    mkdir -p "$XCODE_ARCHIVES_DIR"
    XCARCHIVE_PATH="${XCODE_ARCHIVES_DIR}/${XCARCHIVE_NAME}"

    if [ "$NO_CODESIGN" = true ]; then
        # 코드 서명 없이 Archive (테스트용)
        xcodebuild -workspace ios/Runner.xcworkspace \
            -scheme Runner \
            -sdk iphoneos \
            -configuration Release \
            -archivePath "$XCARCHIVE_PATH" \
            archive \
            CODE_SIGN_IDENTITY="" \
            CODE_SIGNING_REQUIRED=NO \
            CODE_SIGNING_ALLOWED=NO \
            2>/dev/null || {
                echo -e "${YELLOW}  ⚠ Archive 생성 실패${NC}"
                XCARCHIVE_PATH=""
            }
    else
        # 코드 서명 포함 Archive (배포용)
        xcodebuild -workspace ios/Runner.xcworkspace \
            -scheme Runner \
            -sdk iphoneos \
            -configuration Release \
            -archivePath "$XCARCHIVE_PATH" \
            archive \
            2>&1 | tail -20 || {
                echo -e "${RED}  ⚠ Archive 생성 실패${NC}"
                echo -e "${YELLOW}  Apple Developer 인증서와 Provisioning Profile을 확인하세요.${NC}"
                echo -e "${YELLOW}  Xcode > Settings > Accounts에서 Apple ID 로그인 필요${NC}"
                XCARCHIVE_PATH=""
            }
    fi

    if [ -d "$XCARCHIVE_PATH" ]; then
        echo -e "  ✓ Xcode Archive 생성 완료"
        echo -e "  ✓ Xcode Organizer에 등록됨"
    fi
else
    echo -e "  Archive 스킵 (--no-archive 옵션)"
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

if [ -n "$XCARCHIVE_PATH" ] && [ -d "$XCARCHIVE_PATH" ]; then
    ARCHIVE_SIZE=$(du -sh "$XCARCHIVE_PATH" | cut -f1)
    echo -e "  ${GREEN}Xcode Archive:${NC}"
    echo -e "    경로: $XCARCHIVE_PATH"
    echo -e "    크기: $ARCHIVE_SIZE"
    echo ""
fi

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  다음 단계:${NC}"
echo -e "${BLUE}  1. Xcode > Window > Organizer 열기${NC}"
echo -e "${BLUE}  2. 생성된 Archive 선택${NC}"
echo -e "${BLUE}  3. Distribute App > App Store Connect 업로드${NC}"
echo -e "${BLUE}============================================${NC}"
