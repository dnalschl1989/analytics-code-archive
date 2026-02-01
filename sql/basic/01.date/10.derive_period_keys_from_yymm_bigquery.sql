/*
Title: Derive Period Keys from YYYYMM (BigQuery)
Category: SQL Basic / Date
Purpose:
  - 'YYYYMM' 문자열을 DATE로 변환하고, M+N 이동월(ACT_YYMM) 생성
  - 피벗/집계를 쉽게 하기 위한 연/분기/반기 키(YY, YYQQ, YYH) 생성

Use Case:
  - BASE_YYMM 기준 다음달/이전달 매핑 (M+1, M-1, M+n)
  - 월 단위 데이터를 분기/반기 단위로 재분류
  - 리포트/피벗(연/분기/반기)용 파생 컬럼 생성

Input:
  - base_yymm (STRING) e.g., '202401'
  - offset_month (INT)  e.g., 1 (M+1)

Output:
  - act_yymm (STRING) e.g., '202402'
  - yy (STRING)       e.g., '24'
  - yyqq (STRING)     e.g., '24.1Q'
  - yyh (STRING)      e.g., '24.1H' or '24.2H'

Dialect:
  - BigQuery

Notes:
  - base_yymm는 반드시 'YYYYMM' 6자리 형태를 가정
  - 월 이동은 DATE_ADD(base_date, INTERVAL n MONTH)
  - YYYYMM 문자열 포맷은 FORMAT_DATE('%Y%m', date_col)
*/

-- =========================================================
-- 1) BASE_YYMM -> ACT_YYMM (M+N)
--    Example: BASE_YYMM='202401', offset=1 -> ACT_YYMM='202402'
-- =========================================================
WITH sample AS (
  SELECT '202401' AS base_yymm, 1 AS offset_month
)
SELECT
  base_yymm,
  offset_month,

  -- BASE_YYMM을 해당 월의 1일로 변환
  PARSE_DATE('%Y%m', base_yymm) AS base_month_start_date,

  -- M+N 이동 (월 단위)
  DATE_ADD(PARSE_DATE('%Y%m', base_yymm), INTERVAL offset_month MONTH) AS shifted_month_start_date,

  -- 이동된 월을 YYYYMM 문자열로 변환
  FORMAT_DATE('%Y%m', DATE_ADD(PARSE_DATE('%Y%m', base_yymm), INTERVAL offset_month MONTH)) AS act_yymm
FROM sample;


-- =========================================================
-- 2) Period keys for pivoting: YY / YYQQ / YYH
--    ACT_YYMM is assumed as 'YYYYMM' (6 chars)
-- =========================================================
WITH sample AS (
  SELECT '202402' AS act_yymm
)
SELECT
  act_yymm,

  -- YY (e.g., '24')
  SUBSTR(act_yymm, 3, 2) AS yy,

  -- YYQQ (e.g., '24.1Q')
  CASE
    WHEN SUBSTR(act_yymm, 5, 2) IN ('01','02','03') THEN CONCAT(SUBSTR(act_yymm, 3, 2), '.1Q')
    WHEN SUBSTR(act_yymm, 5, 2) IN ('04','05','06') THEN CONCAT(SUBSTR(act_yymm, 3, 2), '.2Q')
    WHEN SUBSTR(act_yymm, 5, 2) IN ('07','08','09') THEN CONCAT(SUBSTR(act_yymm, 3, 2), '.3Q')
    WHEN SUBSTR(act_yymm, 5, 2) IN ('10','11','12') THEN CONCAT(SUBSTR(act_yymm, 3, 2), '.4Q')
  END AS yyqq,

  -- YYH (Half-year key, e.g., '24.1H' / '24.2H')
  CASE
    WHEN SUBSTR(act_yymm, 5, 2) IN ('01','02','03','04','05','06') THEN CONCAT(SUBSTR(act_yymm, 3, 2), '.1H')
    WHEN SUBSTR(act_yymm, 5, 2) IN ('07','08','09','10','11','12') THEN CONCAT(SUBSTR(act_yymm, 3, 2), '.2H')
  END AS yyh
FROM sample;


-- =========================================================
-- 3) Practical combined pattern (base_yymm -> act_yymm -> yy/yyqq/yyh)
-- =========================================================
WITH base AS (
  SELECT '202401' AS base_yymm, 1 AS offset_month
),
derived AS (
  SELECT
    base_yymm,
    offset_month,
    FORMAT_DATE(
      '%Y%m',
      DATE_ADD(PARSE_DATE('%Y%m', base_yymm), INTERVAL offset_month MONTH)
    ) AS act_yymm
  FROM base
)
SELECT
  base_yymm,
  act_yymm,
  SUBSTR(act_yymm, 3, 2) AS yy,
  CASE
    WHEN SUBSTR(act_yymm, 5, 2) IN ('01','02','03') THEN CONCAT(SUBSTR(act_yymm, 3, 2), '.1Q')
    WHEN SUBSTR(act_yymm, 5, 2) IN ('04','05','06') THEN CONCAT(SUBSTR(act_yymm, 3, 2), '.2Q')
    WHEN SUBSTR(act_yymm, 5, 2) IN ('07','08','09') THEN CONCAT(SUBSTR(act_yymm, 3, 2), '.3Q')
    WHEN SUBSTR(act_yymm, 5, 2) IN ('10','11','12') THEN CONCAT(SUBSTR(act_yymm, 3, 2), '.4Q')
  END AS yyqq,
  CASE
    WHEN SUBSTR(act_yymm, 5, 2) IN ('01','02','03','04','05','06') THEN CONCAT(SUBSTR(act_yymm, 3, 2), '.1H')
    WHEN SUBSTR(act_yymm, 5, 2) IN ('07','08','09','10','11','12') THEN CONCAT(SUBSTR(act_yymm, 3, 2), '.2H')
  END AS yyh
FROM derived;
