/*
Title: Calculate Date Difference in DAY / MONTH (BigQuery)
Category: SQL Basic / Date
Purpose:
  - DATE 타입 기준으로 두 날짜 간 차이를 DAY 또는 MONTH 단위로 계산
  - 문자열(YYYYMMDD/YYYYMM) 적재 데이터를 DATE로 변환한 뒤 차이 계산까지 수행

Use Case:
  - 서비스 시작~종료 기간(일/월) 산출
  - 월별 리포트 기준일 간 GAP 계산 (예: 2025-01-01 ~ 2025-02-01 = 1 month)
  - 가입/지원 시작 대비 누적 기간 산출

Input:
  - start_dt_string (STRING) e.g., '20250101'
  - end_dt_string   (STRING) e.g., '20250215'
  - base_yymm (STRING) e.g., '202503'

Output:
  - diff_days (INT64)
  - diff_months (INT64)

Dialect:
  - BigQuery

Notes:
  - DATE끼리 비교할 때는 DATE_DIFF를 사용
  - DATETIME_DIFF는 DATETIME 타입끼리 비교할 때 사용 (혼용 주의)
  - MONTH 차이는 "달력 기준" 계산이므로, 기준일(월 1일 등)을 통일하면 해석이 명확해짐
*/

-- =========================================================
-- Example 1) YYYYMMDD 문자열 -> DATE 변환 후, DAY 차이 계산
-- =========================================================
WITH t AS (
  SELECT
    '20250101' AS svc_strt_dt,
    '20250215' AS svc_end_dt
)
SELECT
  PARSE_DATE('%Y%m%d', svc_strt_dt) AS vas_strt_date,
  PARSE_DATE('%Y%m%d', svc_end_dt)  AS vas_end_date,
  DATE_DIFF(
    PARSE_DATE('%Y%m%d', svc_end_dt),
    PARSE_DATE('%Y%m%d', svc_strt_dt),
    DAY
  ) AS use_day
FROM t;

-- =========================================================
-- Example 2) YYYYMMDD 문자열 -> DATE 변환 후, MONTH 차이 계산
-- (월 단위는 기준일 정렬이 중요. 보통 '월 1일' 기준으로 맞춤)
-- =========================================================
WITH t AS (
  SELECT
    '20250101' AS svc_strt_dt,
    '20250201' AS svc_end_dt
)
SELECT
  PARSE_DATE('%Y%m%d', svc_strt_dt) AS vas_strt_date,
  PARSE_DATE('%Y%m%d', svc_end_dt)  AS vas_end_date,
  DATE_DIFF(
    PARSE_DATE('%Y%m%d', svc_end_dt),
    PARSE_DATE('%Y%m%d', svc_strt_dt),
    MONTH
  ) AS use_month
FROM t;

-- =========================================================
-- Example 3) "매월 1일 기준" 월 차이 계산 (YYYYMM -> DATE 변환)
-- =========================================================
WITH t AS (
  SELECT
    '202501' AS sale_yymm,
    '202503' AS out_yymm
)
SELECT
  PARSE_DATE('%Y%m', sale_yymm) AS sale_date,   -- 월 시작일
  PARSE_DATE('%Y%m', out_yymm)  AS out_date,    -- 월 시작일
  DATE_DIFF(PARSE_DATE('%Y%m', out_yymm), PARSE_DATE('%Y%m', sale_yymm), MONTH) AS use_month
FROM t;

-- =========================================================
-- Example 4) 월 말일 기준 LAST_DAY 사용 + DAY/MONTH 차이
-- (네가 준 추가 예시를 "일반화"한 형태)
-- =========================================================
WITH base AS (
  SELECT
    '20230115' AS suprt_strt_dt,
    '202503'   AS base_yymm
)
SELECT
  PARSE_DATE('%Y%m%d', suprt_strt_dt) AS suprt_strt_date,
  LAST_DAY(PARSE_DATE('%Y%m', base_yymm)) AS last_date,  -- 예: '202503' -> 2025-03-31
  DATE_DIFF(LAST_DAY(PARSE_DATE('%Y%m', base_yymm)), PARSE_DATE('%Y%m%d', suprt_strt_dt), DAY)   AS use_day,
  DATE_DIFF(LAST_DAY(PARSE_DATE('%Y%m', base_yymm)), PARSE_DATE('%Y%m%d', suprt_strt_dt), MONTH) AS use_month
FROM base;
