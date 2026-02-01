/*
Title: Basic INNER JOIN
Category: SQL Basic / Join
Purpose:
  - 두 테이블 모두에 존재하는 데이터만 결합
Use Case:
  - 유효 고객 + 거래 데이터 결합
Dialect:
  - BigQuery
*/

SELECT
  a.user_id,
  a.name,
  b.order_id,
  b.amount
FROM users a
INNER JOIN orders b
  ON a.user_id = b.user_id;
