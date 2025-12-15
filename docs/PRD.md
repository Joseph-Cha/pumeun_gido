# 품은기도 - Product Requirements Document (PRD)

## 1. 개요

### 1.1 제품명
**품은기도** (Pumeun Gido)

### 1.2 한 줄 정의
지인으로부터 전달받은 기도 제목을 체계적으로 정리하고 관리하는 기도 동반자 앱

### 1.3 배경 및 문제 정의

**현재 상황:**
- 교회 청년부 성도들은 셀 모임, 소그룹, 개인 대화 등에서 다양한 기도 제목을 전달받음
- 기도 제목을 메모장, 카카오톡 나에게 보내기, 종이 노트 등 분산된 곳에 기록
- 시간이 지나면 누구의 기도 제목인지, 언제 받았는지 기억하기 어려움
- 기도 응답 여부를 추적하기 어려움

**해결하고자 하는 문제:**
1. 기도 제목의 분산 저장으로 인한 관리 어려움
2. 기도 제목과 요청자 정보의 연결 부재
3. 기도 응답 및 진행 상황 추적 불가
4. 정기적인 기도 습관 형성의 어려움

### 1.4 목표

**MVP 목표 (4주):**
- 기도 제목 CRUD 기능 구현
- 요청자별 기도 제목 분류
- Google 로그인을 통한 데이터 동기화
- 기본적인 기도 응답 체크 기능

**성공 지표:**
| 지표 | 목표 | 측정 방법 |
|------|------|-----------|
| DAU | 50명 | Supabase Analytics |
| 기도 제목 등록 수 | 평균 3개/주/사용자 | DB 쿼리 |
| 7일 리텐션 | 40% | 코호트 분석 |
| 앱 스토어 평점 | 4.0 이상 | 스토어 리뷰 |

---

## 2. 타겟 사용자

### 2.1 주요 페르소나
ㅇ
**페르소나 1: 셀 리더 민준 (27세)**
- 역할: 청년부 셀 그룹 리더
- 상황: 매주 8명의 셀원들의 기도 제목을 받아 기도함
- 니즈: 셀원별로 기도 제목을 정리하고, 응답받은 기도를 기록하고 싶음
- 불편함: 카톡에서 기도 제목 찾느라 시간 낭비, 예전 기도 제목이 묻힘

**페르소나 2: 일반 성도 수진 (24세)**
- 역할: 청년부 일반 성도
- 상황: 친한 지인 3-4명의 기도 제목을 마음에 품고 기도함
- 니즈: 간단하게 기도 제목을 기록하고 매일 확인하고 싶음
- 불편함: 기도하다가 기도 제목을 까먹음

### 2.2 타겟 사용자 특성

| 특성 | 내용 |
|------|------|
| 연령대 | 20-35세 |
| 종교 | 기독교 (개신교) |
| 소속 | 교회 청년부/청장년부 |
| 기기 | 스마트폰 (Android/iOS) |
| 기술 친숙도 | 높음 |

---

## 3. 기능 명세

### 3.1 정보 구조 (IA)

```
품은기도
├── 홈 (기도 목록)
│   ├── 전체 기도 제목
│   ├── 기도 중 / 응답됨 필터
│   └── 기도 제목 검색
├── 기도 제목 상세
│   ├── 기도 제목 내용
│   ├── 요청자 정보
│   ├── 등록일 / 상태
│   └── 메모
├── 사람 목록
│   ├── 요청자 목록
│   └── 요청자별 기도 제목
├── 기도 제목 추가/수정
│   ├── 요청자 선택/추가
│   ├── 기도 제목 입력
│   └── 카테고리 선택
└── 설정
    ├── 계정 정보
    ├── 알림 설정
    └── 로그아웃
```

### 3.2 핵심 기능 (MVP)

#### F1. 사용자 인증
| 항목 | 내용 |
|------|------|
| 우선순위 | P0 (필수) |
| 설명 | Google 소셜 로그인을 통한 사용자 인증 |
| 상세 요구사항 | - Google OAuth 2.0 사용<br>- 최초 로그인 시 사용자 프로필 생성<br>- 로그인 상태 유지 (자동 로그인)<br>- 로그아웃 기능 |

#### F2. 기도 제목 관리 (CRUD)
| 항목 | 내용 |
|------|------|
| 우선순위 | P0 (필수) |
| 설명 | 기도 제목 생성, 조회, 수정, 삭제 |
| 상세 요구사항 | - 기도 제목 텍스트 입력 (최대 500자)<br>- 요청자 연결 (필수)<br>- 카테고리 선택 (선택)<br>- 기도 상태 변경 (기도 중/응답됨)<br>- 등록일 자동 기록<br>- 메모 추가 기능 |

