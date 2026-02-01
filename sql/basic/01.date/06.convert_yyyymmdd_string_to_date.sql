/*
Title: Convert YYYYMMDD / YYYYMM String to DATE (BigQuery)
Category: SQL Basic / Date
Purpose:
  - '20250101' 형태(STRING)의 날짜 컬럼을 DATE로 변환
  - '202501' 또는 '20250101' 형태의 기준월/기준일을 DATE로 정규화

Use Case:
  - 외부/레거시 시스템에서 YYYYMMDD 문자열로 적재된 날짜 컬럼 정제
  - 월 단위(YYYYMM) 기준일 생성 (월 시작/월 말)

Input:
  - yyyymmdd_string (STRING) e.g., '20250101'
  - yyyymm_string   (STRING) e.g., '202501' or '202501'

Output:
  - parsed_date (DATE)
  - month_start_date (DATE)
  - month_end_date (DATE)

Dialect:
  - BigQuery

Notes:
  - PARSE_DATE는 포맷이 맞지 않으면 오류가 날 수 있음
  - 안전하게 처리하려면 SAFE.PARSE_DATE 사용 권장
*/

-- Example 1) YYYYMMDD(문자열) -> DATE
SELECT
  '20250101' AS svc_strt_dt,
  '20250215' AS svc_end_dt,
  PARSE_DATE('%Y%m%d', '20250101') AS svc_strt_date,
  PARSE_DATE('%Y%m%d', '20250215') AS svc_end_date;

-- Example 1-1) 안전 파싱 (실무 권장)
SELECT
  '20250101' AS svc_strt_dt,
  '2025-0101' AS bad_dt,
  SAFE.PARSE_DATE('%Y%m%d', '20250101') AS ok_date,
  SAFE.PARSE_DATE('%Y%m%d', '2025-0101') AS bad_date_returns_null;

-- Example 2) YYYYMM(문자열) -> 월 시작일 DATE
SELECT
  '202501' AS base_yymm,
  PARSE_DATE('%Y%m', '202501') AS month_start_date;

-- Example 3) YYYYMM(문자열) -> 월 말일 DATE
SELECT
  '202503' AS base_yymm,
  LAST_DAY(PARSE_DATE('%Y%m', '202503')) AS month_end_date;
