-- 목적: '차도 통행중' 또는 '길가장자리구역통행중' 보행자 사고 데이터 및 연도별 증감률 분석.
WITH RoadSidePedData AS (
    SELECT
        searchyear,
        gugun_nm,
        ped_stat,
        "stat_type",
        SUM("data") AS total_data,
        LAG(SUM("data"), 1, 0) OVER (PARTITION BY gugun_nm, ped_stat, "stat_type" ORDER BY searchyear) AS previous_year_data
    FROM
        tra.ped_acid_stats -- 스키마를 tra로 가정
    WHERE
        ped_stat IN ('차도 통행중', '길가장자리구역통행중')
    GROUP BY
        searchyear,
        gugun_nm,
        ped_stat,
        "stat_type"
)
SELECT
    searchyear,
    gugun_nm,
    ped_stat,
    "stat_type",
    total_data,
    CASE
        WHEN previous_year_data > 0
        THEN ROUND((total_data - previous_year_data) * 100.0 / previous_year_data, 2)
        ELSE NULL
    END AS percentage_change
FROM
    RoadSidePedData
ORDER BY
    searchyear DESC,
    gugun_nm,
    ped_stat,
    "stat_type"; 

    --percent change가 null인 값들은 무엇을 의미하는지 , 어떻게 처리해야하는지지