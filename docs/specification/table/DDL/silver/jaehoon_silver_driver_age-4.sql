-- 목적: 주요 경제 활동 연령대의 통계 유형별 사고 데이터 및 연도별 증감 패턴 분석.
WITH EconomicAgeGroupData AS (
    SELECT
        searchyear,
        gugun_nm,
        "stat_type",
        SUM("data") AS total_data,
        LAG(SUM("data"), 1, 0) OVER (PARTITION BY gugun_nm, "stat_type" ORDER BY searchyear) AS previous_year_data
    FROM
        tra.driver_age_accident_stats -- 스키마를 tra로 가정
    WHERE
        age_group IN ('21~30세', '31~40세', '41~50세', '51~60세') -- 주요 경제활동 인구
    GROUP BY
        searchyear,
        gugun_nm,
        "stat_type"
)
SELECT
    searchyear,
    gugun_nm,
    "stat_type",
    total_data,
    (total_data - previous_year_data) AS data_change,
    CASE
        WHEN previous_year_data > 0
        THEN ROUND((total_data - previous_year_data) * 100.0 / previous_year_data, 2)
        ELSE NULL
    END AS percentage_change
FROM
    EconomicAgeGroupData
ORDER BY
    searchyear DESC,
    gugun_nm,
    total_data DESC; 