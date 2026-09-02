-- AOV per bulan per tahun 
WITH base AS (
  SELECT 
    DATE_TRUNC(o.created_at, MONTH) as bulan_tahun,
    COUNT(DISTINCT o.order_id) AS total_order,
    SUM(oi.sale_price) as revenue_month,
    SUM(oi.sale_price) / COUNT(DISTINCT o.order_id) as avg_order_value
  FROM bigquery-public-data.thelook_ecommerce.orders o
  JOIN bigquery-public-data.thelook_ecommerce.order_items oi
    USING(order_id)
  WHERE o.status = 'Complete' AND (FORMAT_DATE('%Y', o. created_at) = '2024' OR FORMAT_DATE('%Y', o.created_at) = '2025')
  GROUP BY bulan_tahun
  ORDER BY bulan_tahun ASC
)

SELECT
  FORMAT_DATE('%m-%Y',bulan_tahun) bulan_tahun,
  total_order,
  ROUND(revenue_month,2) as revenue_month,
  ROUND(avg_order_value,2) as avg_order_value,
  ROUND((avg_order_value - LAG(avg_order_value) OVER (ORDER BY bulan_tahun ASC ))/ LAG(avg_order_value) OVER (ORDER BY bulan_tahun ASC) * 100 ,2)  AS growth_pct_aov
FROM base;