-- produk dengan revenue tertinggi di tahun 2024 - 2025
SELECT 
  p.category,
  COALESCE(p.brand, 'Unknown') AS brand,
  COUNT(DISTINCT o.order_id) AS total_order,
  COUNT(oi.product_id) AS total_item,
  ROUND(SUM(oi.sale_price),2) as revenue
FROM bigquery-public-data.thelook_ecommerce.orders o
JOIN bigquery-public-data.thelook_ecommerce.order_items oi
  USING(order_id)
JOIN bigquery-public-data.thelook_ecommerce.products p
  ON p.id = oi.product_id
  WHERE o.status = 'Complete' AND oi.status = 'Complete' AND  (FORMAT_DATE('%Y', o. created_at) = '2024' OR FORMAT_DATE('%Y', o.created_at) = '2025')
GROUP BY
  p.category,
  p.brand
ORDER BY revenue DESC;

