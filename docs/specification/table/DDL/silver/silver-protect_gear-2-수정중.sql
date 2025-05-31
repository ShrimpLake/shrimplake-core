-- 목적: 특정 보호장구 착용률 낮은 구군 식별 및 해당 지역 미착용 시 사상자 수 분석.

-- 1단계: 특정 보호장구(예: 안전모)의 착용률 및 낮은 순위 식별
WITH LowWearingRateGuguns AS (
    SELECT
        searchyear,
        gugun_nm,
        gear_type,          -- 이 CTE에서는 '안전모(헬멧)'만 해당됨
        "data" AS wearing_rate, -- rate_type='착용률(%)'이므로 "data"는 실제 착용률
        ROW_NUMBER() OVER (PARTITION BY searchyear, gear_type ORDER BY "data" ASC) as rn_asc
    FROM
        tra.protect_gear_acid_stats -- 스키마를 tra로 가정
    WHERE
        rate_type = '착용률(%)'
        AND gear_type = '안전모(헬멧)' -- 분석할 특정 보호장구
),
-- 2단계: 특정 보호장구(예: 안전모) 미착용 시 사상자 데이터 준비
UnwornCasualtyStats AS (
    SELECT
        searchyear,
        gugun_nm,
        gear_type,          -- 이 CTE에서는 '안전모(헬멧)' 데이터만 고려됨
        "stat_type",        -- 사망자수, 부상자수
        "data"              -- rate_type!='착용률(%)'이므로 "data"는 실제 사상자 수
    FROM
        tra.protect_gear_acid_stats -- 스키마를 tra로 가정
    WHERE
        wearing_status = '미착용'
        AND rate_type != '착용률(%)' -- 실제 사상자 수 데이터만 필터링 (즉, rate_type = '전체')
        AND gear_type = '안전모(헬멧)' -- 분석할 특정 보호장구 (LowWearingRateGuguns와 일치시키기 위함)
)
-- 3단계: 착용률 낮은 구군의 미착용 사상자 수 집계
SELECT
    ucs.searchyear,
    ucs.gugun_nm,
    ucs.gear_type,          -- '안전모(헬멧)'
    lwr.wearing_rate,       -- 해당 구군의 '안전모(헬멧)' 착용률
    ucs."stat_type",        -- 사망자수 또는 부상자수
    SUM(ucs."data") AS total_data_unworn -- 미착용 시 총 사상자 수
FROM
    UnwornCasualtyStats ucs
JOIN
    LowWearingRateGuguns lwr
    ON ucs.searchyear = lwr.searchyear
    AND ucs.gugun_nm = lwr.gugun_nm
    AND ucs.gear_type = lwr.gear_type -- 여기서는 항상 '안전모(헬멧)'로 조인됨
WHERE
    lwr.rn_asc <= 5 -- 착용률 하위 5개 구군 (필요시 조정)
GROUP BY
    ucs.searchyear,
    ucs.gugun_nm,
    ucs.gear_type,
    lwr.wearing_rate,
    ucs."stat_type"
ORDER BY
    ucs.searchyear DESC,
    lwr.wearing_rate ASC, -- 착용률 낮은 순으로 정렬
    ucs.gugun_nm,
    ucs.gear_type;

    --얘도 값이 안나옴. 모든 컬럼럼