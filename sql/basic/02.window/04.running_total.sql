/*
Title: Running Total with SUM OVER
Category: SQL Basic / Window
Purpose:
  - 기간 누적 합/누적 카운트 계산

Use Case:
  - 누적 매출, 누적 가입자, 누적 캠페인 컨택 수
Dialect:
  - BigQuery
Notes:
  - 기본 프레임은 RANGE이며, 날짜/숫자 축에서는 의도 확인 필요
  - 명시적으로 ROWS BETWEEN을 주는 습관 권장
*/

WITH daily AS (
  SELECT DATE '2026-01-01' AS d, 10 AS cnt UNION ALL
  SELECT DATE '2026-01-02', 15 UNION ALL
  SELECT DATE '2026-01-03', 5
)
SELECT
  d,
  cnt,
  SUM(cnt) OVER (ORDER BY d ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_cnt
FROM daily
ORDER BY d;