#### F3. 요청자 관리
| 항목 | 내용 |
|------|------|
| 우선순위 | P0 (필수) |
| 설명 | 기도 제목을 전달한 사람 정보 관리 |
| 상세 요구사항 | - 요청자 이름 입력<br>- 요청자 목록 조회<br>- 요청자별 기도 제목 필터링<br>- 요청자 정보 수정/삭제 |

#### F4. 기도 목록 조회
| 항목 | 내용 |
|------|------|
| 우선순위 | P0 (필수) |
| 설명 | 등록된 기도 제목 목록 조회 |
| 상세 요구사항 | - 전체 기도 제목 리스트<br>- 상태별 필터 (전체/기도 중/응답됨)<br>- 최신순 정렬<br>- 기도 제목 검색 |

### 3.3 추가 기능 (Post-MVP)

| 기능 | 우선순위 | 설명 |
|------|----------|------|
| 기도 알림 | P1 | 매일 정해진 시간에 기도 알림 푸시 |
| 카테고리 관리 | P1 | 사용자 정의 카테고리 생성 |
| 기도 통계 | P2 | 월별 기도 제목 수, 응답률 등 |
| 그룹 기능 | P2 | 셀/소그룹 단위 기도 제목 공유 |
| 기도 일지 | P2 | 기도한 날짜 및 내용 기록 |
| 오프라인 모드 | P2 | 인터넷 없이도 기본 기능 사용 |

---

## 4. 화면 설계

### 4.1 화면 흐름

```
[스플래시] → [로그인] → [홈(기도 목록)]
                              ↓
              ┌───────────────┼───────────────┐
              ↓               ↓               ↓
        [기도 상세]     [사람 목록]        [설정]
              ↓               ↓
        [기도 수정]     [사람별 기도 목록]

[홈] → [기도 추가] → [요청자 선택/추가] → [저장] → [홈]
```

### 4.2 주요 화면 상세

#### 화면 1: 스플래시
- 앱 로고 표시
- 자동 로그인 체크
- 로그인 상태면 홈으로, 아니면 로그인 화면으로 이동

#### 화면 2: 로그인
- 앱 로고 및 슬로건
- "Google로 로그인" 버튼
- 개인정보 처리방침 링크

#### 화면 3: 홈 (기도 목록)
- 상단: 앱 로고, 설정 아이콘
- 필터 탭: 전체 | 기도 중 | 응답됨
- 검색바
- 기도 목록 (카드 형태)
  - 요청자 이름
  - 기도 제목 (2줄 말줄임)
  - 등록일
  - 상태 표시
- 하단 FAB: 기도 제목 추가

#### 화면 4: 기도 제목 상세
- 요청자 정보
- 기도 제목 전문
- 등록일
- 상태 변경 버튼 (기도 중 ↔ 응답됨)
- 메모 영역
- 수정/삭제 버튼

#### 화면 5: 기도 제목 추가/수정
- 요청자 선택 (드롭다운/검색)
- 새 요청자 추가 버튼
- 기도 제목 텍스트 입력
- 카테고리 선택 (선택사항)
- 저장 버튼

#### 화면 6: 사람 목록
- 요청자 목록 (알파벳/가나다순)
- 각 요청자의 기도 제목 수 표시
- 요청자 탭 시 해당 요청자의 기도 목록으로 이동

#### 화면 7: 설정
- 프로필 정보 (Google 계정)
- 알림 설정 (On/Off)
- 앱 버전
- 개인정보 처리방침
- 로그아웃

---

## 5. 데이터 모델

### 5.1 ERD

```
┌─────────────┐       ┌─────────────────┐       ┌─────────────┐
│   users     │       │  prayer_requests │       │  requesters │
├─────────────┤       ├─────────────────┤       ├─────────────┤
│ id (PK)     │──────<│ user_id (FK)    │       │ id (PK)     │
│ email       │       │ id (PK)         │>──────│ user_id (FK)│
│ name        │       │ requester_id(FK)│       │ name        │
│ avatar_url  │       │ title           │       │ created_at  │
│ created_at  │       │ content         │       │ updated_at  │
│ updated_at  │       │ category        │       │ deleted_at  │
│ deleted_at  │       │ status          │       └─────────────┘
└─────────────┘       │ memo            │
                      │ created_at      │
                      │ updated_at      │
                      │ deleted_at      │
                      │ answered_at     │
                      └─────────────────┘
```

### 5.2 테이블 상세

