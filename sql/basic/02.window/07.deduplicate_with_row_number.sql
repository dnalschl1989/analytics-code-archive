/*
Title: Deduplication with ROW_NUMBER and QUALIFY
Category: SQL Basic / Window
Purpose:
  - 중복 레코드 중 하나만 선택하여 제거 (deduplication)
  - 최신 레코드 / 우선순위 레코드 기준으로 1건만 유지

Use Case:
  - 고객별 중복 이벤트 제거
  - 동일 키(user_id, order_id 등) 기준 최신 상태 1건 추출
  - 로그/이력 테이블 정제

Dialect:
  - BigQuery

Notes:
  - QUALIFY는 BigQuery에서만 지원 (WHERE 대신 사용)
  - 정렬 기준(ORDER BY)이 dedup 결과를 결정하므로 매우 중요
*/

-- =========================================================
-- Example 1) 고객(user_id)별 최신 레코드 1건만 유지
-- =========================================================
WITH sample AS (
  SELECT 'u1' AS user_id, TIMESTAMP '2026-01-01 10:00:00' AS updated_at, 'A' AS status UNION ALL
  SELECT 'u1', TIMESTAMP '2026-01-02 09:00:00', 'B' UNION ALL
  SELECT 'u2', TIMESTAMP '2026-01-01 08:00:00', 'X'
)
SELECT
  user_id,
  updated_at,
  status
FROM sample
QUALIFY
  ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY updated_at DESC) = 1;

-- =========================================================
-- Example 2) 우선순위 컬럼 기준 dedup (flag > 최신일)
-- =========================================================
-- priority_flag = 'Y' 인 행을 우선, 없으면 최신일 기준
WITH sample AS (
  SELECT 'u1' AS user_id, 'Y' AS priority_flag, DATE '2026-01-01' AS dt UNION ALL
  SELECT 'u1', 'N', DATE '2026-01-05' UNION ALL
  SELECT 'u2', 'N', DATE '2026-01-03'
)
SELECT *
FROM sample
QUALIFY
  ROW_NUMBER() OVER (
    PARTITION BY user_id
    ORDER BY
      CASE WHEN priority_flag = 'Y' THEN 1 ELSE 0 END DESC,
      dt DESC
  ) = 1;

-- =========================================================
-- Example 3) 동일 키 완전 중복 제거 (값 동일)
-- =========================================================
-- 모든 컬럼이 동일한 완전 중복 제거
SELECT *
FROM sample
QUALIFY
  ROW_NUMBER() OVER (
    PARTITION BY user_id, priority_flag, dt
    ORDER BY user_id
  ) = 1;
