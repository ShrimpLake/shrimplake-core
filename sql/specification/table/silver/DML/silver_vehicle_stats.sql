-- 목적: 차종별 사고 데이터 통합 및 심층 분석 지표 결합을 통한 머신러닝 분석 기반 제공
-- 머신러닝 적용: 특정 차종의 사고 위험도 및 기여도 분석, 사고 발생 예측, 안전 개선 추세 예측
-- 예측 목표: 주요 차종의 사고 발생 및 심각도 예측, 위험 기여도가 높은 차종 식별, 안전 정책 효과 분석

CREATE TABLE silver.silver_vehicle_stats AS
WITH
    -- 1. 원본 데이터 집계 (연도, 구군, 차종별 발생/사망/부상 건수)
    RawPivotedCounts AS (
        SELECT
            searchyear,
            gugun_nm,
            vehicle_use_type,
            SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS occrrnc_cnt,
            SUM(CASE WHEN stat_type = '사망자수 (명)' THEN data ELSE 0 END) AS dth_cnt,
            SUM(CASE WHEN stat_type = '부상자수 (명)' THEN data ELSE 0 END) AS injpsn_cnt
        FROM
            tra.traffic_acid_stats_by_vehicle
        WHERE 
            vehicle_use_type IS NOT NULL AND vehicle_use_type NOT IN ('미분류', '기타불명', '전체')
            AND stat_type IN ('발생건수 (건)', '사망자수 (명)', '부상자수 (명)')
        GROUP BY
            searchyear,
            gugun_nm,
            vehicle_use_type
    ),

    -- 2. 차종별 기본 지표 계산 (사망률, 부상률)
    VehicleTypeMetrics AS (
        SELECT
            searchyear,
            gugun_nm,
            vehicle_use_type,
            occrrnc_cnt,
            dth_cnt,
            injpsn_cnt,
            -- 사망률: (사망자수 / 발생건수) * 100
            CASE
                WHEN occrrnc_cnt > 0 THEN ROUND(dth_cnt * 100.0 / occrrnc_cnt, 2)
                ELSE 0
            END AS dth_rate,
            -- 부상률: (부상자수 / 발생건수) * 100
            CASE
                WHEN occrrnc_cnt > 0 THEN ROUND(injpsn_cnt * 100.0 / occrrnc_cnt, 2)
                ELSE 0
            END AS injpsn_rate,
            -- 가중 사상자 수 (사망x5, 부상x2, 발생x1) - 위험 기여도 계산용
            (dth_cnt * 5 + injpsn_cnt * 2 + occrrnc_cnt * 1) AS weighted_casualties_vehicle
        FROM
            RawPivotedCounts
    ),

    -- 3. 구군별 전체 차종 대상 지표 계산 (위험 기여도 및 상대적 위험도 계산용)
    GugunTotalMetrics AS (
        SELECT
            searchyear,
            gugun_nm,
            SUM(occrrnc_cnt) AS gugun_total_occrrnc_cnt,
            SUM(dth_cnt) AS gugun_total_dth_cnt,
            SUM(weighted_casualties_vehicle) AS gugun_total_weighted_casualties_all_vehicles, -- 구군별 전체 가중 사상자 수
            -- 구군별 전체 차종 평균 사망률
            CASE
                WHEN SUM(occrrnc_cnt) > 0 THEN ROUND(SUM(dth_cnt) * 100.0 / SUM(occrrnc_cnt), 2)
                ELSE 0
            END AS gugun_avg_dth_rate_all_vehicles
        FROM
            VehicleTypeMetrics
        GROUP BY
            searchyear,
            gugun_nm
    ),

    -- 4. 차종별 시계열 지표 계산 (전년 대비 변화, 안전 개선 추세)
    VehicleTypeYoY AS (
        SELECT
            searchyear,
            gugun_nm,
            vehicle_use_type,
            occrrnc_cnt,
            dth_rate,
            -- 전년도 발생건수
            LAG(occrrnc_cnt, 1) OVER (PARTITION BY gugun_nm, vehicle_use_type ORDER BY searchyear) AS prev_year_occrrnc_cnt,
            -- 발생건수 증감률
            CASE
                WHEN LAG(occrrnc_cnt, 1) OVER (PARTITION BY gugun_nm, vehicle_use_type ORDER BY searchyear) > 0
                THEN ROUND((occrrnc_cnt - LAG(occrrnc_cnt, 1) OVER (PARTITION BY gugun_nm, vehicle_use_type ORDER BY searchyear)) * 100.0 /
                           LAG(occrrnc_cnt, 1) OVER (PARTITION BY gugun_nm, vehicle_use_type ORDER BY searchyear), 2)
                ELSE NULL
            END AS occrrnc_cnt_change_pct,
            -- 전년도 사망률
            LAG(dth_rate, 1) OVER (PARTITION BY gugun_nm, vehicle_use_type ORDER BY searchyear) AS prev_year_dth_rate,
            -- 2년 전 사망률 (안전 개선 추세 계산용)
            LAG(dth_rate, 2) OVER (PARTITION BY gugun_nm, vehicle_use_type ORDER BY searchyear) AS prev_2year_dth_rate
        FROM
            VehicleTypeMetrics
    )

