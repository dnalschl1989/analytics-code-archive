/*
Title: LEFT JOIN to Keep Base Table
Purpose:
  - 기준 테이블의 모든 행을 유지하면서 보조 정보 결합
Use Case:
  - 전체 고객 + 선택적 활동 정보
*/

SELECT
  a.user_id,
  a.name,
  b.last_login_dt
FROM users a
LEFT JOIN logins b
  ON a.user_id = b.user_id;
