# 퀴즈 진행 시스템 기능명세서

## 구현된 기능

### 1. 화면 구조

**1) 퀴즈 세트 화면 (lib/pages/quiz_set/quiz_set_page.dart)**

- 3x3 그리드 레이아웃으로 퀴즈 이미지 표시
- 각 화풍별 실제 퀴즈 개수 반영 (화풍1: 5개, 화풍2: 3개, 화풍3,4: 각 1개)
- 미완료 퀴즈는 잠금 아이콘으로 표시
- 완료된 퀴즈는 실제 이미지로 표시

**2) 퀴즈 화면 (lib/pages/quiz/quiz_page.dart)**

- 상단: AppBar (코인 표시, 공유 버튼)
- 중앙: 퀴즈 이미지 (확대/축소 가능)
- 하단: 답안 입력 필드, 힌트 버튼, 건너뛰기 버튼

### 2. 데이터 관리

**1) 퀴즈 데이터 (lib/data/quiz_data.dart)**

- 화풍별 퀴즈 정답 데이터 관리
- 정답 검증 로직 구현

**2) 진행 상태 관리 (lib/providers/quiz_progress_provider.dart)**

- 완료된 퀴즈 상태 관리
- 화풍별, 퀴즈별 완료 상태 추적

### 3. 사용자 상호작용

**1) 답안 제출**

- 한글 입력 최적화
- 정답/오답 피드백 표시
- 햅틱 피드백 제공

**2) 이미지 상호작용**

- 이미지 확대/축소 기능
- 에러 상태 처리

## 구현 예정 기능

1. 힌트 시스템

   - 힌트 사용 로직
   - 코인 소비 기능

2. 퀴즈 건너뛰기

   - 건너뛰기 로직
   - 코인 소비 기능

3. 진행 상태 저장

   - 로컬 스토리지 연동
   - 앱 재시작 시 상태 복원

4. 공유 기능
   - 퀴즈 결과 공유
   - SNS 연동

## 테스트 항목

1. 퀴즈 화면 렌더링 테스트

   - 이미지 정상 로드 확인
   - UI 요소 배치 확인
   - 반응형 레이아웃 확인

2. 사용자 입력 테스트

   - 한글 입력 정상 작동
   - 입력 필드 유효성 검사
   - 제출 버튼 활성화 조건 검증

3. 퀴즈 진행 흐름 테스트

   - 퀴즈 전환 애니메이션
   - 정답/오답 처리
   - 진행 상태 저장

4. 상태 관리 테스트
   - 앱 종료 후 재시작 시 진행 상태 복원
   - 세트 완료 시 보상 지급 확인

## 백엔드 기능명세서

### 1. 데이터베이스 설계

**1) 퀴즈 데이터 모델 (lib/models/quiz_model.dart)**

```
QuizSet {
  String id
  String styleId
  List<Quiz> quizzes
  int requiredCoins
  DateTime createdAt
}

Quiz {
  String id
  String question
  String answer
  String imageUrl
  List<String> hints
  int orderIndex
}
```

**2) 사용자 진행 데이터 모델 (lib/models/progress_model.dart)**

```
UserProgress {
  String userId
  String quizSetId
  List<QuizProgress> quizProgresses
  DateTime lastPlayedAt
}

QuizProgress {
  String quizId
  bool isCompleted
  int attempts
  List<String> usedHints
}
```

### 2. 테스트 항목

1. 데이터 CRUD 작업 테스트

   - 퀴즈 세트 로드
   - 진행 상황 저장
   - 힌트 사용 기록

2. 데이터 정합성 테스트

   - 퀴즈 순서 유지
   - 진행 상태 동기화
   - 보상 지급 검증

3. 예외 처리 테스트

   - 네트워크 오류 대응
   - 데이터 손상 복구
   - 동시성 제어

4. 성능 테스트
   - 데이터 로딩 속도
   - 메모리 사용량
   - 저장소 사용량
