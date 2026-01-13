# 🌱 Project Plan: 북가든 (Book Garden)

## 1. 프로젝트 개요

- **한 줄 소개:** "책을 읽으면 정원이 자란다." 목표 달성형 게이미피케이션 독서 기록 앱.
- **핵심 가치:** 심플함, 시각적 성취감(피크민 스타일), 무압박.
- **타겟 플랫폼:** iOS (iPhone)
- **개발 인원:** 1인 (Design & Dev)

## 2. 기술 스택 (Tech Stack)

프론트엔드 경험을 살린 최신 iOS 스택 구성입니다.

- **Language:** Swift 5.9+
- **UI Framework:** **SwiftUI** (React와 유사한 선언형 UI)
- **Architecture:** **MVVM** (Model - View - ViewModel)
- **Data Persistence (로컬 DB):** **SwiftData** (iOS 17+ 권장, CoreData보다 훨씬 쉬움) 또는 `UserDefaults` (MVP 단계 초간단 저장용)
- **Networking:** `URLSession` + `Async/Await` (JS의 fetch/await와 유사)
- **External API:** 알라딘 Open API (도서 검색용)

## 3. 핵심 기능 명세 (MVP Specs)

### 🏠 Tab 1: 화분 (Home) - [Main Feature]

- **Empty State:** 현재 읽는 책이 없을 때 "씨앗 심기" 버튼 노출.
- **Growing State:**
  - 현재 책의 **표지, 제목, 독서 진행률(%)** 표시.
  - 진행률에 따라 식물 이미지 5단계 변화 (씨앗 -> 새싹 -> 줄기 -> 봉오리 -> 열매).
  - **[물주기] 버튼:** 클릭 시 현재 페이지 입력 모달(Sheet) 팝업.
- **Harvest Action:** 100% 달성 시, 스와이프 제스처로 식물을 뽑는 애니메이션 + 햅틱 진동.

### 🔍 Search: 씨앗 심기

- 키워드로 도서 검색 (알라딘 API).
- 검색 결과 리스트 표시 (썸네일, 제목, 저자).
- 선택 시 "이 책 심기" 컨펌 후 메인 화분으로 데이터 등록.

### 🧺 Tab 2: 정원 (Archive)

- 수확 완료된(100% 달성) 책들을 그리드(Grid) 형태로 나열.
- 연도별/월별 섹션 구분 (Optional).
- 식물 아이콘 위에 작게 책 표지 오버레이.

## 4. 데이터 모델 (Data Schema)

**Model: `BookPlant`**

| Field Name      | Type   | Description                                |
| :-------------- | :----- | :----------------------------------------- |
| `id`            | UUID   | 고유 식별자                                |
| `title`         | String | 책 제목                                    |
| `coverUrl`      | String | 책 표지 이미지 URL                         |
| `author`        | String | 저자명                                     |
| `totalPage`     | Int    | 전체 페이지 수                             |
| `currentPage`   | Int    | 현재 읽은 페이지                           |
| `status`        | Enum   | `.growing` (재배중), `.harvested` (수확됨) |
| `plantedDate`   | Date   | 시작일                                     |
| `harvestedDate` | Date?  | 완료일 (Nullable)                          |

## 5. 개발 로드맵 (Roadmap)

### Phase 1: 뼈대 잡기 (UI Skeleton)

- [ ] Xcode 프로젝트 생성 (SwiftUI App).
- [ ] 하단 탭 바 (`TabView`) 구성: 화분 탭 / 정원 탭.
- [ ] 각 화면의 정적(Static) UI 구현 (더미 데이터 사용).
  - _Tip: React의 Component 만들듯 View를 쪼개서 작업._

### Phase 2: 상태 관리와 로직 (State & Logic)

- [ ] 식물 성장 로직 구현: `(currentPage / totalPage)` 계산하여 이미지 변경.
- [ ] 물주기 모달 구현: 숫자 입력 받아 `@State` 업데이트.
- [ ] 수확 인터랙션 구현: `DragGesture`로 위로 당기기 구현.

### Phase 3: 데이터 연동 (Networking & Data)

- [ ] **알라딘 API 키 발급** (TTBKey).
- [ ] 도서 검색 기능 구현 (JSON Parsing).
- [ ] **SwiftData** 세팅: 앱을 껐다 켜도 데이터가 유지되도록 저장소 연결.

### Phase 4: 폴리싱 (Polish)

- [ ] 식물 이미지 에셋(Pixel Art) 적용.
- [ ] **Haptics (진동)** 추가: 수확할 때 `UIImpactFeedbackGenerator` 사용.
- [ ] 앱 아이콘 및 로딩 화면 추가.

## 6. 필요 리소스 (Resources)

- **📖 API:** [알라딘 Open API 매뉴얼](https://blog.aladin.co.kr/openapi)
  - _주의: 요청 시 `Output=JS` 파라미터를 넣어야 JSON으로 옵니다._
- **🎨 Assets:** [Kenney Assets - Pixel Platformer Farm](https://kenney.nl/assets/pixel-platformer-farm) (무료 식물 리소스)
- **📚 Reference:**
  - Swift 공식 문서 (SwiftUI Tutorials)
  - SF Symbols (애플 기본 아이콘 사용)