#### users
| 컬럼 | 타입 | 필수 | 기본값 | 설명 |
|------|------|------|--------|------|
| id | uuid | Y | - | PK, Supabase Auth UID |
| email | varchar(255) | Y | - | Google 이메일 |
| name | varchar(100) | Y | - | 사용자 이름 |
| avatar_url | varchar(500) | N | NULL | 프로필 이미지 URL |
| created_at | timestamptz | Y | now() | 생성일시 |
| updated_at | timestamptz | Y | now() | 수정일시 |
| deleted_at | timestamptz | N | NULL | 삭제일시 (Soft Delete) |

#### requesters
| 컬럼 | 타입 | 필수 | 기본값 | 설명 |
|------|------|------|--------|------|
| id | uuid | Y | gen_random_uuid() | PK |
| user_id | uuid | Y | - | FK → users.id (ON DELETE CASCADE) |
| name | varchar(50) | Y | - | 요청자 이름 |
| created_at | timestamptz | Y | now() | 생성일시 |
| updated_at | timestamptz | Y | now() | 수정일시 |
| deleted_at | timestamptz | N | NULL | 삭제일시 (Soft Delete) |

**제약조건**:
- `UNIQUE(user_id, name)` WHERE deleted_at IS NULL - 동일 사용자 내 요청자 이름 중복 방지

#### prayer_requests
| 컬럼 | 타입 | 필수 | 기본값 | 설명 |
|------|------|------|--------|------|
| id | uuid | Y | gen_random_uuid() | PK |
| user_id | uuid | Y | - | FK → users.id (ON DELETE CASCADE) |
| requester_id | uuid | Y | - | FK → requesters.id (ON DELETE RESTRICT) |
| title | varchar(100) | N | NULL | 기도 제목 요약 |
| content | text | Y | - | 기도 제목 내용 (최대 2000자) |
| category | varchar(20) | N | 'general' | 카테고리 |
| status | varchar(20) | Y | 'praying' | 상태: 'praying', 'answered' |
| memo | text | N | NULL | 메모 (최대 1000자) |
| created_at | timestamptz | Y | now() | 생성일시 |
| updated_at | timestamptz | Y | now() | 수정일시 |
| deleted_at | timestamptz | N | NULL | 삭제일시 (Soft Delete) |
| answered_at | timestamptz | N | NULL | 응답일시 (status가 answered로 변경될 때) |

**카테고리 허용값** (MVP):
- `general` (일반)
- `health` (건강)
- `career` (진로/직장)
- `family` (가정)
- `relationship` (관계)
- `faith` (신앙)
- `other` (기타)

### 5.3 삭제 정책

| 엔티티 | 삭제 방식 | 연관 데이터 처리 |
|--------|-----------|------------------|
| users | Soft Delete | 모든 하위 데이터 Soft Delete (CASCADE) |
| requesters | Soft Delete | 기도 제목이 있으면 삭제 불가 (RESTRICT) |
| prayer_requests | Soft Delete | - |

**요청자 삭제 규칙**:
1. 해당 요청자의 기도 제목이 0개일 때만 삭제 가능
2. 기도 제목이 있는 경우 → 에러 메시지: "이 분의 기도 제목이 있어 삭제할 수 없습니다"
3. 삭제 대신 이름 변경을 권장

### 5.4 인덱스 설계

```sql
-- 기도 제목 조회 최적화
CREATE INDEX idx_prayer_requests_user_status
  ON prayer_requests(user_id, status)
  WHERE deleted_at IS NULL;

CREATE INDEX idx_prayer_requests_user_requester
  ON prayer_requests(user_id, requester_id)
  WHERE deleted_at IS NULL;

CREATE INDEX idx_prayer_requests_user_created
  ON prayer_requests(user_id, created_at DESC)
  WHERE deleted_at IS NULL;

-- 요청자 조회 최적화
CREATE INDEX idx_requesters_user_id
  ON requesters(user_id)
  WHERE deleted_at IS NULL;

-- 전문 검색 (PostgreSQL)
CREATE INDEX idx_prayer_requests_content_search
  ON prayer_requests USING gin(to_tsvector('korean', content))
  WHERE deleted_at IS NULL;
```

### 5.5 RLS (Row Level Security) 정책

```sql
-- users 테이블
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

-- requesters 테이블
ALTER TABLE requesters ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own requesters" ON requesters
  FOR ALL USING (auth.uid() = user_id);

-- prayer_requests 테이블
ALTER TABLE prayer_requests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own prayer requests" ON prayer_requests
  FOR ALL USING (auth.uid() = user_id);
```

---

## 6. 기술 스택

