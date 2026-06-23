# SMORU Staged AI Agent Prompts

이 폴더는 SMORU iOS 네이티브 앱을 한 번에 구현하지 않고, 단계별로 안전하게 구현하기 위한 AI Agent용 프롬프트 모음이다.

## 사용 원칙

AI Agent에게 한 번에 전체 앱을 만들라고 지시하지 말 것.

반드시 아래 순서대로 한 파일씩 입력한다.

각 단계가 끝나면 해당 단계의 점검 방법을 실행하고, 점검이 통과해야 다음 단계 프롬프트로 넘어간다.

## 실행 순서

1. `00_repo_audit_and_execution_plan.md`
2. `01_native_ios_project_skeleton.md`
3. `02_domain_models_and_engines.md`
4. `03_healthkit_and_manual_fallback.md`
5. `04_sleep_fragment_home_history.md`
6. `05_routine_setup_and_task_editor.md`
7. `06_routine_focus_mode_and_notifications.md`
8. `07_auth_firebase_placeholders_and_privacy.md`
9. `08_final_integration_acceptance.md`

## 우선순위 문서

Agent는 각 단계 시작 전 반드시 아래 문서를 읽어야 한다.

1. `docs/AGENT_IMPLEMENTATION_SPEC.md`
2. `docs/smoru_prd_v1_native_addendum.md`
3. `docs/smoru_srd_v1_native_addendum.md`
4. 기존 PRD/SRD/BRD/Design 문서

문서가 충돌하면 `AGENT_IMPLEMENTATION_SPEC.md`와 V1 Addendum을 우선한다.

## 강제 원칙

- 최종 산출물은 Swift + SwiftUI 기반 iOS 네이티브 앱이다.
- 단일 HTML, React, Vite, Next.js, 웹앱 구현은 실패로 간주한다.
- API key, Firebase 실제 config, secret은 커밋하지 않는다.
- HealthKit 원본 데이터는 서버로 업로드하지 않는다.
- 각 단계는 작게 끝내고, 빌드 또는 정적 점검을 통과한 뒤 커밋한다.
