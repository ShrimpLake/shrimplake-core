-- 목적: 연도별 '발생건수' 증감폭이 큰 구군 식별 및 해당 구군의 연령대별 사고 데이터 상세 조회.
-- 1단계: 구군별 연간 발생건수 및 전년 대비 증감 계산
WITH GugunAccidentChange AS (
    SELECT
        searchyear,
        gugun_nm,
        SUM(CASE WHEN "stat_type" = '발생건수' THEN "data" ELSE 0 END) AS total_accidents,
        LAG(SUM(CASE WHEN "stat_type" = '발생건수' THEN "data" ELSE 0 END), 1, 0) OVER (PARTITION BY gugun_nm ORDER BY searchyear) AS prev_year_accidents
    FROM
        tra.driver_age_accident_stats 
    GROUP BY
        searchyear,
        gugun_nm
),
-- 2단계: 발생건수 증감폭 기준 구군 순위 매기기
RankedGugunChange AS (
    SELECT
        searchyear,
        gugun_nm,
        total_accidents,
        (total_accidents - prev_year_accidents) AS accident_change,
        ROW_NUMBER() OVER (PARTITION BY searchyear ORDER BY ABS(total_accidents - prev_year_accidents) DESC) as rn
    FROM GugunAccidentChange
    WHERE searchyear > (SELECT MIN(searchyear) FROM tra.driver_age_accident_stats) -- 첫해는 증감 계산 제외
)
-- 3단계: 증감폭 상위 구군의 연령대별 사고 데이터 조회
SELECT
    d.searchyear,
    d.gugun_nm,
    r.accident_change, -- 증감폭 확인용
    d.age_group,
    d."stat_type",
    d."data"
FROM
    tra.driver_age_accident_stats d
JOIN
    RankedGugunChange r ON d.gugun_nm = r.gugun_nm AND d.searchyear = r.searchyear
WHERE r.rn <= 5 -- 증감폭 상위 5개 구군 (필요시 조정)
ORDER BY
    d.searchyear DESC,
    ABS(r.accident_change) DESC,
    d.gugun_nm,
    d.age_group; 