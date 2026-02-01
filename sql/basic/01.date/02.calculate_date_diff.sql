/*
Title: String to Date Conversion
Category: SQL Basic / Date
Purpose:
  - 문자열 형태의 날짜 컬럼을 DATE 타입으로 변환
  - 서로 다른 포맷의 날짜를 통일된 기준으로 처리

Use Case:
  - 로그 테이블의 yyyymmdd 문자열 처리
  - 외부 시스템 수집 데이터 날짜 정제

Input:
  - string_date (VARCHAR / STRING)
  - format (optional)

Output:
  - converted_date (DATE)

Dialect:
  - BigQuery / Impala / ANSI SQL

Notes:
  - 잘못된 포맷 입력 시 NULL 반환
  - DB별 함수 차이 주의
*/
/*
Title: Date Difference Calculation
Category: SQL Basic / Date
Purpose:
  - 두 날짜 간 일/월/년 차이 계산

Use Case:
  - 가입일 대비 경과 기간 계산
  - 캠페인 반응까지 소요 일수 산출
*/

-- Days difference
SELECT
  DATE_DIFF(DATE '2026-02-01', DATE '2026-01-01', DAY) AS diff_days;

-- Months difference
SELECT
  DATE_DIFF(DATE '2026-02-01', DATE '2025-11-01', MONTH) AS diff_months;
