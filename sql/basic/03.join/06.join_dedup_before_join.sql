/*
Title: Deduplicate Before Join
Purpose:
  - JOIN 전에 중복 제거하여 결과 왜곡 방지
Use Case:
  - 이력 테이블 결합
*/

WITH dedup AS (
  SELECT *
  FROM raw_events
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY user_id
    ORDER BY event_dt DESC
  ) = 1
)
SELECT
  u.user_id,
  d.event_dt
FROM users u
LEFT JOIN dedup d
  ON u.user_id = d.user_id;
