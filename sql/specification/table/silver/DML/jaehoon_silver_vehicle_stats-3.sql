-- 목적: '화물차' 관련 사고 데이터의 통계 유형별/구군별/연도별 집계.
SELECT
    searchyear,
    gugun_nm,
    "stat_type",
    SUM("data") AS total_data_for_trucks
FROM
    tra.traffic_acid_stats_by_vehicle 
WHERE
    vehicle_mid_category = '화물' -- '화물차'의 정확한 명칭 확인 필요
GROUP BY
    searchyear,
    gugun_nm,
    "stat_type"
ORDER BY
    searchyear DESC,
    gugun_nm,
    total_data_for_trucks DESC; 