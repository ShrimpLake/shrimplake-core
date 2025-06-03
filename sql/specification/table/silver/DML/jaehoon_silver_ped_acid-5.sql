-- 목적: '기타' 보행 상태 사고 데이터의 전체 보행자 사고 대비 비율 계산.
-- 1단계: '기타' 보행 상태 사고 데이터 집계
WITH OtherPedData AS (
    SELECT
        searchyear,
        gugun_nm,
        "stat_type",
        SUM("data") AS other_ped_data_sum
    FROM
        tra.ped_acid_stats 
    WHERE
        ped_stat = '기타'
    GROUP BY
        searchyear,
        gugun_nm,
        "stat_type"
),
-- 2단계: 전체 보행 상태 사고 데이터 집계
TotalPedData AS (
    SELECT
        searchyear,
        gugun_nm,
        "stat_type",
        SUM("data") AS total_ped_data_sum
    FROM
        tra.ped_acid_stats 
    GROUP BY
        searchyear,
        gugun_nm,
        "stat_type"
)
-- 3단계: '기타' 보행 상태 사고 비율 계산
SELECT
    t.searchyear,
    t.gugun_nm,
    t."stat_type",
    COALESCE(o.other_ped_data_sum, 0) AS other_ped_data_sum,
    t.total_ped_data_sum,
    CASE
        WHEN t.total_ped_data_sum > 0
        THEN ROUND(COALESCE(o.other_ped_data_sum, 0) * 100.0 / t.total_ped_data_sum, 2)
        ELSE 0
    END AS other_ped_percentage
FROM
    TotalPedData t
LEFT JOIN
    OtherPedData o ON t.searchyear = o.searchyear AND t.gugun_nm = o.gugun_nm AND t."stat_type" = o."stat_type"
ORDER BY
    other_ped_percentage DESC,
    t.searchyear DESC,
    t.gugun_nm; 