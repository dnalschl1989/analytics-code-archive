-- 01. BigQuery Standard SQL / 가상 데이터
WITH customer_monthly_usage AS (
  SELECT * FROM UNNEST([
    STRUCT('A001' AS customer_id, '2026-04' AS month, 25.0 AS data_gb, 69000 AS revenue),
    STRUCT('A001', '2026-05', 21.0, 69000),
    STRUCT('A001', '2026-06', 17.0, 65000),
    STRUCT('A001', '2026-07', 11.0, 65000),
    STRUCT('A002', '2026-04', 10.0, 45000),
    STRUCT('A002', '2026-05', 13.0, 45000),
    STRUCT('A002', '2026-06',  9.0, 45000),
    STRUCT('A002', '2026-07',  8.0, 45000),
    STRUCT('A003', '2026-04', 30.0, 70000),
    STRUCT('A003', '2026-05', 20.0, 70000),
    STRUCT('A003', '2026-07',  8.0, 70000),  -- 6월 누락
    STRUCT('A004', '2026-04', 30.0, 70000),
    STRUCT('A004', '2026-05', 25.0, 70000),
    STRUCT('A004', '2026-05', 24.0, 70000),  -- 5월 중복
    STRUCT('A004', '2026-07', 10.0, 70000)
  ])
),
scoped AS (
  SELECT customer_id, month, data_gb, revenue
  FROM customer_monthly_usage
  WHERE month IN ('2026-04', '2026-05', '2026-06', '2026-07')
),
sequenced AS (
  SELECT *,
    LAG(data_gb) OVER (PARTITION BY customer_id ORDER BY month) AS prev_usage
  FROM scoped
),
summary AS (
  SELECT
    customer_id,
    COUNT(*) AS record_count,
    COUNT(DISTINCT month) AS distinct_month_count,
    COUNTIF(data_gb < prev_usage) AS decline_months,
    MAX(IF(month = '2026-04', data_gb, NULL)) AS april_usage,
    MAX(IF(month = '2026-07', data_gb, NULL)) AS july_usage,
    MAX(IF(month = '2026-07', revenue, NULL)) AS july_revenue
  FROM sequenced GROUP BY customer_id
)
SELECT customer_id, april_usage, july_usage, july_revenue,
  ROUND(1 - SAFE_DIVIDE(july_usage, april_usage), 4) AS usage_drop_rate
FROM summary
WHERE record_count = 4
  AND distinct_month_count = 4
  AND decline_months = 3
  AND april_usage > 0
  AND july_usage <= april_usage * 0.70
  AND july_revenue >= 50000
ORDER BY usage_drop_rate DESC;
-- 예상 결과: A001 | 25.0 | 11.0 | 65000 | 0.56
