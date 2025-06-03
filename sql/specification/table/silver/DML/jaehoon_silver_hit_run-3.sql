-- 목적: '뺑소니 위험도 등급' 설정을 위한 통계 유형별/구군별 데이터 집계 (등급 로직은 별도).
SELECT
    searchYear,
    gugun_nm,
    stat_type,
    SUM(data) AS total_data
FROM
    tra.hit_and_run_acid 
GROUP BY
    searchYear,
    gugun_nm,
    stat_type -- 컬럼명 수정
ORDER BY
    searchYear DESC,
    gugun_nm,
    stat_type; -- 컬럼명 수정 