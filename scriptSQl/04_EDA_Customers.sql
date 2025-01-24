-- Which customer paid the most money?
    SELECT 
        customer_unique_id, 
        SUM(payment_value) AS total_spent
    FROM `Ecommerce_Sql_project.Customers` cus
    JOIN `Ecommerce_Sql_project.orders` ord ON cus.customer_id= ord.customer_id
    JOIN `Ecommerce_Sql_project.order_payments` ord_pay ON ord.order_id= ord_pay.order_id
    GROUP BY customer_unique_id
    ORDER BY total_spent DESC
    LIMIT 20;

-- Where city have the most of customer approved?
    SELECT
        customer_city city,
        COUNT( customer_unique_id) number_customers
    FROM `Ecommerce_Sql_project.Customers` 
    GROUP BY customer_city
    ORDER BY number_customers DESC;
-- Classify customer segmentation
    --CREATE OR REPLACE TABLE `Ecommerce_Sql_project.customer_segmentation` AS
    WITH -- Evaluate via RFM score: DIVIDE DATASET INTO 5 LABEL,
        recently_score AS( -- R base max(order_purchase) of customer
            SELECT
                customer_unique_id,
                MAX(CAST(ord.order_purchase_timestamp AS DATE)) last_purchased,
                NTILE(5) OVER( ORDER BY MAX(CAST(ord.order_purchase_timestamp AS DATE)) DESC) recency
            FROM `Ecommerce_Sql_project.Customers` cus
            JOIN `Ecommerce_Sql_project.orders` ord ON cus.customer_id= ord.customer_id
            GROUP BY cus.customer_unique_id
        ), 
        frequency AS( -- F= the number orders of customer 
            SELECT
                customer_unique_id,
                COUNT(CAST(ord.order_purchase_timestamp AS DATE)) total_orders,
                NTILE(5) OVER( ORDER BY COUNT(CAST(ord.order_purchase_timestamp AS DATE)) DESC) frequency
            FROM `Ecommerce_Sql_project.Customers` cus
            JOIN `Ecommerce_Sql_project.orders` ord ON cus.customer_id= ord.customer_id
            GROUP BY cus.customer_unique_id
        ), 
        monetary AS( -- M= the total capacity of money which customer paid
            SELECT
                customer_unique_id,
                ROUND(SUM(ord_it.price),2) total_spent,
                NTILE(5) OVER( ORDER BY SUM(ord_it.price) DESC) monetary
            FROM `Ecommerce_Sql_project.Customers` cus
            JOIN `Ecommerce_Sql_project.orders` ord ON cus.customer_id= ord.customer_id
            JOIN `Ecommerce_Sql_project.order_items` ord_it ON ord.order_id= ord_it.order_id
            GROUP BY cus.customer_unique_id
        ),
        dim_rfm AS(
            SELECT '5' AS recency, '5' AS frequency, '5' AS monetary, 'VIP' AS cus_segmentation
            UNION ALL
            SELECT '1', '1', '1', 'Churned'
            UNION ALL
            SELECT '5', '1', '1', 'New'
            UNION ALL
            SELECT '1', '5', '5', 'At Risk'
            UNION ALL
            SELECT '3', '3', '3', 'Potential'
        )

    -- Classify cus_segmentation:
    SELECT
        r.customer_unique_id,r.last_purchased,fr.total_orders,mo.total_spent,
        CASE
            WHEN CAST(dim_rfm.recency AS INT64) = r.recency 
                AND CAST(dim_rfm.frequency AS INT64) = fr.frequency 
                AND CAST(dim_rfm.monetary AS INT64) = mo.monetary THEN dim_rfm.cus_segmentation
            ELSE 'Others'  -- Trường hợp không thuộc các nhóm trên
        END AS cus_segmentation
    FROM recently_score r
        JOIN frequency fr ON r.customer_unique_id = fr.customer_unique_id
        JOIN monetary mo ON r.customer_unique_id = mo.customer_unique_id
        JOIN dim_rfm ON CAST(dim_rfm.recency AS INT64) = r.recency 
                    AND CAST(dim_rfm.frequency AS INT64) = fr.frequency
                    AND CAST(dim_rfm.monetary AS INT64) = mo.monetary;
