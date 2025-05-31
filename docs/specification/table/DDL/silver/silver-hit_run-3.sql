-- 목적: '뺑소니 위험도 등급' 설정을 위한 통계 유형별/구군별 데이터 집계 (등급 로직은 별도).
SELECT
    searchYear, -- DDL에 정의된 컬럼명 사용
    gugun_nm,
    stat_type, -- 컬럼명 수정
    SUM(data) AS total_data
    -- 예시: NTILE로 5등급화 (PARTITION BY searchYear, stat_type ORDER BY SUM(data) DESC)
FROM
    tra.hit_and_run_acid -- 스키마를 tra로 가정
GROUP BY
    searchYear,
    gugun_nm,
    stat_type -- 컬럼명 수정
ORDER BY
    searchYear DESC,
    gugun_nm,
    stat_type; -- 컬럼명 수정 