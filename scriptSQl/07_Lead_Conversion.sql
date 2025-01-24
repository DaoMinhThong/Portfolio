SELECT
COUNT(*) cnt,
COUNT(DISTINCT mql_id) cnt2
FROM `Ecommerce_Sql_project.leads_qualified`;

SELECT 
    COALESCE(origin, 'unknown') AS origin,
    COUNT(DISTINCT lq.mql_id) AS qualified_leads,
    COUNT(DISTINCT lc.mql_id) AS closed_leads,
    ROUND(COUNT(DISTINCT lc.mql_id) * 100.0 / COUNT(DISTINCT lq.mql_id),2)
        AS conversion_rate
FROM `Ecommerce_Sql_project.leads_qualified` lq
    LEFT JOIN `Ecommerce_Sql_project.leads_closed` lc USING (mql_id)
GROUP BY COALESCE(origin, 'unknown')
ORDER BY COUNT(lq.mql_id) DESC;