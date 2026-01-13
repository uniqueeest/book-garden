# 북가든 MVP 개발 플랜 (비용 최소화 + 빠른 배포)

## 현재 상황

- 사회초년생, 큰 비용 지불 어려움
- Swift/SwiftUI 첫 경험 (프론트엔드 경험 있음)
- 알라딘 API 키 미발급
- Apple Developer Program 미가입 (MVP 후 가입 예정)

## 비용 분석

| 항목                 | 비용   | 필수 시점              |
| -------------------- | ------ | ---------------------- |
| 알라딘 API           | 무료   | Phase 3 (검색 기능 시) |
| Kenney 에셋          | 무료   | Phase 2 (폴리싱 시)    |
| Apple Developer      | $99/년 | App Store 배포 시      |
| **MVP 개발 총 비용** | **$0** | -                      |

---

## MVP 범위 (알라딘 API 없이 시작)

### 필수 (Must Have)

1. **화분 탭 (Home)**

   - 현재 읽는 책 1권 표시
   - 진행률 표시 + 식물 5단계 이미지
   - 물주기 버튼 → 페이지 입력

2. **정원 탭 (Archive)**

   - 완독한 책 그리드 표시

3. **책 등록 (씨앗 심기)**

   - 제목, 총 페이지 수 수동 입력
   - (API 연동은 후순위)

4. **데이터 저장**
   - SwiftData로 로컬 저장

### 후순위 (API 키 발급 후)

- 알라딘 API 도서 검색
- 책 표지 이미지 자동 로드
- 수확 스와이프 애니메이션
- 햅틱 진동

---

## 개발 순서

### Phase 1: 뼈대 + 데이터

```
1. Xcode 프로젝트 생성 (SwiftUI App, iOS 17+)
2. TabView 구성 (화분/정원)
3. SwiftData 모델 정의 (BookPlant)
4. 화분 탭 UI (Empty State + Growing State)
5. 책 수동 등록 Sheet
6. 물주기 → 페이지 업데이트 로직
```

### Phase 2: 정원 + 에셋

```
1. 정원 탭 LazyVGrid
2. 100% 달성 → 정원 이동 로직
3. Kenney 픽셀아트 에셋 적용
4. 테스트 및 버그 수정
```

### Phase 3: API 연동 (선택)

```
1. 알라딘 API 연동
2. 도서 검색 기능
3. 표지 이미지 자동 로드
```

---

## 핵심 파일 구조

```
BookGarden/
├── BookGardenApp.swift          # 앱 진입점
├── Models/
│   └── BookPlant.swift          # SwiftData 모델
├── Views/
│   ├── ContentView.swift        # TabView (메인)
│   ├── PotView.swift            # 화분 탭
│   ├── GardenView.swift         # 정원 탭
│   ├── AddBookSheet.swift       # 책 등록 모달
│   └── WateringSheet.swift      # 물주기 모달
└── Assets.xcassets/             # 이미지 에셋
```

---

## SwiftUI 기본 개념 (React 개발자용)

| React              | SwiftUI                | 설명                  |
| ------------------ | ---------------------- | --------------------- |
| `useState`         | `@State`               | 컴포넌트 로컬 상태    |
| `useContext`       | `@Environment`         | 전역 상태 접근        |
| `props`            | 일반 파라미터          | 부모→자식 데이터 전달 |
| `<div>`            | `VStack/HStack/ZStack` | 레이아웃 컨테이너     |
| `map()`            | `ForEach`              | 리스트 렌더링         |
| `&&` 조건부 렌더링 | `if` 문                | 조건부 뷰 표시        |
| `className`        | `.modifier()`          | 스타일링              |

### 예시 비교

```jsx
// React
function Counter() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(count + 1)}>Count: {count}</button>;
}
```

```swift
// SwiftUI
struct Counter: View {
    @State private var count = 0
    var body: some View {
        Button("Count: \(count)") {
            count += 1
        }
    }
}
```

---

## 검증 방법

1. **시뮬레이터 테스트**

   - 책 등록 → 물주기 → 진행률 증가 → 식물 성장 확인
   - 100% 달성 → 정원으로 이동 확인
   - 앱 종료 후 재시작 → 데이터 유지 확인

2. **실기기 테스트**
   - Xcode에서 본인 iPhone 연결 후 빌드

---

## 다음 단계

1. 알라딘 API 발급 신청 시작 (미리 해두기)
2. Kenney 에셋 다운로드: https://kenney.nl/assets/pixel-platformer-farm
