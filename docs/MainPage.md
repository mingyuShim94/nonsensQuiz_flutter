# 프론트엔드 기능명세서: 메인 화면 시스템

## 1. 화면 레이아웃 및 디자인 명세

### 페이지 구조

- 경로: `lib/pages/main/main_page.dart`
- 상태 관리: `lib/providers/main_page_provider.dart`

### 컴포넌트 구조

1. AppBar (`lib/pages/main/main_page.dart` 내부)

   - 설정 버튼 (왼쪽)
   - 코인/별 표시 영역 (중앙)
     - 코인 컨테이너: secondaryContainer 색상, 둥근 모서리
     - 별 컨테이너: primaryContainer 색상, 둥근 모서리
   - 대칭을 위한 여백 (오른쪽)

2. 화풍 리스트 (`lib/widgets/main/style_list.dart`)
   - 리스트 아이템 컴포넌트: `lib/widgets/main/style_list_item.dart`
   - 각 아이템 요소:
     - 대표 이미지 (16:9 비율)
     - 화풍명
     - 진행률 인디케이터
     - 잠금 상태 표시 (별 개수 부족 시)

### 상태 관리

- 화풍 리스트 데이터 (styleListProvider)
- 코인 보유량 (coinsProvider)
- 별 보유량 (starsProvider)

### 디자인 시스템

- Material Design 3 테마 사용
- 색상:
  - 배경: colorScheme.surface
  - 코인 컨테이너: colorScheme.secondaryContainer
  - 별 컨테이너: colorScheme.primaryContainer
- 타이포그래피:
  - 코인/별 텍스트: titleMedium
  - 에러 메시지: error 색상

## 2. 사용자 흐름 및 상호작용

### 화면 새로고침

- Pull-to-refresh 지원
  - 화풍 리스트 갱신
  - 코인 데이터 갱신
  - 별 데이터 갱신

### 상태 표시

- 로딩 상태: CircularProgressIndicator
- 에러 상태:
  - 코인/별: error_outline 아이콘
  - 리스트: SelectableText로 에러 메시지 표시

## 3. 테스트 항목

1. 레이아웃 테스트
   - 앱바 레이아웃 정확성
   - 코인/별 컨테이너 디자인
   - Pull-to-refresh 동작
   - 에러 상태 UI

---

# 백엔드 기능명세서: 메인 화면 시스템

## 1. 데이터베이스 설계

### 로컬 데이터베이스 (Hive)

1. 화풍 정보 테이블

```
StyleBox {
  String id
  String name
  String thumbnailPath
  int progress
  bool isNew
  bool isLocked
  DateTime lastUpdated
}
```

2. 사용자 데이터 테이블

```
UserBox {
  int coins
  int stars
  Map<String, int> styleProgress
  DateTime lastVisit
}
```

### 데이터베이스 작업

1. 화풍 데이터 조회

   - 경로: `lib/repositories/style_repository.dart`
   - 메서드: `Future<List<Style>> getStyles()`

2. 진행률 및 별 데이터 조회/업데이트

   - 경로: `lib/repositories/progress_repository.dart`
   - 메서드:
     - `Future<Map<String, int>> getProgress()`
     - `Future<void> updateProgress(String styleId, int progress)`
     - `Future<int> getStars()`
     - `Future<void> updateStars(int stars)`

3. 코인 데이터 조회
   - 경로: `lib/repositories/user_repository.dart`
   - 메서드: `Future<int> getCoins()`

## 2. 테스트 항목

### 데이터 조회 테스트

1. 화풍 리스트 로딩

   - 데이터 정확성
   - 로딩 성능
   - 에러 핸들링

2. 진행률 및 별 데이터

   - 진행률 및 별 개수 계산 정확성
   - 업데이트 후 데이터 정합성
   - 동시성 처리

3. 코인 데이터
   - 잔액 조회 정확성
   - 트랜잭션 로그 기록

### 데이터 동기화 테스트

1. 앱 재실행 시 데이터 복원
2. 진행률 및 별 개수 업데이트 후 저장
3. 데이터 마이그레이션 (버전 업데이트 시)
