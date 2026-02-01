/*
Title: Anti Join to Find Missing Records
Purpose:
  - 기준 테이블에는 있으나 상대 테이블에는 없는 데이터 찾기
Use Case:
  - 미구매 고객
  - 로그 없는 사용자
*/

SELECT
  a.user_id
FROM users a
LEFT JOIN orders b
  ON a.user_id = b.user_id
WHERE b.user_id IS NULL;
