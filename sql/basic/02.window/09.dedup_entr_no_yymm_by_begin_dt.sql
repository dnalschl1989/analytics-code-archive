/*
Title: Dedup by (ENTR_NO, P_YYYYMM) Keeping Latest BEGIN_DT
Category: SQL Basic / Window
Purpose:
  - (ENTR_NO, P_YYYYMM) 기준 중복 레코드가 있을 때
    BEGIN_DT 최신(내림차순) 1건만 남기고 제거

Use Case:
  - 월별 스냅샷 테이블에서 가입번호/월 기준 중복 제거
  - 최신 시작일(BEGIN_DT) 기준 대표 레코드 1건 추출

Dialect:
  - BigQuery

Notes:
  - BigQuery에서는 QUALIFY를 사용하면 서브쿼리 없이 필터 가능
  - BEGIN_DT 동점이 있을 수 있으면 tie-breaker 컬럼(예: UPDATED_AT, LOAD_TS) 추가 권장
*/

-- Example (template)
-- Replace `your_table` and columns as needed
SELECT
  *
FROM `your_project.your_dataset.your_table`
QUALIFY
  ROW_NUMBER() OVER (
    PARTITION BY ENTR_NO, P_YYYYMM
    ORDER BY BEGIN_DT DESC
  ) = 1;

-- Tie-breaker example (recommended if BEGIN_DT duplicates exist)
-- QUALIFY
--   ROW_NUMBER() OVER (
--     PARTITION BY ENTR_NO, P_YYYYMM
--     ORDER BY BEGIN_DT DESC, UPDATED_AT DESC
--   ) = 1;
