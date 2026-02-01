/*
Title: Join with Date Range Condition
Purpose:
  - 특정 기간에 유효한 데이터만 결합
Use Case:
  - 계약 기간 내 거래 매칭
*/

SELECT
  c.contract_id,
  o.order_id
FROM contracts c
LEFT JOIN orders o
  ON c.user_id = o.user_id
 AND o.order_dt BETWEEN c.start_dt AND c.end_dt;
