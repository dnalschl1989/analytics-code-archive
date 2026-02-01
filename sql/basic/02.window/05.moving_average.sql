/*
Title: Moving Average with Window Frame
Category: SQL Basic / Window
Purpose:
  - 최근 N일(또는 N행) 기준 이동 평균 계산

Use Case:
  - 일별 KPI 스파이크 완화(rolling 7d)
  - 트래픽/컨택율 변동 추세 파악
Dialect:
  - BigQuery
Notes:
  - "7일"은 캘린더 기준이 아니라 행 기준(ROWS) 예시
  - 날짜 누락이 있으면 캘린더 테이블과 조인 후 계산 권장
*/

WITH daily AS (
  SELECT DATE '2026-01-01' AS d, 100 AS kpi UNION ALL
  SELECT DATE '2026-01-02', 130 UNION ALL
  SELECT DATE '2026-01-03', 90  UNION ALL
  SELECT DATE '2026-01-04', 110 UNION ALL
  SELECT DATE '2026-01-05', 140
)
SELECT
  d,
  kpi,
  AVG(kpi) OVER (ORDER BY d ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS ma_7
FROM daily
ORDER BY d;