### 6.1 프론트엔드
| 항목 | 기술 | 버전 |
|------|------|------|
| Framework | Flutter | 3.x (Stable) |
| 상태 관리 | GetX | Latest |
| HTTP Client | Supabase Flutter SDK | Latest |
| 로컬 저장소 | SharedPreferences | Latest |

### 6.2 백엔드
| 항목 | 기술 | 비고 |
|------|------|------|
| BaaS | Supabase | 인증, DB, Storage |
| Database | PostgreSQL | Supabase 내장 |
| Authentication | Supabase Auth | Google OAuth |
| API | Supabase REST API | 자동 생성 |

### 6.3 인프라
| 항목 | 기술 |
|------|------|
| 앱 배포 | Google Play Store, Apple App Store |
| 크래시 리포팅 | Firebase Crashlytics (필수) |
| Analytics | Firebase Analytics |
| 로깅 | Supabase Logs |

### 6.4 모니터링 및 로깅 전략

#### 6.4.1 크래시 리포팅 (Firebase Crashlytics)
**필수 수집 항목**:
- 크래시 스택 트레이스
- 기기 정보 (OS 버전, 기기 모델)
- 앱 버전
- 사용자 행동 경로 (Breadcrumbs)

**설정**:
```dart
// 비치명적 에러도 기록
FirebaseCrashlytics.instance.recordError(exception, stackTrace);

// 사용자 식별 (익명화된 ID)
FirebaseCrashlytics.instance.setUserIdentifier(userId);
```

#### 6.4.2 이벤트 로깅 (Firebase Analytics)
| 이벤트 | 트리거 | 파라미터 |
|--------|--------|----------|
| `login` | 로그인 성공 | method: 'google' |
| `sign_up` | 회원가입 완료 | method: 'google' |
| `prayer_create` | 기도 제목 생성 | category |
| `prayer_answer` | 기도 응답 체크 | days_since_created |
| `search` | 검색 실행 | search_term (해시화) |
| `screen_view` | 화면 진입 | screen_name |

#### 6.4.3 API 로깅 (Supabase Logs)
**자동 수집 항목**:
- 모든 API 요청/응답
- 인증 이벤트 (로그인, 로그아웃, 토큰 갱신)
- RLS 정책 위반 시도

**보존 기간**: 7일 (무료 티어)

#### 6.4.4 알림 설정
| 조건 | 알림 채널 | 임계값 |
|------|-----------|--------|
| 크래시 급증 | 이메일/Slack | 1시간 내 10건 이상 |
| API 에러율 증가 | 이메일 | 5% 이상 |
| 로그인 실패 급증 | 이메일 | 1분 내 20건 이상 |

---

## 7. API 명세 (Supabase)

### 7.1 인증

#### 7.1.1 Google 로그인
```
POST /auth/v1/token?grant_type=id_token
Header: Content-Type: application/json
Body: {
  "provider": "google",
  "id_token": "{google_id_token}"
}
Response: {
  "access_token": "...",
  "refresh_token": "...",
  "expires_in": 3600,
  "user": { ... }
}
```

#### 7.1.2 토큰 갱신
```
POST /auth/v1/token?grant_type=refresh_token
Body: { "refresh_token": "{refresh_token}" }
```

#### 7.1.3 로그아웃
```
POST /auth/v1/logout
Header: Authorization: Bearer {access_token}
```

#### 7.1.4 회원 탈퇴
```
DELETE /auth/v1/user
Header: Authorization: Bearer {access_token}
- 사용자 인증 정보 삭제
- 연관 데이터는 DB Trigger로 Soft Delete 처리
```

### 7.2 기도 제목

#### 7.2.1 목록 조회
```
GET /rest/v1/prayer_requests
  ?deleted_at=is.null
  &order=created_at.desc
  &limit={limit}
  &offset={offset}

Header: Authorization: Bearer {access_token}

# 상태별 필터링
&status=eq.praying
&status=eq.answered

# 요청자별 필터링
&requester_id=eq.{requester_id}

# 검색 (내용 기준)
&content=ilike.*{keyword}*

# 요청자 정보 포함 (JOIN)
&select=*,requesters(id,name)
```

#### 7.2.2 상세 조회
```
GET /rest/v1/prayer_requests
  ?id=eq.{id}
  &deleted_at=is.null
  &select=*,requesters(id,name)
```

#### 7.2.3 생성
```
POST /rest/v1/prayer_requests
Header: Content-Type: application/json
Body: {
  "requester_id": "uuid",
  "content": "기도 제목 내용",
  "title": "제목 (선택)",
  "category": "health",
  "memo": "메모 (선택)"
}
```

