-- 목적: '안전벨트/카시트' 미착용으로 인한 '부상자수'가 높은 구군 및 연도 분석.
SELECT
    searchyear,
    gugun_nm,
    SUM("data") AS total_injuries_unworn_seatbelt_carseat
FROM
    tra.protect_gear_acid_stats 
WHERE
    gear_type = '안전벨트/카시트'
    AND wearing_status = '미착용'
    AND "stat_type" = '부상자수'
    AND rate_type != '착용률 (%)' -- 실제 사상자 수 데이터만 필터링
GROUP BY
    searchyear,
    gugun_nm
ORDER BY
    total_injuries_unworn_seatbelt_carseat DESC,
    searchyear DESC,
    gugun_nm; 