-- Order_stage_times_top_10_citites 
    SELECT
        UPPER(customer_city) AS city,
        ROUND(AVG(DATE_DIFF(
            CAST(order_approved_at AS DATE), CAST(order_purchase_timestamp AS DATE), DAY)),2) AS approved,
        ROUND(AVG(DATE_DIFF(
            CAST(order_delivered_carrier_date AS DATE), CAST(order_approved_at AS DATE), DAY)),2) AS delivered_to_carrier,
        ROUND(AVG(DATE_DIFF(
            CAST(order_delivered_customer_date AS DATE), CAST(order_delivered_carrier_date AS DATE), DAY)),2) AS delivered_to_customer,
        ROUND(AVG(DATE_DIFF(
            CAST(order_estimated_delivery_date AS DATE), CAST(order_delivered_customer_date AS DATE), DAY)),2) AS estimated_delivery
    FROM `Ecommerce_Sql_project.orders` ord
    JOIN `Ecommerce_Sql_project.Customers` cus
        ON ord.customer_id = cus.customer_id
    WHERE customer_city IN (
        SELECT customer_city 
        FROM (
        SELECT
            cus.customer_city,
            COUNT(cus.customer_id) num_customers
        FROM `Ecommerce_Sql_project.Customers` cus

    GROUP BY cus.customer_city
    ORDER BY num_customers DESC
    LIMIT 10))
    GROUP BY customer_city
    ORDER BY approved + delivered_to_carrier + delivered_to_customer DESC;

--Daily avg shipping time
    SELECT
    FORMAT_TIMESTAMP('%Y-%m',order_purchase_timestamp) order_purchase_month,
    ROUND( AVG( DATE_DIFF(DATE(order_delivered_customer_date), DATE(order_purchase_timestamp), DAY)),2) avg_shipping_time 
    FROM `Ecommerce_Sql_project.orders`
    GROUP BY order_purchase_month
    ORDER BY order_purchase_month DESC
    





