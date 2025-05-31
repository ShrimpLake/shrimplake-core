-- 목적: 보호장구 종류 및 착용여부에 따른 사상자 수 비교 (착용 효과 분석 기초).
SELECT
    searchyear,
    gugun_nm,
    gear_type,
    wearing_status,
    "stat_type",
    SUM("data") AS total_data
FROM
    tra.protect_gear_acid_stats -- 스키마를 tra로 가정
WHERE
    wearing_status IN ('착용', '미착용')
    AND rate_type != '착용률 (%)' -- 실제 사상자 수 데이터만 필터링
GROUP BY
    searchyear,
    gugun_nm,
    gear_type,
    wearing_status,
    "stat_type"
ORDER BY
    searchyear DESC,
    gugun_nm,
    gear_type,
    "stat_type",
    wearing_status; 