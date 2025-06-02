-- 목적: 연도별/통계 유형별 상위 3개 차량 소분류 식별 및 해당 차종의 구군별 사고 데이터 분포 조회.
-- 1단계: 연도별/통계 유형별 차량 소분류 사고 데이터 합계 및 순위 계산
-- 2단계: 상위 3개 차량 소분류 필터링
-- 3단계: 상위 차종의 구군별 사고 데이터 조회 (전체 통계 유형에 대해)

WITH VehicleDataAggregated AS (
    SELECT
        searchyear,
        stat_type,
        vehicle_mid_category, -- 차종중분류
        vehicle_sub_category, -- 차종소분류
        SUM(data) AS total_value
    FROM
        tra.traffic_acid_stats_by_vehicle
    -- 참고: 필요시 여기에 초기 필터링 로직 추가 가능 (예: 특정 gugun_nm만 고려 등)
    GROUP BY
        searchyear,
        stat_type,
        vehicle_mid_category,
        vehicle_sub_category
),
VehicleStatsRanked AS (
    SELECT
        searchyear AS search_year,
        stat_type AS statistic_type,
        CASE
            WHEN vehicle_sub_category IS NULL OR vehicle_sub_category = '전체' THEN vehicle_mid_category
            ELSE vehicle_sub_category
        END AS vehicle_class, -- 순위 산정을 위한 대표 차량 분류
        total_value AS total_value_for_ranking,
        ROW_NUMBER() OVER (PARTITION BY searchyear, stat_type ORDER BY total_value DESC) as rnk
    FROM
        VehicleDataAggregated
    WHERE
        -- 순위 대상 차량 분류(vehicle_class)가 '전체'인 경우는 제외 (주로 총계 항목 해당)
        (CASE
            WHEN vehicle_sub_category IS NULL OR vehicle_sub_category = '전체' THEN vehicle_mid_category
            ELSE vehicle_sub_category
        END) <> '전체'
),
-- 2단계 구현: 상위 3개 차량 소분류 필터링
Top3VehicleClasses AS (
    SELECT
        search_year,
        statistic_type, -- 이 statistic_type 기준으로 상위 3위에 든 차량 소분류임
        vehicle_class, -- CASE 표현식으로 정의된 대표 차량 분류
        total_value_for_ranking
    FROM
        VehicleStatsRanked
    WHERE
        rnk <= 3
),
-- 3단계 준비: 어떤 statistic_type에서든 상위 3위 안에 한 번이라도 포함된 (search_year, vehicle_class) 조합을 식별
DistinctTopClasses AS (
    SELECT DISTINCT
        search_year,
        vehicle_class
    FROM
        Top3VehicleClasses
)
-- 3단계 구현: 식별된 상위 차종에 대해, 각 구군별 모든 통계 유형의 데이터 조회
SELECT
    orig_data.searchyear AS search_year,        -- 연도
    orig_data.gugun_nm AS gugun_name,           -- 자치구명
    CASE
        WHEN orig_data.vehicle_sub_category IS NULL OR orig_data.vehicle_sub_category = '전체' THEN orig_data.vehicle_mid_category
        ELSE orig_data.vehicle_sub_category
    END AS vehicle_class, -- 화면에 표시될 대표 차량 분류
    orig_data.stat_type AS statistic_type,      -- 분류컬럼 (상위 차종에 대한 모든 통계 유형을 조회)
    orig_data.data AS value_data                -- 데이터
FROM
    tra.traffic_acid_stats_by_vehicle orig_data
INNER JOIN
    DistinctTopClasses dtc
    ON orig_data.searchyear = dtc.search_year 
    AND (CASE
            WHEN orig_data.vehicle_sub_category IS NULL OR orig_data.vehicle_sub_category = '전체' THEN orig_data.vehicle_mid_category
            ELSE orig_data.vehicle_sub_category
        END) = dtc.vehicle_class -- 조인 조건도 대표 차량 분류 기준
WHERE
    orig_data.gugun_nm <> '전체' -- 구군별 상세 데이터를 조회하므로, '전체' 구군 레코드는 일반적으로 제외합니다. (필요에 따라 조정)
ORDER BY
    search_year DESC,
    vehicle_class,
    gugun_name,
    statistic_type;
