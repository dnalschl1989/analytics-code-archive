/*
Title: Current Date/Time and Monthly Boundaries (BigQuery)
Category: SQL Basic / Date
Purpose:
  - 현재 날짜/시간을 빠르게 확인
  - "이번 달" 기준 월 첫날/월 마지막날을 빠르게 생성
  - YYYYMMDD 형태(예: 20250201)로 포맷팅하는 패턴 제공

Use Case:
  - 리포트 기준일(월 시작/월 말) 생성
  - 배치/스케줄링 로직에서 기준 날짜 확인
  - 파라미터 테이블(캘린더 축) 생성
  - 월별 집계/필터 조건(WHERE) 작성

Input:
  - 없음 (CURRENT_DATE / CURRENT_DATETIME 사용)

Output:
  - current_date (DATE)
  - current_datetime (DATETIME)
  - first_date_of_month (DATE)
  - last_date_of_month (DATE)
  - yyyymmdd_string (STRING)

Dialect:
  - BigQuery

Notes:
  - 월 첫날/마지막날은 DATE 타입으로 관리하는 것을 권장
  - 문자열(YYYYMMDD) 포맷은 FORMAT_DATE 사용 (REGEXP_REPLACE보다 간단/명확)
*/

-- =========================================================
-- 1) Current date/time
-- =========================================================
SELECT
  CURRENT_DATE() AS current_date,
  CURRENT_DATETIME() AS current_datetime;

-- Day / Month as string (two digits)
SELECT
  FORMAT_DATETIME('%d', CURRENT_DATETIME()) AS day_2digit,   -- e.g. '13'
  FORMAT_DATETIME('%m', CURRENT_DATETIME()) AS month_2digit; -- e.g. '02'


-- =========================================================
-- 2) First day of current month
-- =========================================================
SELECT
  DATE_TRUNC(CURRENT_DATE(), MONTH) AS first_date_of_month;  -- e.g. 2025-02-01

-- As YYYYMMDD string (recommended)
SELECT
  FORMAT_DATE('%Y%m%d', DATE_TRUNC(CURRENT_DATE(), MONTH)) AS first_date_yyyymmdd; -- e.g. '20250201'


-- =========================================================
-- 3) Last day of current month
-- =========================================================
SELECT
  LAST_DAY(CURRENT_DATE()) AS last_date_of_month; -- e.g. 2025-02-28

-- As YYYYMMDD string (recommended)
SELECT
  FORMAT_DATE('%Y%m%d', LAST_DAY(CURRENT_DATE())) AS last_date_yyyymmdd; -- e.g. '20250228'


-- =========================================================
-- 4) Extract only day part (01 / 28 etc.)
-- =========================================================
-- First day -> '01'
SELECT
  FORMAT_DATE('%d', DATE_TRUNC(CURRENT_DATE(), MONTH)) AS first_day_only;

-- Last day -> '28' (or 30/31 depending on month)
SELECT
  FORMAT_DATE('%d', LAST_DAY(CURRENT_DATE())) AS last_day_only;


-- =========================================================
-- 5) Practical template: use month-end as "as-of date"
--    and calculate duration from a start date (YYYYMMDD string)
-- =========================================================
-- Example scenario:
-- - Start date is stored as 'YYYYMMDD' string
-- - Base month is stored as 'YYYYMM' string (e.g., '202503')
-- - Want to compute day/month difference until month-end
WITH sample AS (
  SELECT
    '20230115' AS suprt_strt_dt, -- YYYYMMDD string
    '202503'   AS base_yymm      -- YYYYMM string
)
SELECT
  PARSE_DATE('%Y%m%d', suprt_strt_dt) AS suprt_strt_date,
  LAST_DAY(PARSE_DATE('%Y%m', base_yymm)) AS last_date, -- '202503' -> 2025-03-31
  DATE_DIFF(LA_
