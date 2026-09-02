
--tren revenue 2024 - 2025
WITH base AS (
  SELECT 
    DATE_TRUNC(o.created_at, MONTH) as bulan_tahun,
    COUNT(DISTINCT o.order_id) AS total_order,
    SUM(o.num_of_item) as total_item,
    SUM(oi.sale_price) as revenue_month
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
  total_item,
  ROUND(revenue_month,2) as revenue_month,
  ROUND((revenue_month - LAG(revenue_month) OVER (ORDER BY bulan_tahun ASC ))/ LAG(revenue_month) OVER (ORDER BY bulan_tahun ASC) * 100 ,2)  AS growth_revenue_pct
FROM base;
