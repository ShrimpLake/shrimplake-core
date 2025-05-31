-- 목적: 연도별 전체 뺑소니 사망자/부상자 수 총합 추이 및 구군별 데이터 조회 (상관관계 분석용).
-- 1단계: 연도별 전체 사망자/부상자 수 합계
SELECT
    searchYear, 
    stat_type, 
    SUM(data) AS total_data_for_year
FROM
    tra.hit_and_run_acid -- 
WHERE
    stat_type IN ('사망자수 (명)', '부상자수 (명)') -- 실제 데이터 값에 맞게 단위 포함하여 수정
GROUP BY
    searchYear,
    stat_type
ORDER BY
    searchYear,
    stat_type;

-- 2단계: (참고용) 구군별 사망자/부상자 데이터 (상관관계 분석 시 활용)
SELECT
    searchYear, 
    gugun_nm,
    stat_type, 
    data
FROM
    tra.hit_and_run_acid -- 
WHERE
    stat_type IN ('사망자수 (명)', '부상자수 (명)') -- 실제 데이터 값에 맞게 단위 포함하여 수정
ORDER BY
    gugun_nm,
    searchYear,
    stat_type; 