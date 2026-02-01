# Error Handling & Risk Assessment

---

## What's Handled Well

| Area | Status | How |
|------|--------|-----|
| Network errors (Firebase) | Good | Riverpod AsyncValue -> loading/error states |
| Null/missing data | Good | Defensive parsing with `?? []` and `?? ''` |
| Image loading failures | Good | `errorBuilder` shows fallback icon |
| Form validation | Good | Email/password validation in auth |
| Type safety | Good | Freezed models prevent data corruption |

---

## Critical Risks (P0)

| Risk | Scenario | Current State | Fix Needed |
|------|----------|---------------|------------|
| Payment + network failure | User pays, network drops before booking saves | No retry | Retry with exponential backoff, store paymentId for reconciliation |
| Duplicate payments | User taps "Pay" multiple times | Only UI flag `_isProcessing` | Debounce + idempotency keys |
| Offline mode | No internet | Loading spinners forever | Connectivity listener + cached data + offline indicator |
| Booking after network loss | Payment succeeded but no booking record | User paid, no booking | Transaction rollback or booking verification step |

## High Risks (P1)

| Risk | Scenario | Fix Needed |
|------|----------|------------|
| App killed during booking | Force-quit mid-flow, selections lost | Save draft to shared_preferences |
| Trip deleted mid-booking | Admin deletes trip while user is booking | Null checks + "Trip unavailable" dialog |
| Auth token expiry | Token expires mid-session, API calls fail 401 | Token refresh + redirect to login |
| Race condition | Two users book last slot simultaneously | Firestore transaction for capacity check |
| Duplicate booking | User books same trip twice | Check existing booking before payment |

## Medium Risks (P2)

| Risk | Fix Needed |
|------|------------|
| Image gallery memory | Use `cached_network_image`, size limits |
| No retry on errors | Add retry button on error states |

---

## Resilience Score: 5/10

Strong on basic error handling (AsyncValue, null safety, image fallbacks). Weak on payment failure recovery, offline support, and state persistence.

**Priority:** Fix P0 items (payment + network) before production launch.
