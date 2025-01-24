-- Explore order_items:
    SELECT
    order_id,
    COUNT(order_item_id) AS num_order_item
    FROM `Ecommerce_Sql_project.order_items`
    GROUP BY order_id
    ORDER BY num_order_item DESC;
  -- Evaluate the num item in one order:
  SELECT 
    num_order_item,
    COUNT(*) freq_order_item
  FROM (SELECT
      order_id,
    COUNT(order_item_id) AS num_order_item
    FROM `Ecommerce_Sql_project.order_items`
    GROUP BY order_id)
  GROUP BY num_order_item
  ORDER BY freq_order_item DESC;

--Aggregate table orders and order_items tables
  WITH agg_ord1 AS(  
    SELECT
      ord.order_id,
      SUM(ord_i.price + ord_i.freight_value) AS order_price
    FROM `Ecommerce_Sql_project.orders` ord
      JOIN `Ecommerce_Sql_project.order_items` ord_i ON ord.order_id= ord_i.order_id
    GROUP BY ord.order_id)
  SELECT
    MIN(agg_ord1.order_price) min_order_price,
    ROUND(AVG(agg_ord1.order_price),3) avg_order_price,
    MAX(agg_ord1.order_price) max_order_price
  FROM agg_ord1;

-- Order_product_and_shipping_costs
  SELECT
      ord.order_id,
      SUM(price) AS product_cost,
      SUM(freight_value) AS shipping_cost
  FROM
      `Ecommerce_Sql_project.orders` ord
      JOIN `Ecommerce_Sql_project.order_items` ord_i ON ord.order_id= ord_i.order_id
  WHERE order_status = 'delivered'
  GROUP BY ord.order_id;