#### 7.2.4 수정
```
PATCH /rest/v1/prayer_requests?id=eq.{id}
Body: {
  "content": "수정된 내용",
  "status": "answered",
  "answered_at": "2025-01-01T00:00:00Z"  // status가 answered일 때
}
```

#### 7.2.5 삭제 (Soft Delete)
```
PATCH /rest/v1/prayer_requests?id=eq.{id}
Body: { "deleted_at": "2025-01-01T00:00:00Z" }
```

### 7.3 요청자

#### 7.3.1 목록 조회
```
GET /rest/v1/requesters
  ?deleted_at=is.null
  &order=name.asc

# 기도 제목 수 포함 (집계)
&select=*,prayer_requests(count)
```

#### 7.3.2 생성
```
POST /rest/v1/requesters
Body: { "name": "요청자 이름" }
```

#### 7.3.3 수정
```
PATCH /rest/v1/requesters?id=eq.{id}
Body: { "name": "수정된 이름" }
```

#### 7.3.4 삭제 (Soft Delete)
```
-- 기도 제목이 없는 경우만 삭제 가능
-- 클라이언트에서 사전 체크 필요

PATCH /rest/v1/requesters?id=eq.{id}
Body: { "deleted_at": "2025-01-01T00:00:00Z" }
```

### 7.4 공통 응답 형식

#### 성공 응답
```json
{
  "data": [...],
  "count": 100
}
```

#### 에러 응답
```json
{
  "code": "PGRST116",
  "message": "The result contains 0 rows",
  "details": null,
  "hint": null
}
```

### 7.5 페이지네이션

| 파라미터 | 설명 | 기본값 |
|----------|------|--------|
| limit | 한 페이지당 항목 수 | 20 |
| offset | 시작 위치 | 0 |
| order | 정렬 기준 | created_at.desc |

**예시**: 2페이지 조회 (페이지당 20개)
```
GET /rest/v1/prayer_requests?limit=20&offset=20
```

---

## 8. 비기능 요구사항

### 8.1 성능

| 항목 | 목표 | 측정 조건 |
|------|------|-----------|
| Cold Start | 5초 이내 | 앱 강제 종료 후 첫 실행 |
| Warm Start | 2초 이내 | 백그라운드에서 복귀 |
| 화면 전환 | 300ms 이내 | 네트워크 요청 제외 |
| API 응답 | 500ms 이내 | P95 기준 |
| 목록 스크롤 | 60fps 유지 | 100개 항목 기준 |
| 앱 크기 | 30MB 이내 | 설치 후 용량 |

### 8.2 보안

#### 8.2.1 통신 보안
- 모든 통신 HTTPS (TLS 1.2+)
- Certificate Pinning (선택, Post-MVP)
- API Key는 환경 변수로 관리 (코드에 하드코딩 금지)

#### 8.2.2 인증/인가
- Supabase RLS(Row Level Security) 적용
- 사용자는 자신의 데이터만 접근 가능
- Access Token 만료: 1시간
- Refresh Token 만료: 7일

#### 8.2.3 Rate Limiting
| 항목 | 제한 |
|------|------|
| 로그인 시도 | 5회/분 |
| API 호출 | 100회/분/사용자 |
| 회원 탈퇴 | 1회/일 |

#### 8.2.4 입력 검증
| 필드 | 검증 규칙 |
|------|-----------|
| 기도 제목 | 최대 2000자, HTML 태그 제거 (XSS 방지) |
| 요청자 이름 | 최대 50자, 특수문자 제한 (알파벳, 한글, 숫자, 공백만) |
| 메모 | 최대 1000자, HTML 태그 제거 |

#### 8.2.5 데이터 보호
- 기도 제목은 민감한 개인 정보 포함 가능
- Supabase 기본 암호화 적용 (at-rest encryption)
- 백업 데이터 암호화

### 8.3 접근성
- 최소 터치 타겟 48x48dp
- 명확한 색상 대비 (WCAG 2.1 AA 기준, 4.5:1 이상)
- 스크린 리더 지원 (Semantic Label 적용)
- 다크 모드 지원 (Post-MVP)

### 8.4 에러 처리

#### 8.4.1 네트워크 에러
| 상황 | UX 처리 |
|------|---------|
| 네트워크 끊김 | "인터넷 연결을 확인해주세요" 토스트 + 재시도 버튼 |
| 서버 에러 (5xx) | "잠시 후 다시 시도해주세요" 토스트 |
| 타임아웃 (10초) | "응답이 늦어지고 있어요" + 재시도 버튼 |

