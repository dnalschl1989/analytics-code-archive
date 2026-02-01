
/*
Title: Latest Record per Entity with ROW_NUMBER
Category: SQL Basic / Window
Purpose:
  - 엔티티(고객/계약/상품)별 최신 1건 레코드 추출

Use Case:
  - 고객별 최신 상태/등급/마지막 접촉 이력 1건만 필요할 때
Dialect:
  - BigQuery
Notes:
  - 동점(같은 updated_at) 발생 시 결정적 정렬 컬럼을 추가해야 함
*/

WITH sample AS (
  SELECT 'u1' AS user_id, TIMESTAMP '2026-01-01 10:00:00' AS updated_at, 'A' AS status UNION ALL
  SELECT 'u1', TIMESTAMP '2026-01-02 10:00:00', 'B' UNION ALL
  SELECT 'u2', TIMESTAMP '2026-01-01 09:00:00', 'X'
),
ranked AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY updated_at DESC) AS rn
  FROM sample
)
SELECT * EXCEPT(rn)
FROM ranked
WHERE rn = 1;
