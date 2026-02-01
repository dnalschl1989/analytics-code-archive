/*
Title: Sessionization with LAG and Conditional Accumulation
Category: SQL Basic / Window
Purpose:
  - 이벤트 로그를 "세션(Session)" 단위로 그룹화
  - 이전 이벤트와의 시간 차이를 기준으로 세션 분리

Use Case:
  - 웹/앱 사용자 행동 세션 분석
  - 콜/이벤트 로그 묶음 처리
  - 일정 시간 이상 공백 발생 시 새 세션으로 간주

Dialect:
  - BigQuery

Notes:
  - 세션 기준 시간(threshold)은 업무 상황에 따라 조정 (예: 30분, 60분)
  - LAG로 이전 이벤트 시각을 가져와 조건 분기
*/

-- =========================================================
-- Example) 30분 이상 공백 시 새로운 세션 생성
-- =========================================================
WITH events AS (
  SELECT 'u1' AS user_id, TIMESTAMP '2026-01-01 10:00:00' AS event_ts UNION ALL
  SELECT 'u1', TIMESTAMP '2026-01-01 10:10:00' UNION ALL
  SELECT 'u1', TIMESTAMP '2026-01-01 11:00:00' UNION ALL
  SELECT 'u2', TIMESTAMP '2026-01-01 09:00:00'
),

lagged AS (
  SELECT
    user_id,
    event_ts,
    LAG(event_ts) OVER (PARTITION BY user_id ORDER BY event_ts) AS prev_event_ts
  FROM events
),

session_flag AS (
  SELECT
    *,
    CASE
      WHEN prev_event_ts IS NULL THEN 1
      WHEN TIMESTAMP_DIFF(event_ts, prev_event_ts, MINUTE) >= 30 THEN 1
      ELSE 0
    END AS is_new_session
  FROM lagged
),

sessionized AS (
  SELECT
    *,
    SUM(is_new_session) OVER (
      PARTITION BY user_id
      ORDER BY event_ts
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS session_id
  FROM session_flag
)

SELECT
  user_id,
  event_ts,
  session_id
FROM sessionized
ORDER BY user_id, event_ts;
