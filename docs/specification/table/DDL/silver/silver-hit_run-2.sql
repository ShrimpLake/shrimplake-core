-- 목적: 구군별 뺑소니 '발생건수'의 연도별 증감 분석.
WITH HitAndRunOccurrences AS (
    SELECT
        searchYear, -- DDL에 정의된 컬럼명 사용
        gugun_nm,
        SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS total_occurrences, -- 사용자 수정 반영: stat_type 및 단위 포함
        LAG(SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END), 1, 0) OVER (PARTITION BY gugun_nm ORDER BY searchYear) AS previous_year_occurrences
    FROM
        tra.hit_and_run_acid -- 스키마를 tra로 가정
    GROUP BY
        searchYear,
        gugun_nm
)
SELECT
    searchYear,
    gugun_nm,
    total_occurrences,
    (total_occurrences - previous_year_occurrences) AS occurrences_change,
    CASE
        WHEN previous_year_occurrences > 0
        THEN ROUND((total_occurrences - previous_year_occurrences) * 100.0 / previous_year_occurrences, 2)
        ELSE NULL
    END AS percentage_change
FROM
    HitAndRunOccurrences
WHERE searchYear > (SELECT MIN(searchYear) FROM tra.hit_and_run_acid) -- 첫해는 증감 계산 제외
ORDER BY
    searchYear DESC,
    gugun_nm,
    ABS(total_occurrences - previous_year_occurrences) DESC; 