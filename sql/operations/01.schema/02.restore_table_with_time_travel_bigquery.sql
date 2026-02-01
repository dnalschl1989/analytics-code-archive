/*
Title: Restore Table with BigQuery Time Travel
Category: SQL Operations / Recovery
Purpose:
  - BigQuery Time Travel 기능을 활용하여
    테이블을 과거 특정 시점 상태로 복구

Use Case:
  - 실수로 DELETE / TRUNCATE / CREATE OR REPLACE 수행한 경우
  - 배치 오류로 데이터가 잘못 적재된 경우
  - 이전 상태 데이터를 임시 테이블로 복구하여 검증 후 재적용

Constraints:
  - 최대 7일 이내 시점만 복구 가능
  - 테이블이 한 번 이상 저장(commit)된 이력이 있어야 함
  - Time Travel 보존 기간은 프로젝트/데이터셋 설정에 따라 다를 수 있음

Dialect:
  - BigQuery

Notes:
  - 원본 테이블을 직접 덮어쓰기 전에 반드시 TMP 테이블로 복구 권장
  - 복구 시점은 TIMESTAMP 기준 (UTC)
*/

-- =========================================================
-- Example: restore table to state from N hours ago
-- =========================================================
-- Target table to restore:
-- gcp-sbx-edp-rslx.DLKC2RSLX.ENTR_ALL_202301

CREATE OR REPLACE TABLE `gcp-sbx-edp-rslx.DLKC2RSLX.ENTR_ALL_202301_TMP` AS
SELECT
  *
FROM `gcp-sbx-edp-rslx.DLKC2RSLX.ENTR_ALL_202301`
FOR SYSTEM_TIME AS OF
  TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 3 HOUR);
