/*
Title: Add Months to Date
Category: SQL Basic / Date
Purpose:
  - 기준일에 월 단위를 더하거나 빼서 결과 날짜를 생성
  - 월 단위 주기(예: +1M, -3M) 계산을 표준화

Use Case:
  - 가입월 기준 n개월 후 만료일 계산
  - 캠페인 기준월의 전/후 기간 산출
  - 월간 리포트 기준월 shifting

Input:
  - base_date (DATE)
  - months_to_add (INT)

Output:
  - shifted_date (DATE)

Dialect:
  - BigQuery / Impala

Notes:
  - 월말(예: 1/31) 처리 로직은 DB별로 다를 수 있음
  - BigQuery: DATE_ADD(date, INTERVAL n MONTH)
  - Impala: ADD_MONTHS(date, n)
*/

-- =========================================================
-- BigQuery
-- =========================================================

-- Example 1: Add months
SELECT
  DATE '2026-01-15' AS base_date,
  2 AS months_to_add,
  DATE_ADD(DATE '2026-01-15', INTERVAL 2 MONTH) AS shifted_date;

-- Example 2: Subtract months
SELECT
  DATE '2026-01-15' AS base_date,
  -3 AS months_to_add,
  DATE_ADD(DATE '2026-01-15', INTERVAL -3 MONTH) AS shifted_date;

-- Example 3: Month-end behavior (check expected result)
SELECT
  DATE '2026-01-31' AS base_date,
  1 AS months_to_add,
  DATE_ADD(DATE '2026-01-31', INTERVAL 1 MONTH) AS shifted_date;


-- =========================================================
-- Impala
-- =========================================================

-- Example 1: Add months
SELECT
  CAST('2026-01-15' AS DATE) AS base_date,
  2 AS months_to_add,
  ADD_MONTHS(CAST('2026-01-15' AS DATE), 2) AS shifted_date;

-- Example 2: Subtract months
SELECT
  CAST('2026-01-15' AS DATE) AS base_date,
  -3 AS months_to_add,
  ADD_MONTHS(CAST('2026-01-15' AS DATE), -3) AS shifted_date;

-- Example 3: Month-end behavior (check expected result)
SELECT
  CAST('2026-01-31' AS DATE) AS base_date,
  1 AS months_to_add,
  ADD_MONTHS(CAST('2026-01-31' AS DATE), 1) AS shifted_date;
