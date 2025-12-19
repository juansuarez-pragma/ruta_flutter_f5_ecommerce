# Bad Practices Report (Clean Code + SOLID)

This document captures the main maintainability and design issues detected in the current Flutter project, why they are problematic, and what should be done to address them. It is intended to be actionable and enforceable through tests and lightweight tooling.

## Scope

- Codebase analyzed: `lib/` (~158 Dart files, ~233 top-level types).
- Focus: Clean Code readability, SOLID, layering, testability, and long-term maintainability.
- Note: Some dependencies come from external git packages (`fake_store_api_client`, `fake_store_design_system`) and are not modified here.

## How issues were identified (method)

1. Static analysis:
   - `flutter analyze` (lint and type safety signals).
2. Structural scanning:
   - Regex scans for anti-patterns (service locator usage, direct time access, direct asset bundle access, map-based persistence records, huge files).
3. Architectural review:
   - Cross-layer dependency review (presentation ↔ data ↔ domain).
4. Test coverage review:
   - Identify refactors that could break behavior and ensure tests exist before changing production code.
5. “Enforceability” check:
   - Prefer solutions that can be enforced with architecture tests (fast) and unit tests (behavioral).

## Findings (high impact)

### 1) Misleading naming (Clean Code)

**Problem**
- Names that imply stronger guarantees than the implementation provides, or hide intent with condensed expressions.

**Examples**
- `lib/features/auth/data/datasources/auth_local_datasource_impl.dart`
  - Previously: `newId` computed via a complex ternary + `reduce((a, b) ...)`.
  - `hashPassword` naming (when it was only Base64 encoding) is misleading and can lead to incorrect security assumptions.

**Why it matters**
- Increases cognitive load, makes reviews harder, and leads to incorrect assumptions (especially around “hashing”/security).

**What to do**
- Extract intent into small named functions (`_nextUserId(existingUsers)`).
- Use intention-revealing names (`registeredUsers`, `registeredUserRecords`, `passwordEncoded`).
- Avoid one-letter lambda variables when logic is non-trivial.

**Enforcement**
- Add/extend unit tests for affected behavior (already done for auth datasource).
- Optional: add a lint gate or review checklist for misleading names (`hash`, `token`, `secure`).

### 2) Persistence using untyped `Map<String, dynamic>` records (Data integrity)

**Problem**
- Storing complex structures using raw maps with magic keys scatters knowledge of the JSON schema.

**Examples**
- `lib/features/auth/data/datasources/auth_local_datasource_impl.dart` stored `{'user': ..., 'password': ...}` using raw maps.

**Why it matters**
- Schema changes become dangerous and error-prone.
- Repeated casts (`as Map<String, dynamic>`) are fragile.

**What to do**
- Introduce typed persistence models for local storage records.
- Centralize JSON keys in one place.

**Enforcement**
- Unit tests that assert persisted JSON shape (done for auth datasource).

### 3) Weak security semantics in local auth storage (Design/Threat model)

**Problem**
- Encoding is not encryption/hashing; storing passwords (even encoded) in local preferences is insecure.

**Examples**
- `lib/features/auth/data/datasources/auth_local_datasource_impl.dart`
  - Password storage is Base64 encoding (reversible).
  - Token generation is derived from `email:timestamp` and Base64 encoded (predictable).

**Why it matters**
- Even if this is a “local demo”, misleading naming and insecure patterns can propagate to production.

**What to do (choose based on product constraints)**
- If this is a training/demo app: rename methods to match reality (`_encodePasswordForStorage`) and document that it’s not secure.
- If this should be production-grade:
  - Do not store passwords locally at all.
  - Use a backend auth system and store only session tokens.
  - If local-only auth is required, use secure storage and a real password hashing strategy (salt + KDF).

**Enforcement**
- Add a security note in docs.
- Add a test that ensures password is never persisted (if you adopt that approach).

### 4) Service Locator usage (hidden dependencies)

**Problem**
- Using `GetIt` directly in UI or deep layers hides dependencies and makes refactors and tests harder.

**Current state**
- Improved: feature pages no longer call `sl<...>()` directly.
- Still present (and acceptable as composition root):
  - `lib/core/di/injection_container.dart`
  - `lib/core/router/app_router.dart`
  - `lib/app.dart`

**Why it matters**
- When spread across the app, it becomes a hidden global and breaks explicit dependency management.

**What to do**
- Keep GetIt usage constrained to composition points (DI container + router/bootstrap).
- Prefer constructor injection everywhere else.

