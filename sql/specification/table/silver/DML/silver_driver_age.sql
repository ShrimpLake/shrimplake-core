-- 목적: 연령대별 사고 데이터 통합 및 주요 지표(발생률, 사망률, 부상률) 산출을 통한 ML 분석 기반 제공
-- 머신러닝 적용: 연령대별 사고 위험도 예측, 특정 조건에서의 사고 심각도(사망/부상률) 예측
-- 예측 목표: 고위험 연령 그룹 식별, 특정 조건에서의 사고 발생 및 사상자 규모 예측

CREATE TABLE silver.silver_driver_age AS
WITH
    -- 1. 원본 데이터 집계 (연도, 구군, 연령대별 발생/사망/부상 건수)
    RawCounts AS (
        SELECT
            searchyear,
            gugun_nm,
            age_group,
            SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS occrrnc_cnt, -- 발생건수
            SUM(CASE WHEN stat_type = '사망자수 (명)' THEN data ELSE 0 END) AS dth_cnt,       -- 사망자수
            SUM(CASE WHEN stat_type = '부상자수 (명)' THEN data ELSE 0 END) AS injpsn_cnt    -- 부상자수
        FROM
            tra.driver_age_accident_stats
        GROUP BY
            searchyear,
            gugun_nm,
            age_group
    ),

    -- 2. 연령대별 주요 비율 지표 계산
    AgeGroupRates AS (
        SELECT
            searchyear,
            gugun_nm,
            age_group,
            occrrnc_cnt,
            dth_cnt,
            injpsn_cnt,
            -- 사망률: (사망자수 / 발생건수) * 100
            CASE
                WHEN occrrnc_cnt > 0 THEN ROUND(dth_cnt * 100.0 / occrrnc_cnt, 2)
                ELSE 0
            END AS dth_rate,
            -- 부상률: (부상자수 / (사망자수 + 부상자수)) * 100 (전체 사상자 중 부상자 비율)
            CASE
                WHEN (dth_cnt + injpsn_cnt) > 0 THEN ROUND(injpsn_cnt * 100.0 / (dth_cnt + injpsn_cnt), 2)
                ELSE 0 -- 사망자도 부상자도 없는 경우
            END AS injpsn_rate
            -- occrrnc_rate (발생률)은 기준이 없어 여기서는 생략, 필요시 골드에서 정의
        FROM
            RawCounts
    ),

    -- 3. '연령불명' 및 '경제활동인구' 관련 통계 (stat_type 기준)
    -- 이 CTE의粒度는 연도, 구군, stat_type 입니다.
    StatTypeSpecificMetrics AS (
        SELECT
            searchyear,
            gugun_nm,
            stat_type,
            SUM(CASE WHEN age_group = '연령불명' THEN data ELSE 0 END) AS unknown_age_cnt, -- 연령불명 건수 (stat_type별)
            SUM(data) AS total_cnt_for_stat_type, -- 전체 연령 건수 (stat_type별)
            CASE
                WHEN SUM(data) > 0 THEN ROUND(SUM(CASE WHEN age_group = '연령불명' THEN data ELSE 0 END) * 100.0 / SUM(data), 2)
                ELSE 0
            END AS unknown_age_pct, -- 연령불명 비율 (stat_type별)
            SUM(CASE WHEN age_group IN ('21~30세', '31~40세', '41~50세', '51~60세') THEN data ELSE 0 END) AS economic_age_group_cnt -- 경제활동인구 건수 (stat_type별)
        FROM
            tra.driver_age_accident_stats
        WHERE stat_type IN ('발생건수 (건)', '사망자수 (명)', '부상자수 (명)') -- occrrnc_cnt, dth_cnt, injpsn_cnt와 일치시키기 위함
        GROUP BY
            searchyear,
            gugun_nm,
            stat_type
    ),

    -- 4. 경제활동인구 통계의 전년 대비 변화 (stat_type 기준)
    EconomicAgeGroupYoY AS (
        SELECT
            searchyear,
            gugun_nm,
            stat_type,
            economic_age_group_cnt,
            LAG(economic_age_group_cnt, 1) OVER (PARTITION BY gugun_nm, stat_type ORDER BY searchyear) AS prev_year_economic_age_group_cnt_raw,
            CASE
                WHEN LAG(economic_age_group_cnt, 1) OVER (PARTITION BY gugun_nm, stat_type ORDER BY searchyear) > 0
                THEN ROUND((economic_age_group_cnt - LAG(economic_age_group_cnt, 1) OVER (PARTITION BY gugun_nm, stat_type ORDER BY searchyear)) * 100.0 /
                           LAG(economic_age_group_cnt, 1) OVER (PARTITION BY gugun_nm, stat_type ORDER BY searchyear), 2)
                ELSE NULL
            END AS economic_age_group_cnt_change_pct
        FROM
            StatTypeSpecificMetrics
    ),
    
    -- 5. 구군별 총 발생건수 및 전년 대비 변화 (연령대 무관)
    GugunTotalOccurrencesYoY AS (
        SELECT
            searchyear,
            gugun_nm,
            SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS gugun_total_occrrnc_cnt,
            LAG(SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END), 1) OVER (PARTITION BY gugun_nm ORDER BY searchyear) AS prev_year_gugun_total_occrrnc_cnt_raw
        FROM
            tra.driver_age_accident_stats
        GROUP BY
            searchyear,
            gugun_nm
    )

