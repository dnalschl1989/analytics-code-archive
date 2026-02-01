/*
Title: Semi Join for Existence Filtering
Purpose:
  - 상대 테이블 존재 여부로 기준 테이블 필터링
Use Case:
  - 구매 이력이 있는 고객만 조회
*/

SELECT *
FROM users a
WHERE EXISTS (
  SELECT 1
  FROM orders b
  WHERE a.user_id = b.user_id
);
