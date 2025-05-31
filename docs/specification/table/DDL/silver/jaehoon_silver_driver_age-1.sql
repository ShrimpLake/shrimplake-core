-- 목적: 특정 연령대 및 통계 유형별 사고 데이터 집계 및 연도/구군별 경향 파악.
SELECT
    searchyear,
    gugun_nm,
    "stat_type",
    age_group,
    SUM("data") AS total_data
FROM
    tra.driver_age_accident_stats -- 스키마를 tra로 가정
WHERE
    age_group = '20세이하' -- 분석할 특정 연령대
GROUP BY
    searchyear,
    gugun_nm,
    "stat_type",
    age_group
ORDER BY
    searchyear DESC,
    gugun_nm,
    total_data DESC; 