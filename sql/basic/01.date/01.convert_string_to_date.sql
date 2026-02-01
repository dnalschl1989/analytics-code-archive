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
Title: String to Date Conversion
Category: SQL Basic / Date
Purpose:
  - 문자열 날짜를 DATE 타입으로 변환
*/

-- Example 1: YYYYMMDD → DATE
SELECT
  PARSE_DATE('%Y%m%d', '20260131') AS converted_date;

-- Example 2: YYYY-MM-DD → DATE
SELECT
  CAST('2026-01-31' AS DATE) AS converted_date;

-- Example 3: Invalid format handling
SELECT
  SAFE.PARSE_DATE('%Y%m%d', '2026-0131') AS converted_date;
