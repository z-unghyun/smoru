# Stage 00 — Repo Audit and Execution Plan

## 목적

현재 저장소 상태를 점검하고, SMORU가 웹 목업이 아니라 iOS 네이티브 앱으로 구현되도록 작업 계획을 세운다. 이 단계에서는 코드를 대규모로 생성하지 않는다.

## Agent에게 입력할 프롬프트

```text
너는 SMORU iOS 앱을 구현하는 coding agent다.

먼저 저장소를 수정하기 전에 다음 문서를 읽어라.

1. docs/AGENT_IMPLEMENTATION_SPEC.md
2. docs/smoru_prd_v1_native_addendum.md
3. docs/smoru_srd_v1_native_addendum.md
4. docs/agent_prompts/README.md
5. 기존 BRD/PRD/SRD/Design 문서가 있다면 함께 확인

이 단계의 목표는 구현이 아니라 repo audit과 실행 계획 작성이다.

반드시 확인할 것:
- 루트에 index.html이 최종 앱처럼 남아 있지 않은지
- prototype/ 안의 HTML은 참고용으로만 남아 있는지
- Swift/Xcode 프로젝트가 이미 있는지
- docs의 Agent Spec과 Addendum이 존재하는지
- 구현해야 할 모듈 목록을 파악했는지

결과물:
- docs/agent_prompts/stage_outputs/00_repo_audit_result.md 생성
- 현재 repo 상태 요약
- 다음 단계별 구현 계획
- 발견한 위험 요소
- 아직 결정되지 않은 사항이 있다면 목록화

금지:
- 이 단계에서 앱 전체 구현을 시작하지 말 것
- HTML, React, Vite, Next.js를 새로 만들지 말 것
- 실제 API key나 secret을 생성하거나 입력하지 말 것

완료 후 stage 00 점검 방법을 실행하고, 통과하면 커밋해라.
```

## 점검 방법

Agent는 작업 후 아래를 확인한다.

```bash
# 루트 HTML이 최종 산출물처럼 존재하면 실패
find . -maxdepth 1 -name "index.html" -print

# 필수 문서 존재 확인
test -f docs/AGENT_IMPLEMENTATION_SPEC.md
test -f docs/smoru_prd_v1_native_addendum.md
test -f docs/smoru_srd_v1_native_addendum.md
test -f docs/agent_prompts/stage_outputs/00_repo_audit_result.md
```

## 통과 기준

- `docs/agent_prompts/stage_outputs/00_repo_audit_result.md`가 존재한다.
- Agent가 최종 산출물이 SwiftUI iOS 앱임을 명확히 인지했다.
- 루트 `index.html`을 최종 앱으로 취급하지 않는다.
- 다음 단계 구현 계획이 문서화되어 있다.

## 실패 시 중단 조건

아래 중 하나라도 해당하면 다음 단계로 넘어가지 말 것.

- Agent가 웹앱 구현 계획을 세움
- React/Vite/Next.js를 사용하겠다고 함
- HealthKit, SwiftData, UserNotifications를 누락함
- API key를 직접 요구하거나 커밋하려 함
