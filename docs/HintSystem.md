# 힌트 시스템 기능명세서

## 프론트엔드 기능명세서

### 1. 화면 레이아웃 및 디자인 명세

**1) 힌트 버튼 영역 (lib/widgets/hint/hint_button_area.dart)**

- 퀴즈 화면 하단에 배치
- 3단계 힌트 버튼 가로 배열
- 각 힌트 상태 표시 (사용 가능/사용됨/잠김)

**2) 힌트 컴포넌트 구조**

- `lib/widgets/hint/hint_button.dart`: 각 단계별 힌트 버튼
- `lib/widgets/hint/hint_modal.dart`: 힌트 표시 모달
- `lib/widgets/hint/coin_confirmation_dialog.dart`: 코인 사용 확인 다이얼로그

**3) 힌트 상태 표시 (lib/widgets/hint/hint_status.dart)**

- 사용 가능: 기본 상태
- 사용됨: 회색조 처리
- 잠김: 코인 아이콘과 함께 가격 표시

### 2. 사용자 흐름 및 상호작용

**1) 힌트 사용 프로세스**

- 힌트 버튼 탭
- 무료 힌트: 즉시 표시
- 유료 힌트
  - 코인 사용 확인 다이얼로그
  - 코인 차감
  - 힌트 표시

**2) 힌트 표시 방식**

- 글자 수: 정답 글자 수 표시
- 초성: 정답의 초성만 표시
- 한 글자 공개: 무작위 위치 글자 공개

**3) 힌트 애니메이션**

- 힌트 버튼: 탭 효과
- 힌트 모달: 페이드 인/아웃
- 코인 차감: 숫자 감소 애니메이션

### 3. 테스트 항목

1. 힌트 버튼 테스트

   - 상태별 UI 표시
   - 터치 이벤트 처리
   - 비활성화 상태 확인

2. 힌트 표시 테스트

   - 모달 표시/숨김
   - 힌트 내용 정확성
   - 애니메이션 성능

3. 코인 처리 테스트
   - 잔액 확인
   - 차감 처리
   - 부족 시 알림

## 백엔드 기능명세서

### 1. 데이터베이스 설계

**1) 힌트 데이터 모델 (lib/models/hint_model.dart)**

```
HintSystem {
  String quizId
  List<HintLevel> hintLevels
  Map<String, int> hintCosts
}

HintLevel {
  int level
  String type  // LETTER_COUNT, INITIAL_SOUND, REVEAL_LETTER
  bool isFree
  int coinCost
  String content
}

UserHintStatus {
  String userId
  String quizId
  List<UsedHint> usedHints
  DateTime lastUsedAt
}

UsedHint {
  int level
  bool isPurchased
  int coinsPaid
  DateTime usedAt
}
```

### 2. 테스트 항목

1. 힌트 데이터 처리

   - 힌트 생성 로직
   - 데이터 정합성
   - 힌트 순서 유지
   - 캐싱 처리

2. 코인 거래 테스트

   - 잔액 검증
   - 거래 기록
   - 동시성 제어
   - 롤백 처리

3. 보안 테스트

   - 힌트 데이터 암호화
   - 거래 검증
   - 무결성 검사
   - 해킹 방지

4. 성능 테스트

   - 힌트 로딩 속도
   - 동시 요청 처리
   - DB 쿼리 최적화
   - 메모리 사용량

5. 오류 처리 테스트
   - 네트워크 오류
   - 데이터 불일치
   - 거래 실패
   - 복구 프로세스
