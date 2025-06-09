-- 테이블 생성 쿼리
CREATE TABLE silver.silver_accident_prediction_by_age_group  AS
SELECT
    searchyear, -- 연도
    gugun_nm, -- 구군 이름
    "stat_type", -- 통계 유형
    age_group, -- 연령대
    SUM("data") AS total_data -- 총 데이터
FROM
    tra.driver_age_accident_stats 
WHERE
    age_group = '20세이하' -- 분석할 특정 연령대
GROUP BY
    searchyear,
    gugun_nm,
    "stat_type",
    age_group
ORDER BY
    searchyear DESC,
    gugun_nm,
    total_data DESC;

-- 테이블과 컬럼에 주석 추가
COMMENT ON TABLE silver.accident_prediction_by_age_group IS '특정 연령대 및 통계 유형별 사고 데이터 집계 및 연도/구군별 경향 파악';
COMMENT ON COLUMN silver.accident_prediction_by_age_group.searchyear IS '연도';
COMMENT ON COLUMN silver.accident_prediction_by_age_group.gugun_nm IS '구군 이름';
COMMENT ON COLUMN silver.accident_prediction_by_age_group."stat_type" IS '통계 유형';
COMMENT ON COLUMN silver.accident_prediction_by_age_group.age_group IS '연령대';
COMMENT ON COLUMN silver.accident_prediction_by_age_group.total_data IS '총 데이터';

-- 머신러닝 적용 가능성: 사고 발생 빈도 예측, 특정 연령대의 사고 위험도 분석
-- 예측 목표: 특정 연령대의 사고 발생 빈도, 특정 구군에서의 사고 위험도
-- 라벨 예시: accident_frequency (사고 발생 빈도), risk_level (사고 위험도 수준)