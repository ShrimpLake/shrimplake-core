-- 목적: 특정 연령대의 구군별 발생건수 대비 사망자수 비율(치명률) 계산.
SELECT
    searchyear,
    gugun_nm,
    age_group,
    SUM(CASE WHEN "stat_type" = '사망자수' THEN "data" ELSE 0 END) AS total_deaths,
    SUM(CASE WHEN "stat_type" = '발생건수' THEN "data" ELSE 0 END) AS total_accidents,
    CASE
        WHEN SUM(CASE WHEN "stat_type" = '발생건수' THEN "data" ELSE 0 END) > 0
        THEN ROUND(SUM(CASE WHEN "stat_type" = '사망자수' THEN "data" ELSE 0 END) * 100.0 / SUM(CASE WHEN "stat_type" = '발생건수' THEN "data" ELSE 0 END), 2)
        ELSE 0
    END AS fatality_rate_percentage
FROM
    tra.driver_age_accident_stats 
WHERE
    age_group = '65세이상' -- 분석할 특정 연령대
GROUP BY
    searchyear,
    gugun_nm,
    age_group
ORDER BY
    searchyear DESC,
    gugun_nm,
    fatality_rate_percentage DESC; 