#### 8.4.2 인증 에러
| 상황 | UX 처리 |
|------|---------|
| Access Token 만료 | 자동으로 Refresh Token으로 갱신 시도 |
| Refresh Token 만료 | 로그인 화면으로 이동 + "다시 로그인해주세요" |
| 세션 충돌 | "다른 기기에서 로그인되었습니다" 알림 |

#### 8.4.3 데이터 에러
| 상황 | UX 처리 |
|------|---------|
| 데이터 0건 | Empty State UI 표시 + 추가 유도 CTA |
| 삭제된 데이터 접근 | "삭제되었거나 존재하지 않는 항목입니다" |
| 요청자 삭제 불가 | "이 분의 기도 제목이 있어 삭제할 수 없어요" |
| 중복 요청자 이름 | "이미 등록된 이름이에요" |

#### 8.4.4 입력 검증 에러
| 상황 | UX 처리 |
|------|---------|
| 필수 필드 누락 | 해당 필드 하단에 "필수 입력 항목입니다" 표시 |
| 글자 수 초과 | 실시간 카운터 표시 + 입력 제한 |
| 잘못된 형식 | 해당 필드 하단에 구체적 안내 메시지 |

### 8.5 Empty State 정의

| 화면 | Empty State 메시지 | CTA |
|------|-------------------|-----|
| 기도 목록 (전체) | "아직 등록된 기도 제목이 없어요" | "첫 기도 제목 추가하기" 버튼 |
| 기도 목록 (기도 중) | "기도 중인 제목이 없어요" | - |
| 기도 목록 (응답됨) | "응답된 기도가 없어요" | - |
| 검색 결과 | "'{검색어}'에 대한 결과가 없어요" | "전체 목록 보기" 링크 |
| 사람 목록 | "아직 등록된 분이 없어요" | "기도 제목을 추가하면 자동으로 등록돼요" 안내 |

---

## 9. 출시 계획

### 9.1 MVP 범위
- 사용자 인증 (Google 로그인)
- 기도 제목 CRUD
- 요청자 관리
- 기도 목록 조회 및 필터링
- 기본 설정 화면
- 회원 탈퇴 기능

### 9.2 마일스톤

| 단계 | 내용 |
|------|------|
| M1 | 프로젝트 셋업, Supabase 연동, 인증 구현 |
| M2 | 기도 제목 CRUD, 요청자 관리 구현 |
| M3 | UI 완성, 필터/검색 기능 |
| M4 | QA, 버그 수정, 스토어 출시 준비 |

### 9.3 출시 체크리스트

#### 공통
- [ ] 개인정보 처리방침 문서 작성
- [ ] 서비스 이용약관 문서 작성
- [ ] 앱 아이콘 제작 (1024x1024)
- [ ] 스토어 스크린샷 준비 (각 플랫폼별)
- [ ] 앱 설명 문구 작성 (한국어)
- [ ] Firebase 프로젝트 설정 완료
- [ ] Supabase 프로덕션 환경 설정

#### Google Play Store
- [ ] Google Play Console 개발자 계정 ($25 일회성)
- [ ] 앱 서명 키 생성 및 백업
- [ ] 콘텐츠 등급 설문 작성
- [ ] 데이터 보안 섹션 작성
- [ ] 타겟 연령대 설정
- [ ] 내부 테스트 트랙 배포
- [ ] 프로덕션 출시

#### Apple App Store
- [ ] Apple Developer Program 가입 ($99/년)
- [ ] App Store Connect 앱 등록
- [ ] 앱 심사 정보 작성
- [ ] 개인정보 보호 영양 라벨 작성
- [ ] TestFlight 베타 테스트
- [ ] 앱 심사 제출

### 9.4 앱 버전 관리

**Semantic Versioning**: `MAJOR.MINOR.PATCH`
- MAJOR: 호환성이 깨지는 변경
- MINOR: 새로운 기능 추가
- PATCH: 버그 수정

**예시**:
- `1.0.0`: MVP 출시
- `1.1.0`: 알림 기능 추가
- `1.1.1`: 버그 수정
- `2.0.0`: 그룹 기능 추가 (큰 변경)

### 9.5 강제 업데이트 정책

| 업데이트 유형 | 조건 | 동작 |
|--------------|------|------|
| 강제 업데이트 | MAJOR 버전 변경, 보안 이슈 | 앱 사용 불가, 스토어 이동 |
| 권장 업데이트 | MINOR 버전 변경 | 팝업 표시, "나중에" 선택 가능 |
| 무시 | PATCH 버전 변경 | 알림 없음 |

