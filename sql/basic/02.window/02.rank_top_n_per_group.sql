/*
Title: Top-N per Group with RANK/DENSE_RANK
Category: SQL Basic / Window
Purpose:
  - 그룹(예: 채널/지역)별 상위 N개 항목 추출

Use Case:
  - 채널별 매출 Top 3 상품
  - 지역별 가입자 증가 Top 5 지점
Dialect:
  - BigQuery
Notes:
  - 동점 포함 여부에 따라 RANK vs ROW_NUMBER 선택
*/

WITH sample AS (
  SELECT 'web' AS channel, 'p1' AS product, 100 AS sales UNION ALL
  SELECT 'web', 'p2', 90 UNION ALL
  SELECT 'web', 'p3', 90 UNION ALL
  SELECT 'app', 'p4', 200 UNION ALL
  SELECT 'app', 'p5', 150
),
ranked AS (
  SELECT
    *,
    DENSE_RANK() OVER (PARTITION BY channel ORDER BY sales DESC) AS rnk
  FROM sample
)
SELECT * EXCEPT(rnk)
FROM ranked
WHERE rnk <= 2
ORDER BY channel, sales DESC;
