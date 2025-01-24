-- most order products:
  SELECT 
    pro.product_id,
    trs.string_field_1,
    COUNT(oi.order_id) num_orders
  FROM `Ecommerce_Sql_project.order_items` oi
  JOIN `Ecommerce_Sql_project.products` pro ON oi.product_id= pro.product_id
  JOIN `Ecommerce_Sql_project.product_category_name_translation` trs
  ON pro.product_category_name= trs.string_field_0
  GROUP BY pro.product_id, trs.string_field_1
  HAVING num_orders >5;

-- products_often_ordered_together
  SELECT
      oi1.product_id AS product_id1,
      oi2.product_id AS product_id2,
      COUNT(DISTINCT oi1.order_id) AS common_orders_count
  FROM `Ecommerce_Sql_project.order_items` AS oi1
      JOIN `Ecommerce_Sql_project.order_items` AS oi2
          ON oi1.order_id = oi2.order_id -- Same order
          AND oi1.product_id < oi2.product_id -- Avoid permutations
  WHERE oi1.product_id IN (
        SELECT product_id FROM (
        SELECT 
          pro.product_id,
          trs.string_field_1,
          COUNT(oi.order_id) num_orders
        FROM `Ecommerce_Sql_project.order_items` oi
        JOIN `Ecommerce_Sql_project.products` pro ON oi.product_id= pro.product_id
        JOIN `Ecommerce_Sql_project.product_category_name_translation` trs
        ON pro.product_category_name= trs.string_field_0
        GROUP BY pro.product_id, trs.string_field_1
        HAVING num_orders >5
      ))
  GROUP BY product_id1, product_id2
  HAVING COUNT(DISTINCT oi1.order_id) > 5;

