/*
Title: Describe Table Columns (BigQuery)
Category: SQL Basic / Schema
Purpose:
  - 특정 테이블의 컬럼명, 데이터 타입, NULL 허용 여부를 조회
  - 테이블 구조(스키마) 빠른 확인

Use Case:
  - 신규 테이블 분석 전 컬럼 구조 파악
  - 쿼리 작성 전 데이터 타입 확인
  - 운영/분석 테이블 스키마 점검

Input:
  - project_id
  - dataset_id
  - table_name

Output:
  - column_name   : 컬럼명
  - data_type     : 데이터 타입 (STRING, INT64, DATE 등)
  - is_nullable   : NULL 허용 여부 (YES / NO)

Dialect:
  - BigQuery

Notes:
  - INFORMATION_SCHEMA.COLUMNS는 BigQuery 예약 메타데이터 뷰
  - INFORMATION_SCHEMA 경로는 수정하지 말 것
*/

-- =========================================================
-- Example: describe table schema
-- =========================================================
-- Target table:
-- gcp-sbx-edp-rslx.DLKC2RSLX.ENTR_DLR_2025

SELECT
  column_name,     -- 컬럼명
  data_type,       -- 데이터 타입 (STRING, INT64, DATE 등)
  is_nullable      -- NULL 허용 여부 (YES / NO)
FROM `gcp-sbx-edp-rslx.DLKC2RSLX.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'ENTR_DLR_2025'
ORDER BY ordinal_position;
