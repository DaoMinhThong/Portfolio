-- Explore orders table:
    SELECT 
        order_status,
        COUNT(order_id)  numbers_of_orders
    FROM `Ecommerce_Sql_project.orders`
    GROUP BY order_status
    ORDER BY order_status;

--order_per_month
    SELECT
        FORMAT_TIMESTAMP('%m-%Y', order_purchase_timestamp) month,
        FORMAT_TIMESTAMP('%Y', order_purchase_timestamp) year,
        COUNT(*) order_count
    FROM `Ecommerce_Sql_project.orders`
    GROUP BY year, month
    ORDER BY year, month, order_count;

-- orders_per_day
    SELECT
        DATE(order_purchase_timestamp) AS day,
        COUNT(*) AS order_count
    FROM `Ecommerce_Sql_project.orders`
    GROUP BY day;

-- orders_per_day_of_the_week_and_hour
    WITH order_day_hour AS (
        SELECT
            FORMAT_TIMESTAMP( '%a', order_purchase_timestamp) AS day_of_week_name,
            FORMAT_TIMESTAMP( '%u', order_purchase_timestamp) AS day_of_week_int,
            CAST(FORMAT_TIMESTAMP( '%k', order_purchase_timestamp) AS INT64) AS hour
        FROM `Ecommerce_Sql_project.orders`
    )
    SELECT
        order_day_hour.day_of_week_name,
        COUNT( CASE WHEN order_day_hour.hour= 00 THEN 1 END) AS hour_00,
        COUNT( CASE WHEN order_day_hour.hour= 01 THEN 1 END) AS hour_01,
        COUNT( CASE WHEN order_day_hour.hour= 02 THEN 1 END) AS hour_02,
        COUNT( CASE WHEN order_day_hour.hour= 03 THEN 1 END) AS hour_03,
        COUNT( CASE WHEN order_day_hour.hour= 04 THEN 1 END) AS hour_04,
        COUNT( CASE WHEN order_day_hour.hour= 05 THEN 1 END) AS hour_05,
        COUNT( CASE WHEN order_day_hour.hour= 06 THEN 1 END) AS hour_06,
        COUNT( CASE WHEN order_day_hour.hour= 07 THEN 1 END) AS hour_07,
        COUNT( CASE WHEN order_day_hour.hour= 08 THEN 1 END) AS hour_08,
        COUNT( CASE WHEN order_day_hour.hour= 09 THEN 1 END) AS hour_09,
        COUNT( CASE WHEN order_day_hour.hour= 10 THEN 1 END) AS hour_10,
        COUNT( CASE WHEN order_day_hour.hour= 11 THEN 1 END) AS hour_11,
        COUNT( CASE WHEN order_day_hour.hour= 12 THEN 1 END) AS hour_12,
        COUNT( CASE WHEN order_day_hour.hour= 13 THEN 1 END) AS hour_13,
        COUNT( CASE WHEN order_day_hour.hour= 14 THEN 1 END) AS hour_14,
        COUNT( CASE WHEN order_day_hour.hour= 15 THEN 1 END) AS hour_15,
        COUNT( CASE WHEN order_day_hour.hour= 16 THEN 1 END) AS hour_16,
        COUNT( CASE WHEN order_day_hour.hour= 17 THEN 1 END) AS hour_17,
        COUNT( CASE WHEN order_day_hour.hour= 18 THEN 1 END) AS hour_18,
        COUNT( CASE WHEN order_day_hour.hour= 19 THEN 1 END) AS hour_19,
        COUNT( CASE WHEN order_day_hour.hour= 20 THEN 1 END) AS hour_20,
        COUNT( CASE WHEN order_day_hour.hour= 21 THEN 1 END) AS hour_21,
        COUNT( CASE WHEN order_day_hour.hour= 22 THEN 1 END) AS hour_22,
        COUNT( CASE WHEN order_day_hour.hour= 23 THEN 1 END) AS hour_23
    FROM order_day_hour
    GROUP BY order_day_hour.day_of_week_name, order_day_hour.day_of_week_int
    ORDER BY order_day_hour.day_of_week_int;



