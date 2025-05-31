-- 목적: 보호장구 미착용 시 '사망자수' 상위 구군 식별 및 해당 지역 착용률 비교.
-- 1단계: 보호장구 미착용 사망자수 기준 상위 구군 식별
WITH UnwornDeaths AS (
    SELECT
        searchyear,
        gugun_nm,
        gear_type,
        SUM("data") AS total_deaths_unworn,
        ROW_NUMBER() OVER (PARTITION BY searchyear, gear_type ORDER BY SUM("data") DESC) as rn
    FROM
        tra.protect_gear_acid_stats -- 스키마를 tra로 가정
    WHERE
        wearing_status = '미착용'
        AND "stat_type" = '사망자수'
        AND rate_type != '착용률(%)' -- 실제 사상자 수 데이터만 필터링
    GROUP BY
        searchyear,
        gugun_nm,
        gear_type
),
-- 2단계: 상위 구군의 착용률 데이터 조회
TopGugunsUnwornDeaths AS (
    SELECT searchyear, gugun_nm, gear_type, total_deaths_unworn
    FROM UnwornDeaths
    WHERE rn <= 3 -- 상위 3개 구군 (필요시 조정)
)
SELECT
    t.searchyear,
    t.gugun_nm,
    t.gear_type,
    t.total_deaths_unworn,
    pr."data" AS wearing_rate_percentage -- DDL상 data 컬럼이 착용률을 포함
FROM
    TopGugunsUnwornDeaths t
LEFT JOIN
    tra.protect_gear_acid_stats pr
    ON t.searchyear = pr.searchyear
    AND t.gugun_nm = pr.gugun_nm
    AND t.gear_type = pr.gear_type
    AND pr.rate_type = '착용률(%)'
ORDER BY
    t.searchyear DESC,
    t.gear_type,
    t.total_deaths_unworn DESC; 

    --wearing_rate_percentage 값이 안나옴. 