-- 목적: '착용불명' 데이터 비율 분석 (보호장구 종류, 통계 유형, 구군, 연도별).
-- 1단계: '착용불명' 데이터 집계
WITH UnknownWearingData AS (
    SELECT
        searchyear,
        gugun_nm,
        gear_type,
        "stat_type",
        SUM(CASE WHEN wearing_status = '착용불명' THEN "data" ELSE 0 END) AS unknown_wearing_data_sum
    FROM
        tra.protect_gear_acid_stats 
    WHERE rate_type != '착용률 (%)' -- 실제 사상자 수 데이터만 고려
    GROUP BY
        searchyear,
        gugun_nm,
        gear_type,
        "stat_type"
),
-- 2단계: 전체 관련 데이터 집계
TotalWearingData AS (
    SELECT
        searchyear,
        gugun_nm,
        gear_type,
        "stat_type",
        SUM("data") AS total_wearing_data_sum
    FROM
        tra.protect_gear_acid_stats 
    WHERE rate_type != '착용률 (%)' -- 실제 사상자 수 데이터만 고려
    GROUP BY
        searchyear,
        gugun_nm,
        gear_type,
        "stat_type"
)
-- 3단계: '착용불명' 비율 계산
SELECT
    t.searchyear,
    t.gugun_nm,
    t.gear_type,
    t."stat_type",
    COALESCE(u.unknown_wearing_data_sum, 0) as unknown_wearing_data_sum,
    t.total_wearing_data_sum,
    CASE
        WHEN t.total_wearing_data_sum > 0
        THEN ROUND(COALESCE(u.unknown_wearing_data_sum, 0) * 100.0 / t.total_wearing_data_sum, 2)
        ELSE 0
    END AS unknown_wearing_percentage
FROM
    TotalWearingData t
LEFT JOIN
    UnknownWearingData u ON t.searchyear = u.searchyear AND t.gugun_nm = u.gugun_nm AND t.gear_type = u.gear_type AND t."stat_type" = u."stat_type"
ORDER BY
    unknown_wearing_percentage DESC,
    t.searchyear DESC,
    t.gugun_nm,
    t.gear_type; 