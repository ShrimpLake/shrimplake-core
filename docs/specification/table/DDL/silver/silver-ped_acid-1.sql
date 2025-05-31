-- 목적: '횡단중' 보행자 사고의 통계 유형별 데이터 집계 및 연도/구군별 경향 파악.
SELECT
    searchyear,
    gugun_nm,
    "stat_type",
    SUM("data") AS total_data
FROM
    tra.ped_acid_stats -- 스키마를 tra로 가정
WHERE
    ped_stat = '횡단중'
GROUP BY
    searchyear,
    gugun_nm,
    "stat_type"
ORDER BY
    searchyear DESC,
    gugun_nm,
    total_data DESC; 