**Enforcement**
- Add an architecture test that fails if `sl<` is used outside `lib/core/di/` and `lib/core/router/` (recommended).

### 5) Time access & testability (DIP + determinism)

**Problem**
- Direct `DateTime.now()` calls create non-determinism and make unit tests brittle.

**Current state**
- Improved: `Clock` abstraction exists in `lib/core/utils/clock.dart`.
- Remaining risk:
  - Ensure new code does not introduce new direct time calls.

**What to do**
- Always inject `Clock` into business logic classes that need “now”.

**Enforcement**
- Add an architecture test that forbids `DateTime.now()` usage outside `SystemClock`.

### 6) Large UI files / widget monoliths (SRP violation)

**Problem**
- Very large widget files concentrate UI, state interactions, and view helpers in one module.

**Examples (largest files)**
- `lib/features/profile/presentation/pages/profile_page.dart` (~398 lines)
- `lib/features/auth/presentation/pages/register_page.dart` (~300 lines)
- `lib/features/support/presentation/pages/contact_page.dart` (~299 lines)

**Why it matters**
- Hard to navigate, hard to reuse components, and increases merge conflicts.

**What to do**
- Extract sub-widgets into `presentation/widgets/` and keep pages thin.
- Move validation rules/constants into dedicated files.

**Enforcement**
- Optional: set a soft max file size guideline (e.g., “>250 lines requires justification”) and/or DCM “maximum file length” rule.

### 7) Inconsistent patterns across features (cohesion)

**Problem**
- Different features use different patterns for similar concepts (e.g., bloc file structure, exports).

**Examples**
- Auth bloc uses `part` files (`auth_bloc.dart` + `auth_event.dart` + `auth_state.dart`).
- Other blocs use separate files and re-export from the bloc file.

**Why it matters**
- Inconsistent conventions slow down onboarding and lead to accidental architectural drift.

**What to do**
- Adopt one standard:
  - Preferred: separate `*_event.dart`, `*_state.dart`, `*_bloc.dart` with re-exports from `*_bloc.dart`.
  - Or standardize on `part` for all blocs (less recommended in larger codebases).

**Enforcement**
- Add a short `CONTRIBUTING.md` section documenting the standard.

### 8) Domain repository files mixing responsibilities (SRP violation)

**Problem**
- Repository contracts should not define failure taxonomy/models; those belong in `domain/failures/`.

**Current state**
- Fixed for auth/support: failures moved into `domain/failures/`.
- Architecture test added:
  - `test/architecture/domain_repository_structure_test.dart`

**What to do next**
- Apply the same structure to any future feature added.

## Findings (medium impact)

### 9) “Fake” business logic in UI layer

**Examples**
- `lib/features/checkout/presentation/bloc/checkout_bloc.dart` simulates processing with `Future.delayed`.

**Why it matters**
- UI/business workflows should not rely on artificial delays; it complicates tests and UX.

**What to do**
- If the delay is for demo UX, keep it behind a feature flag or injected strategy (e.g., `CheckoutProcessingDelay`).

### 10) External package language mismatch

**Problem**
- The project aims to be fully English, but external packages contain Spanish docs/messages.

**What to do**
- Keep internal project code/docs English.
- Do not modify external dependencies; instead document the exception.

## Proposed remediation plan (phased)

### Phase 1 — Guardrails (tests/tooling first)
- Add architecture tests:
  - Forbid `sl<` outside composition points.
  - Forbid `DateTime.now()` outside `SystemClock`.
  - (Optional) Forbid `rootBundle` usage outside `AssetStringLoader`.
- Keep `flutter analyze` + `flutter test` green.

### Phase 2 — High-risk correctness issues
- Decide on the app’s security stance (demo vs production-grade auth).
- If production-grade: remove password persistence and use secure storage/token-based auth.

### Phase 3 — Clean Code refactors (low-risk, high ROI)
- Continue replacing map-based persistence with typed records where present.
- Rename misleading methods/variables and extract complex expressions into named helpers.

### Phase 4 — UI modularization
- Split large pages into smaller widgets and helper classes.
- Move validation and formatting helpers into dedicated modules.

### Phase 5 — Standardize patterns & documentation
- Document conventions (folder structure, bloc pattern, DI rules).
- Add CI gates for architecture tests + analyzer.

## Definition of “Done”

This set of improvements is considered complete when:
- Architecture tests enforce key dependency and SRP rules.
- `flutter analyze` reports zero issues.
- `flutter test` passes reliably.
- Naming and persistence patterns are consistent across features.

