/*
Title: Truncate Date to Period Start
Category: SQL Basic / Date
Purpose:
  - 날짜를 특정 기간 단위(월/주/일) 기준 시작일로 절삭(truncate)
  - 리포트 집계 기준일을 일관되게 생성

Use Case:
  - 월별 리포트: 월 시작일로 정규화
  - 주별 리포트: 주 시작일로 정규화
  - Cohort 기준(가입월) 정의

Input:
  - base_date (DATE)
  - period (DAY/WEEK/MONTH/YEAR)

Output:
  - truncated_date (DATE)

Dialect:
  - BigQuery / Impala

Notes:
  - BigQuery: DATE_TRUNC(date, <part>)
  - Impala: TRUNC(date, 'MM'|'YY') 중심 (주 단위는 별도 계산 필요)
*/

-- =========================================================
-- BigQuery
-- =========================================================

-- Example 1: Truncate to month start
SELECT
  DATE '2026-02-17' AS base_date,
  DATE_TRUNC(DATE '2026-02-17', MONTH) AS month_start;

-- Example 2: Truncate to week start (default week starts on Sunday in many contexts; verify org standard)
SELECT
  DATE '2026-02-17' AS base_date,
  DATE_TRUNC(DATE '2026-02-17', WEEK) AS week_start;

-- Example 3: Truncate to year start
SELECT
  DATE '2026-02-17' AS base_date,
  DATE_TRUNC(DATE '2026-02-17', YEAR) AS year_start;


-- =========================================================
-- Impala
-- =========================================================

-- Example 1: Truncate to month start
SELECT
  CAST('2026-02-17' AS DATE) AS base_date,
  TRUNC(CAST('2026-02-17' AS DATE), 'MM') AS month_start;

-- Example 2: Truncate to year start
SELECT
  CAST('2026-02-17' AS DATE) AS base_date,
  TRUNC(CAST('2026-02-17' AS DATE), 'YY') AS year_start;

-- Example 3: Truncate to week start (Impala may not provide direct week trunc; compute with day-of-week)
-- NOTE: This example assumes Monday as week start. Adjust if your standard differs.
-- week_start = base_date - (weekday_index - 1)
-- weekday_index depends on available functions; below is a common approach using dayofweek:
-- In Impala, DAYOFWEEK() returns 1(Sun) .. 7(Sat). For Monday-start weeks:
-- offset = (DAYOFWEEK(base_date) + 5) % 7
-- week_start = DATE_ADD(base_date, -offset)

SELECT
  CAST('2026-02-17' AS DATE) AS base_date,
  DATE_ADD(
    CAST('2026-02-17' AS DATE),
    -((DAYOFWEEK(CAST('2026-02-17' AS DATE)) + 5) % 7)
  ) AS week_start_monday;
