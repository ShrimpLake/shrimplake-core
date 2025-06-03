-- 목적: 연도별 뺑소니 '발생건수' 상위/하위 3개 구군 비교.
-- 1단계: 구군별 연간 뺑소니 발생건수 집계
WITH GugunYearlyOccurrences AS (
    SELECT
        searchYear,
        gugun_nm,
        SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS total_occurrences
    FROM
        tra.hit_and_run_acid 
    GROUP BY
        searchYear,
        gugun_nm
),
-- 2단계: 발생건수 기준 상위/하위 순위 부여
RankedGuguns AS (
    SELECT
        searchYear,
        gugun_nm,
        total_occurrences,
        ROW_NUMBER() OVER (PARTITION BY searchYear ORDER BY total_occurrences DESC) as rn_desc,
        ROW_NUMBER() OVER (PARTITION BY searchYear ORDER BY total_occurrences ASC) as rn_asc
    FROM GugunYearlyOccurrences
)
-- 3단계: 상위 3개 및 하위 3개 구군 데이터 조회
SELECT
    searchYear,
    gugun_nm,
    total_occurrences,
    CASE
        WHEN rn_desc <= 3 THEN 'Top 3'
        WHEN rn_asc <= 3 THEN 'Bottom 3'
    END AS rank_group
FROM RankedGuguns
WHERE rn_desc <= 3 OR rn_asc <= 3
ORDER BY
    searchYear DESC,
    rank_group,
    CASE WHEN rn_desc <=3 THEN total_occurrences ELSE NULL END DESC, -- Top 3는 내림차순
    CASE WHEN rn_asc <=3 THEN total_occurrences ELSE NULL END ASC;  -- Bottom 3는 오름차순 