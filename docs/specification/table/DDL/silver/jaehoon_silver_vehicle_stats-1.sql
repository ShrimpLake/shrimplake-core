-- 목적: 특정 차량 소분류의 통계 유형별 사고 데이터 집계 및 연도/구군별 경향 파악.
SELECT
    searchyear,
    gugun_nm,
    vehicle_sub_category,
    "stat_type",
    SUM("data") AS total_data
FROM
    tra.traffic_acid_stats_by_vehicle 
WHERE
    vehicle_use_type = '이륜차' -- 분석할 특정 차량 소분류
GROUP BY
    searchyear,
    gugun_nm,
    vehicle_sub_category,
    "stat_type"
ORDER BY
    searchyear DESC,
    gugun_nm,
    total_data DESC; 