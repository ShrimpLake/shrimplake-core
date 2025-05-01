# 🤝 CONTRIBUTING 가이드

ShrimpLake 프로젝트에 기여해주셔서 감사합니다!  
이 문서는 GitHub Issues 및 Pull Request 작성, 커밋 메시지, 브랜치 네이밍 규칙에 대해 안내합니다.


## 💡 이슈 작성 규칙

- 반드시 제공된 템플릿을 사용하여 이슈를 생성해주세요:
  - `bug-report-ko.md`
  - `feature-request-ko.md`
- 이슈 제목은 다음과 같이 시작해주세요:
  - `[BUG] Delta 저장 에러`
  - `[Feature] 수집 자동화 기능`
- 이슈를 만들기 전에 중복된 이슈가 있는지 먼저 검색해주세요.


## 🔀 Pull Request 작성 규칙

- Pull Request를 생성할 때는 `pull_request_template.md`의 양식을 사용해주세요.
- 관련 이슈가 있다면 본문에 아래처럼 연결해주세요:
  ```markdown
  Closes #이슈번호
  ```
- 변경 사항은 로컬에서 반드시 테스트한 후에 PR을 제출해주세요.
- PR merge는 리뷰 승인 후에 진행됩니다.


## 🌱 브랜치 네이밍 규칙

기여 유형에 따라 아래와 같은 네이밍 규칙을 권장합니다:

| 기여 유형       | 브랜치 이름 예시             |
|----------------|------------------------------|
| 기능 개발       | `feature/data-cleaning`      |
| 버그 수정       | `bugfix/powerbi-load-error`  |
| 문서 작성       | `docs/README-update`         |
| 테스트 코드 추가 | `test/api-fetch-test`        |


## 🧪 커밋 메시지 규칙 (conventional style)
일관된 커밋 메시지는 협업과 변경 이력 파악에 큰 도움이 됩니다.
```
<타입>: <간결한 설명>

예:
feat: 새 API 파라미터 수집 기능 추가
fix: 날짜 파싱 오류 수정
docs: CONTRIBUTING.md 항목 추가
refactor: 코드 리팩토링
test: 테스트 코드 추가
```


## 🧾 기타 가이드라인
- PR은 작고 명확하게 쪼개는 것이 좋습니다.
- 중복되는 코드나 복잡한 구조는 논의 후 병합해주세요.
- 커밋은 가능하면 한국어보다 영어로 간결하게 남겨주세요.