**구현**: Firebase Remote Config로 최소 버전 관리
```json
{
  "minimum_version": "1.0.0",
  "recommended_version": "1.1.0",
  "force_update_message": "중요한 업데이트가 있습니다. 앱을 업데이트해주세요."
}
```

---

## 10. 운영 정책

### 10.1 데이터 백업

| 항목 | 정책 |
|------|------|
| 자동 백업 | Supabase 일일 자동 백업 (Pro 플랜) |
| 백업 보존 | 7일 |
| 복구 테스트 | 분기별 1회 |

**MVP 단계 (무료 티어)**:
- 수동 백업: 주 1회 pg_dump 실행
- 백업 파일 암호화 후 Cloud Storage 저장

### 10.2 장애 대응

#### 장애 등급 정의
| 등급 | 정의 | 목표 복구 시간 |
|------|------|---------------|
| P1 (Critical) | 전체 서비스 중단, 데이터 유실 | 1시간 |
| P2 (High) | 핵심 기능 장애 (로그인, CRUD) | 4시간 |
| P3 (Medium) | 부가 기능 장애 (검색, 필터) | 24시간 |
| P4 (Low) | UI 버그, 성능 저하 | 다음 배포 |

#### 장애 대응 프로세스
1. **감지**: Crashlytics 알림, 사용자 신고
2. **확인**: 로그 분석, 재현 테스트
3. **공지**: 인앱 공지 또는 SNS
4. **해결**: 핫픽스 배포 또는 롤백
5. **후속**: 장애 리포트 작성, 재발 방지

### 10.3 고객 지원

| 채널 | 용도 | 응답 목표 |
|------|------|-----------|
| 인앱 문의 | 기능 문의, 버그 신고 | 24시간 |
| 이메일 | 계정 문제, 데이터 요청 | 48시간 |
| FAQ | 자주 묻는 질문 | - |

**지원 이메일**: (설정 필요)

### 10.4 개인정보 처리

#### 수집 항목
| 항목 | 필수/선택 | 용도 | 보유 기간 |
|------|----------|------|-----------|
| 이메일 | 필수 | 계정 식별 | 회원 탈퇴 시까지 |
| 이름 | 필수 | 서비스 내 표시 | 회원 탈퇴 시까지 |
| 기도 제목 | 필수 | 서비스 제공 | 회원 탈퇴 시까지 |
| 기기 정보 | 필수 | 앱 오류 분석 | 1년 |

#### 사용자 권리
- **열람권**: 내 데이터 조회 (설정 > 내 정보)
- **정정권**: 정보 수정 (설정 > 내 정보 수정)
- **삭제권**: 회원 탈퇴 (설정 > 회원 탈퇴)
- **이동권**: 데이터 내보내기 (Post-MVP)

---

## 11. 리스크 및 대응

| 리스크 | 영향 | 가능성 | 대응 방안 |
|--------|------|--------|-----------|
| Supabase 무료 티어 제한 | 중 | 중 | 500MB DB, 1GB Storage로 초기 충분. DAU 1000명 이상 시 Pro 플랜 전환 ($25/월) |
| Google 로그인 승인 지연 | 중 | 중 | M1 단계에서 조기 OAuth 동의 화면 제출. 민감 범위 사용 안 함 |
| iOS 심사 리젝 | 중 | 중 | 종교 앱 가이드라인 사전 검토. 최소 기능 충족 확인. 버퍼 일정 확보 |
| 저조한 사용자 참여 | 고 | 중 | 셀 리더 타겟 마케팅. 온보딩 개선. 알림 기능 우선 개발 |
| 데이터 유실 | 고 | 하 | 정기 백업. RLS 정책으로 실수 방지. Soft Delete로 복구 가능 |
| 보안 사고 | 고 | 하 | RLS 필수 적용. API Key 환경변수 관리. 정기 보안 점검 |

---

## 12. 부록

### 12.1 용어 정의
- **기도 제목**: 타인을 위해 기도할 내용
- **요청자**: 기도 제목을 전달한 사람
- **기도 응답**: 기도가 이루어졌다고 판단되는 상태
- **셀**: 교회 내 소그룹 단위

