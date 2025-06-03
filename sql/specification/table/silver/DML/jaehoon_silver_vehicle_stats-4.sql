-- 목적: 특정 차량 소분류의 통계 유형별 데이터 및 연도별 사고율 변화 분석.
WITH VehicleSubCategoryData AS (
    SELECT
        searchyear,
        gugun_nm,
        vehicle_sub_category,
        "stat_type",
        SUM("data") AS total_data,
        LAG(SUM("data"), 1, 0) OVER (PARTITION BY gugun_nm, vehicle_sub_category, "stat_type" ORDER BY searchyear) AS previous_year_data
    FROM
        tra.traffic_acid_stats_by_vehicle 
    WHERE
        vehicle_mid_category = '승용차' 
    GROUP BY
        searchyear,
        gugun_nm,
        vehicle_sub_category,
        "stat_type"
)
SELECT
    searchyear,
    gugun_nm,
    vehicle_sub_category,
    "stat_type",
    total_data,
    CASE
        WHEN previous_year_data > 0
        THEN ROUND((total_data - previous_year_data) * 100.0 / previous_year_data, 2)
        ELSE NULL
    END AS percentage_change -- 사고율 변화로 해석
FROM
    VehicleSubCategoryData
ORDER BY
    searchyear DESC,
    gugun_nm,
    vehicle_sub_category,
    "stat_type",
    total_data DESC; 