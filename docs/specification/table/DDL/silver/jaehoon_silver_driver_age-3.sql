-- 목적: '연령불명' 사고 데이터의 전체 사고 대비 비율 계산.
-- 1단계: '연령불명' 사고 데이터 집계
WITH UnknownAgeData AS (
    SELECT
        searchyear,
        gugun_nm,
        "stat_type",
        SUM("data") AS unknown_age_data_sum
    FROM
        tra.driver_age_accident_stats -- 스키마를 tra로 가정
    WHERE
        age_group = '연령불명'
    GROUP BY
        searchyear,
        gugun_nm,
        "stat_type"
),
-- 2단계: 전체 연령 사고 데이터 집계
TotalAgeData AS (
    SELECT
        searchyear,
        gugun_nm,
        "stat_type",
        SUM("data") AS total_age_data_sum
    FROM
        tra.driver_age_accident_stats -- 스키마를 tra로 가정
    GROUP BY
        searchyear,
        gugun_nm,
        "stat_type"
)
-- 3단계: '연령불명' 비율 계산
SELECT
    t.searchyear,
    t.gugun_nm,
    t."stat_type",
    COALESCE(u.unknown_age_data_sum, 0) AS unknown_age_data_sum,
    t.total_age_data_sum,
    CASE
        WHEN t.total_age_data_sum > 0
        THEN ROUND(COALESCE(u.unknown_age_data_sum, 0) * 100.0 / t.total_age_data_sum, 2)
        ELSE 0
    END AS unknown_age_percentage
FROM
    TotalAgeData t
LEFT JOIN
    UnknownAgeData u ON t.searchyear = u.searchyear AND t.gugun_nm = u.gugun_nm AND t."stat_type" = u."stat_type"
ORDER BY
    unknown_age_percentage DESC,
    t.searchyear DESC,
    t.gugun_nm; 