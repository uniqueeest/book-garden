# BookGarden Project Rules

## Git Workflow

### 브랜치 규칙
- **새로운 작업 시작 전에 반드시 새 브랜치 생성**
- 브랜치 네이밍: `feature/<기능명>`, `fix/<버그명>`, `chore/<작업명>`
- main 브랜치에 직접 커밋 금지

### 커밋 규칙
- 커밋 메시지는 **한글**로 작성
- **Conventional Commit** 형식 사용:
  - `feat: 새로운 기능`
  - `fix: 버그 수정`
  - `refactor: 리팩토링`
  - `chore: 기타 작업`
  - `docs: 문서 수정`
- 작은 단위로 커밋 (기능별, 파일별 분리)

## Project Structure

```
BookGarden/
├── Models/          # SwiftData 모델
├── Views/           # 화면 뷰
├── Components/      # 재사용 컴포넌트
└── Design/          # 디자인 시스템 (Colors, Fonts, Spacing)
```

## Tech Stack
- SwiftUI + SwiftData
- iOS 17+
- Xcode 15+