-- 최종 통합 테이블 (Grain: 연도, 구군, 연령대)
SELECT
    agr.searchyear,                     -- 연도
    agr.gugun_nm,                       -- 구군명
    agr.age_group,                      -- 연령대
    
    agr.occrrnc_cnt,                    -- 연령대별 발생건수
    agr.dth_cnt,                        -- 연령대별 사망자수
    agr.injpsn_cnt,                     -- 연령대별 부상자수
    agr.dth_rate,                       -- 연령대별 사망률(%)
    agr.injpsn_rate,                    -- 연령대별 부상률(%)
    -- agr.occrrnc_rate,                -- 연령대별 발생률 (%): 기준이 없어 생략, 필요시 골드에서 외부 데이터와 결합 후 생성

    -- 참고용: 해당 연도, 구군의 전체 발생건수 및 전년도 발생건수 (연령대 무관)
    gtoy.gugun_total_occrrnc_cnt,       -- 구군 전체 발생건수
    COALESCE(gtoy.prev_year_gugun_total_occrrnc_cnt_raw, 0) AS prev_year_gugun_total_occrrnc_cnt, -- 구군 전체 전년도 발생건수 (NULL이면 0)
    COALESCE(gtoy.gugun_total_occrrnc_cnt - gtoy.prev_year_gugun_total_occrrnc_cnt_raw, 0) AS gugun_total_occrrnc_cnt_change, -- 구군 전체 발생건수 증감

    
    CASE
        WHEN gtoy.gugun_total_occrrnc_cnt > 0 THEN ROUND(agr.occrrnc_cnt * 100.0 / gtoy.gugun_total_occrrnc_cnt, 2)
        ELSE 0
    END AS occrrnc_rate                 -- 발생률 (구군 전체 발생건수 대비 연령대별 발생건수 비율, %)

FROM
    AgeGroupRates agr
LEFT JOIN 
    GugunTotalOccurrencesYoY gtoy ON agr.searchyear = gtoy.searchyear AND agr.gugun_nm = gtoy.gugun_nm
-- StatTypeSpecificMetrics 및 EconomicAgeGroupYoY는 grain이 달라 직접 조인 시 레코드 수가 늘어날 수 있으므로, 분석 목적에 따라 골드에서 처리
ORDER BY
    agr.searchyear DESC,
    agr.gugun_nm,
    agr.age_group;

-- 테이블 및 컬럼 주석 (규칙에 맞게 수정)
COMMENT ON TABLE silver.silver_driver_age IS '가해 운전자 연령대별 사고 발생 및 사상 통계 (발생건수, 사망자수, 부상자수, 사망률, 부상률)';

COMMENT ON COLUMN silver.silver_driver_age.searchyear IS '통계 연도';
COMMENT ON COLUMN silver.silver_driver_age.gugun_nm IS '자치구명';
COMMENT ON COLUMN silver.silver_driver_age.age_group IS '가해 운전자 연령대';

COMMENT ON COLUMN silver.silver_driver_age.occrrnc_cnt IS '발생건수 (연령대별)';
COMMENT ON COLUMN silver.silver_driver_age.dth_cnt IS '사망자수 (연령대별)';
COMMENT ON COLUMN silver.silver_driver_age.injpsn_cnt IS '부상자수 (연령대별)';
COMMENT ON COLUMN silver.silver_driver_age.dth_rate IS '사망률 (연령대별, %)';
COMMENT ON COLUMN silver.silver_driver_age.injpsn_rate IS '부상률 (연령대별, 전체 사상자 중 부상자 비율, %)';
COMMENT ON COLUMN silver.silver_driver_age.occrrnc_rate IS '발생률 (연령대별, %): 해당 연도, 구군의 전체 발생건수 대비 연령대별 발생건수 비율';

COMMENT ON COLUMN silver.silver_driver_age.gugun_total_occrrnc_cnt IS '구군 전체 발생건수 (해당 연도)';
COMMENT ON COLUMN silver.silver_driver_age.prev_year_gugun_total_occrrnc_cnt IS '구군 전체 전년도 발생건수';
COMMENT ON COLUMN silver.silver_driver_age.gugun_total_occrrnc_cnt_change IS '구군 전체 발생건수 전년 대비 증감';

/*
-- StatTypeSpecificMetrics 및 EconomicAgeGroupYoY 관련 컬럼 주석 (최종 SELECT에서 주석처리 또는 다른 방식으로 통합 예정 시)
COMMENT ON COLUMN silver.silver_driver_age.occrrnc_unknown_age_pct IS '발생건수 중 연령불명 비율(%)';
COMMENT ON COLUMN silver.silver_driver_age.occrrnc_economic_age_group_cnt IS '발생건수 중 경제활동인구 건수';
COMMENT ON COLUMN silver.silver_driver_age.occrrnc_economic_age_group_cnt_change_pct IS '발생건수 중 경제활동인구 건수 전년 대비 증감률(%)';
*/ 