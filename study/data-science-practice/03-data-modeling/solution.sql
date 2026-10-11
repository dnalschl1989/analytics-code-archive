-- 03. BigQuery Standard SQL / 가상 데이터
WITH revenue AS (
  SELECT 'A001' AS sub_id, '202609' AS yyyymm, 70000 AS revenue
), addon AS (
  SELECT 'A001' AS sub_id, '202609' AS yyyymm, 'Netflix' AS product_id, 10000 AS addon_revenue
  UNION ALL SELECT 'A001', '202609', 'Music', 5000
), commission AS (
  SELECT 'A001' AS sub_id, DATE '2026-09-01' AS pay_date, 20000 AS commission
  UNION ALL SELECT 'A001', DATE '2026-09-15', 10000
  UNION ALL SELECT 'A001', DATE '2026-09-20', 5000
), revenue_monthly AS (
  SELECT sub_id, yyyymm, SUM(revenue) AS base_revenue
  FROM revenue GROUP BY sub_id, yyyymm
), addon_monthly AS (
  SELECT sub_id, yyyymm, SUM(addon_revenue) AS addon_revenue
  FROM addon GROUP BY sub_id, yyyymm
), commission_monthly AS (
  SELECT sub_id, FORMAT_DATE('%Y%m', pay_date) AS yyyymm,
    SUM(commission) AS commission
  FROM commission GROUP BY sub_id, FORMAT_DATE('%Y%m', pay_date)
)
SELECT r.sub_id, r.yyyymm, r.base_revenue,
  COALESCE(a.addon_revenue, 0) AS addon_revenue,
  COALESCE(c.commission, 0) AS commission,
  r.base_revenue + COALESCE(a.addon_revenue, 0)
    - COALESCE(c.commission, 0) AS simple_margin
FROM revenue_monthly r
LEFT JOIN addon_monthly a USING (sub_id, yyyymm)
LEFT JOIN commission_monthly c USING (sub_id, yyyymm)
ORDER BY r.sub_id, r.yyyymm;
-- 예상 결과: A001 | 202609 | 70000 | 15000 | 35000 | 50000
-- 주의: base_revenue와 addon_revenue의 포함관계는 사전에 검증해야 합니다.
