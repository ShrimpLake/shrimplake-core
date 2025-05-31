-- 목적: '보행자 사고 위험 지수' 산출을 위한 기초 데이터 집계 (지수 계산 로직은 별도).
SELECT
    searchyear,
    gugun_nm,
    ped_stat,
    "stat_type",
    SUM("data") AS total_data
    -- 예시: 사망자수 가중치 부여 (실제 가중치는 분석에 따라 결정)
    -- SUM(CASE "stat_type"
    --     WHEN '사망자수' THEN "data" * 5
    --     WHEN '부상자수' THEN "data" * 2
    --     ELSE "data" * 1
    -- END) AS weighted_data_component
FROM
    tra.ped_acid_stats -- 스키마를 tra로 가정
GROUP BY
    searchyear,
    gugun_nm,
    ped_stat,
    "stat_type"
ORDER BY
    searchyear DESC,
    gugun_nm,
    ped_stat,
    "stat_type"; 