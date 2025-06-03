-- 목적: 차량 대분류/중분류별 발생건수 대비 사망자수 비율(치명률) 및 사고 잦은 구군 식별.
SELECT
    searchyear,
    gugun_nm,
    vehicle_use_type,
    vehicle_mid_category, -- 또는 vehicle_sub_category
    SUM(CASE WHEN "stat_type" = '사망자수 (명)' THEN "data" ELSE 0 END) AS total_deaths,
    SUM(CASE WHEN "stat_type" = '발생건수 (건)' THEN "data" ELSE 0 END) AS total_accidents,
    CASE
        WHEN SUM(CASE WHEN "stat_type" = '발생건수 (건)' THEN "data" ELSE 0 END) > 0
        THEN ROUND(SUM(CASE WHEN "stat_type" = '사망자수 (명)' THEN "data" ELSE 0 END) * 100.0 / SUM(CASE WHEN "stat_type" = '발생건수 (건)' THEN "data" ELSE 0 END), 2)
        ELSE 0
    END AS fatality_rate_percentage
FROM
    tra.traffic_acid_stats_by_vehicle 
GROUP BY
    searchyear,
    gugun_nm,
    vehicle_use_type,
    vehicle_mid_category -- 또는 vehicle_sub_category
ORDER BY
    searchyear DESC,
    gugun_nm,
    fatality_rate_percentage DESC; 

