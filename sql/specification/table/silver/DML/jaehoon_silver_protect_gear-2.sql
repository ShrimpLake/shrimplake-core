-- 목적: 특정 보호장구 착용률 낮은 구군 식별 및 해당 지역 미착용 시 사상자 수 분석.

-- 1단계: 각 구군별 대표 착용률 결정을 위한 준비
-- 동일 (searchyear, gugun_nm, gear_type)에 대해 여러 '착용률 (%)' 데이터가 있을 경우,
-- 0이 아닌 값을 우선하고, 0인 값은 차선으로 선택하도록 preference_order 부여 : 각 구군의 대표 착용률을 선정할 때 0이 아닌 유효한 측정치를 우선적으로 고려
WITH RepresentativeWearingRates_Intermediate AS (
    SELECT
        searchyear,
        gugun_nm,
        gear_type,
        "data",
        -- 선호도: 0이 아닌 데이터는 0, 0인 데이터는 1. 낮은 숫자가 우선.
        CASE WHEN "data" > 0 THEN 0 ELSE 1 END as preference_order,
        -- 각 (searchyear, gugun_nm, gear_type) 내에서 preference_order, 그 다음 "data" 순으로 순위 매김
        ROW_NUMBER() OVER (PARTITION BY searchyear, gugun_nm, gear_type 
                           ORDER BY CASE WHEN "data" > 0 THEN 0 ELSE 1 END ASC, "data" ASC) as rn_gugun_pref
    FROM
        tra.protect_gear_acid_stats
    WHERE
        rate_type = '착용률 (%)'
        AND gear_type = '안전모(헬맷)' -- 분석할 특정 보호장구
        AND gugun_nm <> '전체'       -- '전체' 데이터 제외
),
-- 1단계 최종 CTE: 각 구군별 단일 대표 착용률 선택
TrueWearingRatesPerGugun AS (
    SELECT
        searchyear,
        gugun_nm,
        gear_type,
        "data" AS wearing_rate
    FROM RepresentativeWearingRates_Intermediate
    WHERE rn_gugun_pref = 1 -- 각 구군별 가장 선호되는(rn_gugun_pref=1) 착용률만 선택
),
-- 1단계 (원래 쿼리의 LowWearingRateGuguns 역할): 대표 착용률 기반으로 전체 구군 순위 매김
LowWearingRateGuguns AS (
    SELECT
        searchyear,
        gugun_nm,
        gear_type,
        wearing_rate, -- TrueWearingRatesPerGugun에서 결정된 대표 착용률
        -- 연도별, 보호장구 종류별로 대표 착용률이 낮은 순으로 전체 구군에 순위 부여
        -- 동일 착용률일 경우 구군 이름으로 재정렬하여 일관성 확보
        ROW_NUMBER() OVER (PARTITION BY searchyear, gear_type ORDER BY wearing_rate ASC, gugun_nm ASC) as rn_asc
    FROM
        TrueWearingRatesPerGugun
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
        tra.protect_gear_acid_stats 
    WHERE
        wearing_status = '미착용'
        AND rate_type != '착용률 (%)' -- 실제 사상자 수 데이터만 필터링 (즉, rate_type = '전체')
        AND gear_type = '안전모(헬맷)' -- 분석할 특정 보호장구 (LowWearingRateGuguns와 일치시키기 위함)
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

    