### 12.2 참고 자료
- [Flutter 공식 문서](https://flutter.dev/docs)
- [GetX 패키지](https://pub.dev/packages/get)
- [Supabase 문서](https://supabase.com/docs)
- [Supabase Flutter SDK](https://supabase.com/docs/reference/dart)

---

## 변경 이력

| 버전 | 날짜 | 작성자 | 변경 내용 |
|------|------|--------|-----------|
| 1.0 | 2025-12-10 | PM | 최초 작성 |
| 1.1 | 2025-12-10 | PM | 개발자 리뷰 반영 - 데이터 모델 상세화, 보안/에러 처리 추가, 운영 정책 추가 |
| 1.2 | 2025-12-11 | Dev | 기술 구현 노트 추가 - 서비스 초기화 순서, 관계 데이터 처리, 화면 전환 패턴, 상태 동기화 패턴, RLS 정책 현황 |

---

## 13. 기술 구현 노트

### 13.1 서비스 초기화 순서

앱 시작 시 서비스 초기화는 **의존성 순서**를 반드시 준수해야 합니다:

```dart
// main.dart
void main() async {
  // 1. Supabase 라이브러리 초기화
  await SupabaseService.initialize();

  // 2. GetX 서비스 등록 (순서 중요!)
  await Get.putAsync(() => SupabaseService().init());  // 먼저
  await Get.putAsync(() => AuthService().init());      // 나중 (SupabaseService 의존)

  runApp(const App());
}
```

**주의사항**:
- `AuthService`는 `SupabaseService`에 의존하므로 반드시 `SupabaseService` 등록 후 초기화
- `InitialBinding`에서 Repository 등록 시에도 서비스가 이미 등록되어 있어야 함

### 13.2 데이터 조회 시 관계 데이터 처리

기도 제목 조회 시 요청자 정보를 JOIN할 때 **모든 필드**를 가져와야 합니다:

```dart
// 올바른 방법
.select('*, requesters(*)')

// 잘못된 방법 (파싱 에러 발생)
.select('*, requesters(id, name)')  // user_id, created_at 등 누락으로 에러
```

**이유**: `RequesterModel.fromJson()`에서 `user_id`, `created_at`, `updated_at` 필드가 필수이므로, 부분 필드만 가져오면 파싱 에러가 발생합니다.

### 13.3 화면 전환 시 스낵바 처리

GetX에서 `Get.snackbar()`와 `Get.back()`을 함께 사용할 때, **화면 전환을 먼저** 수행해야 합니다:

```dart
// 올바른 패턴
Future<void> save() async {
  try {
    await repository.save(...);

    // 1. 화면 먼저 닫기
    Get.back(result: true);

    // 2. 스낵바는 지연 표시
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.snackbar('완료', '저장되었어요', ...);
    });
  } catch (e) {
    // 에러 시에는 화면 유지
    showErrorSnackbar('저장에 실패했어요');
  }
}
```

**이유**: 스낵바가 오버레이로 표시되면서 `Get.back()`이 정상 동작하지 않을 수 있음

### 13.4 상세 페이지 상태 변경 및 동기화

상세 페이지에서 상태 변경 후 **UI 즉시 갱신** 및 **홈 화면 동기화**를 위한 패턴:

#### 13.4.1 Controller에서 변경 추적

```dart
class PrayerController extends GetxController {
  final Rx<PrayerRequestModel?> prayer = Rx<PrayerRequestModel?>(null);
  final RxBool hasChanges = false.obs;  // 변경 여부 추적

  Future<void> toggleStatus() async {
    final updated = await repository.toggleStatus(prayer.value!.id);
    prayer.value = updated;
    prayer.refresh();  // UI 강제 갱신 (Obx 리스너에게 알림)
    hasChanges.value = true;  // 변경됨 표시
  }
}
```

#### 13.4.2 상세 페이지에서 뒤로 가기 시 결과 반환

```dart
// prayer_detail_page.dart
@override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) {
      if (didPop) return;
      Get.back(result: controller.hasChanges.value);
    },
    child: Scaffold(...),
  );
}
```

#### 13.4.3 홈 화면에서 결과 수신

```dart
// home_controller.dart
void goToPrayerDetail(PrayerRequestModel prayer) {
  Get.toNamed(AppRoutes.prayerDetail, arguments: {...})?.then((result) {
    if (result == true) {
      refresh();  // 변경이 있었으면 리스트 새로고침
    }
  });
}
```

### 13.5 RLS 정책 적용 현황

현재 구현된 RLS 정책:

| 테이블 | 정책 | 적용 |
|--------|------|------|
| users | SELECT/UPDATE own data | ✅ |
| requesters | SELECT/INSERT/UPDATE/DELETE own data | ✅ |
| prayer_requests | SELECT/INSERT/UPDATE/DELETE own data | ✅ |

모든 테이블에서 `auth.uid() = user_id` 조건으로 사용자 본인의 데이터만 접근 가능합니다.

---

**문서 버전**: 1.2
**최종 수정일**: 2025-12-11
**작성자**: PM