-- 최종 통합 테이블
SELECT
    vtm.searchyear,
    vtm.gugun_nm,
    vtm.vehicle_use_type,
    
    vtm.occrrnc_cnt,
    vtm.dth_cnt,
    vtm.injpsn_cnt,
    vtm.dth_rate,
    vtm.injpsn_rate,
    
    vtyoy.prev_year_occrrnc_cnt,
    vtyoy.occrrnc_cnt_change_pct,
    vtyoy.prev_year_dth_rate,
    (vtm.dth_rate - vtyoy.prev_year_dth_rate) AS dth_rate_yoy_change, -- 사망률 전년 대비 절대 변화량

    -- 위험 기여도 (%)
    CASE
        WHEN gtm.gugun_total_weighted_casualties_all_vehicles > 0
        THEN ROUND(vtm.weighted_casualties_vehicle * 100.0 / gtm.gugun_total_weighted_casualties_all_vehicles, 2)
        ELSE 0
    END AS risk_contribution_pct,

    -- 상대적 사망률 (vs. 구군 전체 평균)
    CASE
        WHEN gtm.gugun_avg_dth_rate_all_vehicles > 0
        THEN ROUND(vtm.dth_rate / gtm.gugun_avg_dth_rate_all_vehicles, 2)
        ELSE NULL -- 평균 사망률이 0이면 비교 불가
    END AS relative_dth_rate,

    -- 안전 개선 추세 (단순화: 2년 연속 사망률 감소 시 +1, 1년 감소 0, 증가 -1)
    CASE
        WHEN vtm.dth_rate IS NOT NULL AND vtyoy.prev_year_dth_rate IS NOT NULL AND vtyoy.prev_2year_dth_rate IS NOT NULL THEN
            CASE
                WHEN vtm.dth_rate < vtyoy.prev_year_dth_rate AND vtyoy.prev_year_dth_rate < vtyoy.prev_2year_dth_rate THEN 2 -- 2년 연속 감소
                WHEN vtm.dth_rate < vtyoy.prev_year_dth_rate THEN 1 -- 1년 감소
                WHEN vtm.dth_rate > vtyoy.prev_year_dth_rate THEN -1 -- 1년 증가
                ELSE 0 -- 변화 없거나, 패턴 불분명
            END
        ELSE NULL -- 충분한 과거 데이터 없는 경우
    END AS safety_improvement_trend,

    -- 발생률(구군 내 해당 차종의 사고 점유율, %)
    CASE 
        WHEN gtm.gugun_total_occrrnc_cnt > 0
        THEN ROUND(vtm.occrrnc_cnt * 100.0 / gtm.gugun_total_occrrnc_cnt, 2)
        ELSE 0
    END AS occrrnc_rate

FROM
    VehicleTypeMetrics vtm
LEFT JOIN
    GugunTotalMetrics gtm ON vtm.searchyear = gtm.searchyear AND vtm.gugun_nm = gtm.gugun_nm
LEFT JOIN
    VehicleTypeYoY vtyoy ON vtm.searchyear = vtyoy.searchyear 
                        AND vtm.gugun_nm = vtyoy.gugun_nm 
                        AND vtm.vehicle_use_type = vtyoy.vehicle_use_type
ORDER BY
    vtm.searchyear DESC,
    vtm.gugun_nm,
    vtm.vehicle_use_type;

-- 테이블 및 컬럼 주석 (규칙에 맞게 수정)
COMMENT ON TABLE silver.silver_vehicle_stats IS '차종별 사고 통계, 위험도 및 안전 개선 추세 분석 테이블';

COMMENT ON COLUMN silver.silver_vehicle_stats.searchyear IS '통계 연도';
COMMENT ON COLUMN silver.silver_vehicle_stats.gugun_nm IS '자치구명';
COMMENT ON COLUMN silver.silver_vehicle_stats.vehicle_use_type IS '차종 대분류';
COMMENT ON COLUMN silver.silver_vehicle_stats.occrrnc_cnt IS '차종별 발생건수';
COMMENT ON COLUMN silver.silver_vehicle_stats.dth_cnt IS '차종별 사망자수';
COMMENT ON COLUMN silver.silver_vehicle_stats.injpsn_cnt IS '차종별 부상자수';
COMMENT ON COLUMN silver.silver_vehicle_stats.dth_rate IS '차종별 사망률(%)';
COMMENT ON COLUMN silver.silver_vehicle_stats.injpsn_rate IS '차종별 부상률(%)';
COMMENT ON COLUMN silver.silver_vehicle_stats.prev_year_occrrnc_cnt IS '전년도 차종별 발생건수';
COMMENT ON COLUMN silver.silver_vehicle_stats.occrrnc_cnt_change_pct IS '차종별 발생건수 전년 대비 증감률(%)';
COMMENT ON COLUMN silver.silver_vehicle_stats.prev_year_dth_rate IS '전년도 차종별 사망률(%)';
COMMENT ON COLUMN silver.silver_vehicle_stats.dth_rate_yoy_change IS '차종별 사망률 전년 대비 증감(절대값)';
COMMENT ON COLUMN silver.silver_vehicle_stats.risk_contribution_pct IS '구군 내 차종별 위험 기여도(가중 사상자 기준, %)';
COMMENT ON COLUMN silver.silver_vehicle_stats.relative_dth_rate IS '구군 전체 평균 대비 차종별 상대적 사망률 (1 초과시 평균보다 높음)';
COMMENT ON COLUMN silver.silver_vehicle_stats.safety_improvement_trend IS '차종별 안전 개선 추세 점수 (사망률 기준, 높을수록 개선)';
COMMENT ON COLUMN silver.silver_vehicle_stats.occrrnc_rate IS '구군 내 해당 차종의 사고 점유율(%)'; 