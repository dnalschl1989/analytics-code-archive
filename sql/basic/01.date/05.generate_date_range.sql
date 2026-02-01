/*
Title: Generate Date Range
Category: SQL Basic / Date
Purpose:
  - 시작일~종료일 구간의 날짜 시퀀스를 생성
  - 리포트 기준일 테이블/캘린더 테이블을 즉석에서 만들 때 사용

Use Case:
  - 일별 KPI 리포트 기준 날짜 생성
  - Cohort 분석용 캘린더 축 생성
  - 누락 날짜를 포함한 시계열 집계(LEFT JOIN)

Input:
  - start_date (DATE)
  - end_date (DATE)  -- inclusive / exclusive 여부 명시 필요

Output:
  - one row per date

Dialect:
  - BigQuery / Impala

Notes:
  - BigQuery: GENERATE_DATE_ARRAY(start_date, end_date) (inclusive)
  - Impala: numbers table / recursive CTE 대안 필요 (환경에 따라 제한)
*/

-- =========================================================
-- BigQuery (inclusive end_date)
-- =========================================================

-- Example 1: Generate daily dates (inclusive)
SELECT
  d AS date_value
FROM UNNEST(GENERATE_DATE_ARRAY(DATE '2026-01-01', DATE '2026-01-07')) AS d
ORDER BY date_value;

-- Example 2: Generate with step (e.g., every 7 days)
SELECT
  d AS date_value
FROM UNNEST(GENERATE_DATE_ARRAY(DATE '2026-01-01', DATE '2026-02-01', INTERVAL 7 DAY)) AS d
ORDER BY date_value;


-- =========================================================
-- Impala (approach using a numbers source)
-- =========================================================
-- Impala does not have a built-in GENERATE_DATE_ARRAY.
-- Common approach:
-- 1) Prepare a numbers table (0..N) or use an existing dimension table with enough rows.
-- 2) DATE_ADD(start_date, n) to expand.
--
-- Example below assumes you have a helper table `dim_numbers` with column `n` (INT) containing 0..10000.
-- Replace `dim_numbers` with your available source.

-- Parameters (inclusive end_date)
-- start_date = '2026-01-01'
-- end_date   = '2026-01-07'

SELECT
  DATE_ADD(CAST('2026-01-01' AS DATE), n) AS date_value
FROM dim_numbers
WHERE DATE_ADD(CAST('2026-01-01' AS DATE), n) <= CAST('2026-01-07' AS DATE)
ORDER BY date_value;

-- If you want exclusive end_date, change condition to:
-- WHERE DATE_ADD(start_date, n) < end_date
