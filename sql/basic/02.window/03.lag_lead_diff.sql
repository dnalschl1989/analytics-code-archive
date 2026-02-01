/*
Title: Month-over-Month Change with LAG
Category: SQL Basic / Window
Purpose:
  - 이전 기간 값(전월/전주)을 가져와 증감 계산

Use Case:
  - KPI 전월 대비 증감률
  - 고객별 최근 2회 이용 간격
Dialect:
  - BigQuery
Notes:
  - 기간 정렬 컬럼(예: yyyymm)을 DATE로 변환해 정렬 안정화 권장
*/

WITH kpi AS (
  SELECT DATE '2025-12-01' AS month, 1200 AS value UNION ALL
  SELECT DATE '2026-01-01', 1500 UNION ALL
  SELECT DATE '2026-02-01', 1400
)
SELECT
  month,
  value,
  LAG(value) OVER (ORDER BY month) AS prev_value,
  value - LAG(value) OVER (ORDER BY month) AS diff_value,
  SAFE_DIVIDE(value - LAG(value) OVER (ORDER BY month), LAG(value) OVER (ORDER BY month)) AS diff_rate
FROM kpi
ORDER BY month;
