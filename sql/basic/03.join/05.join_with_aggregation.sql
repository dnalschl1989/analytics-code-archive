/*
Title: Join After Aggregation
Purpose:
  - 집계 후 JOIN으로 데이터 증폭 방지
Use Case:
  - 고객별 주문 합계 결합
*/

WITH order_sum AS (
  SELECT
    user_id,
    SUM(amount) AS total_amount
  FROM orders
  GROUP BY user_id
)
SELECT
  u.user_id,
  u.name,
  o.total_amount
FROM users u
LEFT JOIN order_sum o
  ON u.user_id = o.user_id;
