-- 목적: 연도별/구군별 뺑소니 사고 발생건수 대비 사망자수 비율(치명률) 계산.
SELECT
    searchYear, -- DDL에 정의된 컬럼명 사용
    gugun_nm,
    SUM(CASE WHEN stat_type = '사망자수 (명)' THEN data ELSE 0 END) AS total_deaths,
    SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS total_accidents,
    CASE
        WHEN SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) > 0
        THEN ROUND(SUM(CASE WHEN stat_type = '사망자수 (명)' THEN data ELSE 0 END) * 100.0 / SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END), 2)
        ELSE 0
    END AS fatality_rate_percentage
FROM
    tra.hit_and_run_acid 
GROUP BY
    searchYear,
    gugun_nm
ORDER BY
    searchYear DESC,
    gugun_nm,
    fatality_rate_percentage DESC; 