-- Calculate avg_sale_per_customers:
    SELECT
        cus_segmentation,
        ROUND(AVG(total_spent/ total_orders),2) avg_sales_per_customer
    FROM `Ecommerce_Sql_project.customer_segmentation` 
    GROUP BY cus_segmentation;

-- Customer Life Value (CLV) per customer_segmentation:
    WITH customerdatabonus AS(
        SELECT
            c.customer_unique_id,
            CAST(MIN(o.order_purchase_timestamp) AS DATE) first_purchased,
            CAST(MAX(o.order_purchase_timestamp) AS DATE) last_purchased
        FROM 
        `Ecommerce_Sql_project.Customers` c
        JOIN `Ecommerce_Sql_project.orders` o ON o.customer_id= c.customer_id
        GROUP BY c.customer_unique_id
    ),clv AS(
    -- Calculate metric for CLV:
    SELECT
        cdb.customer_unique_id,
        csg.total_orders PF_indexes,
        total_spent / total_orders AS AOV,
        CASE WHEN DATE_DIFF(cdb.last_purchased, cdb.first_purchased, WEEK) <1 THEN 1
        ELSE  DATE_DIFF(cdb.last_purchased, cdb.first_purchased, WEEK)
        END AS ACL_Indexs
    FROM customerdatabonus cdb 
    JOIN `Ecommerce_Sql_project.customer_segmentation` csg
    ON cdb.customer_unique_id =csg.customer_unique_id)
    -- CLV:
    SELECT 
    cus_segmentation,
    ROUND(AVG(clv.PF_indexes * clv.ACL_Indexs * clv.AOV),2) as CLV
    FROM clv JOIN
    `Ecommerce_Sql_project.customer_segmentation` csg 
    ON clv.customer_unique_id= csg.customer_unique_id 
    GROUP BY cus_segmentation;

-- CLV per geolocation:
    WITH customerdatabonus_geo AS (
        SELECT
            c.customer_unique_id,
            c.customer_zip_code_prefix AS zip_code_prefix,
            COUNT(DISTINCT o.order_id) AS order_count,
            SUM(op.payment_value) AS total_payment,
            DATE(MIN(o.order_purchase_timestamp)) AS first_order_day,
            DATE(MAX(o.order_purchase_timestamp)) AS last_order_day
        FROM 
            `Ecommerce_Sql_project.Customers` c
        JOIN 
            `Ecommerce_Sql_project.orders` o ON o.customer_id = c.customer_id
        JOIN 
            `Ecommerce_Sql_project.order_payments` op ON op.order_id = o.order_id
        GROUP BY 
            c.customer_unique_id,c.customer_zip_code_prefix
    ), clv_geo AS (
        SELECT
            customer_unique_id,
            zip_code_prefix,
            order_count AS PF,
            total_payment / order_count AS AOV,
            CASE
                WHEN DATE_DIFF(last_order_day, first_order_day, WEEK) < 1 THEN
                    1
                ELSE
                    DATE_DIFF(last_order_day, first_order_day, WEEK)
            END AS ACL
        FROM customerdatabonus_geo)
    SELECT
        zip_code_prefix AS zip_prefix,
        ROUND(AVG(PF * AOV * ACL), 2) AS avg_CLV,
        COUNT(customer_unique_id) AS customer_count,
        g.geolocation_lat AS latitude,
        g.geolocation_lng AS longitude
    FROM clv_geo cg
    JOIN `Ecommerce_Sql_project.Geolocation` g ON cg.zip_code_prefix = g.geolocation_zip_code_prefix
    GROUP BY 
        zip_code_prefix, g.geolocation_lat, g.geolocation_lng;


