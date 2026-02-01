/*
Title: Expand Monthly Records with UNNEST and GENERATE_ARRAY
Category: SQL Basic / Date
Purpose:
  - 시작일~종료일 구간을 월 단위로 확장하여 레코드 생성
  - UNNEST + GENERATE_ARRAY를 활용한 기간 확장 패턴 정리

Use Case:
  - 할인/프로모션/계약 기간을 월 단위로 풀어서 관리
  - 월별 기준 테이블(BASE_YYMM) 생성
  - 기간형 데이터의 월 단위 집계 전처리

Dialect:
  - BigQuery

Key Pattern:
  - GENERATE_ARRAY(0, month_diff) + UNNEST
*/

-- =========================================================
-- 1) Source data preparation
-- =========================================================
WITH base AS (
  SELECT
    *,
    -- 최초 요청일 (DATE)
    PARSE_DATE('%Y%m%d', REPLACE(SUBSTR(CAST(CNTC_DCNT_FRST_RQST_DTTM AS STRING), 1, 10), '-', '')) AS rqst_date,

    -- 종료일 (DATE)
    PARSE_DATE('%Y%m%d', REPLACE(SUBSTR(CAST(CNTC_DCNT_END_DTTM AS STRING), 1, 10), '-', '')) AS end_date,

    -- 월 확장 가능 여부 판단
    CASE
      WHEN PARSE_DATE('%Y%m%d', REPLACE(SUBSTR(CAST(CNTC_DCNT_END_DTTM AS STRING), 1, 10), '-', ''))
         > LAST_DAY(PARSE_DATE('%Y%m%d', REPLACE(SUBSTR(CAST(CNTC_DCNT_FRST_RQST_DTTM AS STRING), 1, 10), '-', '')))
      THEN '1해당'
      ELSE '2미해당'
    END AS yn,

    -- 확장할 월 수 계산
    GENERATE_ARRAY(
      0,
      TIMESTAMP_DIFF(CNTC_DCNT_END_DTTM, CNTC_DCNT_FRST_RQST_DTTM, MONTH)
    ) AS months
  FROM /*테이블A*/
  WHERE 1 = 1
    AND /*조건1*/
    AND /*조건2*/
)

-- =========================================================
-- 2) Expand rows by month (UNNEST)
-- =========================================================
SELECT
  1 AS idx,

  -- 기준 월 (YYYYMM)
  FORMAT_DATE(
    '%Y%m',
    DATE_TRUNC(DATE_ADD(rqst_date, INTERVAL n MONTH), MONTH)
  ) AS base_yymm,

  -- 기준 월 시작일
  DATE_TRUNC(DATE_ADD(rqst_date, INTERVAL n MONTH), MONTH) AS base_yymm_date,

  -- 원본 컬럼 유지
  base.*

FROM base
CROSS JOIN UNNEST(months) AS n
WHERE 1 = 1
  AND yn = '1해당';
