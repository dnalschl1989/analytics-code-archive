/*
Title: Share of Total within Partition
Category: SQL Basic / Window
Purpose:
  - 그룹 내 합계 대비 비중(점유율) 계산

Use Case:
  - 채널 내 상품 매출 점유율
  - 세그먼트 내 고객 비중
Dialect:
  - BigQuery
Notes:
  - 분모가 0일 수 있으니 SAFE_DIVIDE 권장
*/

WITH sample AS (
  SELECT 'web' AS channel, 'p1' AS product, 100 AS sales UNION ALL
  SELECT 'web', 'p2', 50 UNION ALL
  SELECT 'app', 'p3', 200
)
SELECT
  channel,
  product,
  sales,
  SUM(sales) OVER (PARTITION BY channel) AS channel_total,
  SAFE_DIVIDE(sales, SUM(sales) OVER (PARTITION BY channel)) AS share_in_channel
FROM sample
ORDER BY channel, sales DESC;
