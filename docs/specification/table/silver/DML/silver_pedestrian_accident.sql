-- 목적: 보행 상태별 사고 데이터 통합을 통한 보행자 안전도 예측 기반 구축
-- 머신러닝 적용: 보행 상태별 사고 위험도 예측, 지역별 보행자 안전도 평가
-- 예측 목표: 보행 환경별 사고 발생 확률, 고위험 보행 구간 식별

CREATE TABLE silver.silver_ped_acid_stats AS
WITH
    -- 원본 데이터 ('전체' 보행상태 제외)
    RawData AS (
        SELECT
            searchyear,
            gugun_nm,
            ped_stat,
            stat_type,
            data AS stat_data
        FROM
            tra.ped_acid_stats
        WHERE
            ped_stat != '전체'  -- '전체' 보행상태 데이터 제외
    ),
    
    -- 보행 상태별 집계
    PedStatMetrics AS (
        SELECT
            searchyear,
            gugun_nm,
            ped_stat,
            SUM(CASE WHEN stat_type = '발생건수' THEN stat_data ELSE 0 END) AS occrrnc_cnt,
            SUM(CASE WHEN stat_type = '사망자수' THEN stat_data ELSE 0 END) AS dth_cnt,
            SUM(CASE WHEN stat_type = '부상자수' THEN stat_data ELSE 0 END) AS injpsn_cnt,
            -- 사망률: (사망자수 ÷ 발생건수) × 100
            CASE
                WHEN SUM(CASE WHEN stat_type = '발생건수' THEN stat_data ELSE 0 END) > 0
                THEN ROUND(SUM(CASE WHEN stat_type = '사망자수' THEN stat_data ELSE 0 END) * 100.0 / 
                          SUM(CASE WHEN stat_type = '발생건수' THEN stat_data ELSE 0 END), 2)
                ELSE 0
            END AS dth_rate,
            -- 부상률: (부상자수 ÷ 발생건수) × 100
            CASE
                WHEN SUM(CASE WHEN stat_type = '발생건수' THEN stat_data ELSE 0 END) > 0
                THEN ROUND(SUM(CASE WHEN stat_type = '부상자수' THEN stat_data ELSE 0 END) * 100.0 / 
                          SUM(CASE WHEN stat_type = '발생건수' THEN stat_data ELSE 0 END), 2)
                ELSE 0
            END AS injpsn_rate
        FROM
            RawData
        GROUP BY
            searchyear,
            gugun_nm,
            ped_stat
    ),
    
    -- 전년 대비 증감
    PedStatYoY AS (
        SELECT
            searchyear,
            gugun_nm,
            ped_stat,
            occrrnc_cnt,
            -- 전년도 값 조회
            LAG(occrrnc_cnt, 1) OVER (PARTITION BY gugun_nm, ped_stat ORDER BY searchyear) AS prev_year_occrrnc_cnt,
            -- 증감률 계산: ((올해-작년) ÷ 작년) × 100
            CASE
                WHEN LAG(occrrnc_cnt, 1) OVER (PARTITION BY gugun_nm, ped_stat ORDER BY searchyear) > 0
                THEN ROUND((occrrnc_cnt - LAG(occrrnc_cnt, 1) OVER (PARTITION BY gugun_nm, ped_stat ORDER BY searchyear)) * 100.0 / 
                          LAG(occrrnc_cnt, 1) OVER (PARTITION BY gugun_nm, ped_stat ORDER BY searchyear), 2)
                ELSE NULL
            END AS occrrnc_cnt_change_rate
        FROM
            PedStatMetrics
    ),
    
    -- 전체 보행자 사고 대비 비율 (발생률)
    PedStatRatio AS (
        SELECT
            searchyear,
            gugun_nm,
            ped_stat,
            -- 발생률: (해당 보행상태 발생건수 ÷ 구군 전체 발생건수) × 100
            CASE
                WHEN SUM(SUM(CASE WHEN stat_type = '발생건수' THEN stat_data ELSE 0 END)) OVER (PARTITION BY searchyear, gugun_nm) > 0
                THEN ROUND(SUM(CASE WHEN stat_type = '발생건수' THEN stat_data ELSE 0 END) * 100.0 /
                      SUM(SUM(CASE WHEN stat_type = '발생건수' THEN stat_data ELSE 0 END)) OVER (PARTITION BY searchyear, gugun_nm), 2)
                ELSE 0
            END AS occrrnc_rate
        FROM
            RawData
        GROUP BY
            searchyear,
            gugun_nm,
            ped_stat
    ),
    
    -- 위험도 가중치 계산
    RiskScore AS (
        SELECT
            searchyear,
            gugun_nm,
            ped_stat,
            -- 위험도 점수: 사망×5 + 부상×2 + 발생×1
            (dth_cnt * 5 + injpsn_cnt * 2 + occrrnc_cnt * 1) AS risk_score
        FROM
            PedStatMetrics
    )

-- 최종 통합
SELECT
    rd.searchyear,                          -- 연도
    rd.gugun_nm,                            -- 구군명
    rd.ped_stat,                            -- 보행 상태
    rd.stat_type,                           -- 통계 유형
    rd.stat_data,                           -- 원본 데이터
    
    -- PedStatMetrics에서
    COALESCE(psm.occrrnc_cnt, 0) AS occrrnc_cnt,                        -- 보행상태별 발생건수
    COALESCE(psm.dth_cnt, 0) AS dth_cnt,                                -- 보행상태별 사망자수
    COALESCE(psm.injpsn_cnt, 0) AS injpsn_cnt,                          -- 보행상태별 부상자수
    COALESCE(psm.dth_rate, 0) AS dth_rate,                              -- 보행상태별 사망률(%)
    COALESCE(psm.injpsn_rate, 0) AS injpsn_rate,                        -- 보행상태별 부상률(%)
    
    -- PedStatYoY에서
    COALESCE(psy.prev_year_occrrnc_cnt, 0) AS prev_year_occrrnc_cnt,    -- 전년도 발생건수
    COALESCE(psy.occrrnc_cnt_change_rate, 0) AS occrrnc_cnt_change_rate, -- 발생건수 전년 대비 증감률(%)
    
    -- PedStatRatio에서
    COALESCE(psr.occrrnc_rate, 0) AS occrrnc_rate,                      -- 보행상태별 발생률(%)
    
    -- RiskScore에서
    COALESCE(rs.risk_score, 0) AS risk_score,                           -- 위험도 점수
    
    -- 보행 환경 분류
    CASE 
        WHEN rd.ped_stat = '횡단중' THEN '도로횡단'
        WHEN rd.ped_stat IN ('차도 통행중', '길가장자리구역통행중') THEN '차도보행'
        WHEN rd.ped_stat = '보도통행중' THEN '보도보행'
        WHEN rd.ped_stat = '기타' THEN '기타보행'
        ELSE '전체'
    END AS ped_environment                  -- 보행 환경 분류

FROM
    RawData rd
LEFT JOIN
    PedStatMetrics psm ON rd.searchyear = psm.searchyear AND rd.gugun_nm = psm.gugun_nm AND rd.ped_stat = psm.ped_stat
LEFT JOIN
    PedStatYoY psy ON rd.searchyear = psy.searchyear AND rd.gugun_nm = psy.gugun_nm AND rd.ped_stat = psy.ped_stat
LEFT JOIN
    PedStatRatio psr ON rd.searchyear = psr.searchyear AND rd.gugun_nm = psr.gugun_nm AND rd.ped_stat = psr.ped_stat
LEFT JOIN
    RiskScore rs ON rd.searchyear = rs.searchyear AND rd.gugun_nm = rs.gugun_nm AND rd.ped_stat = rs.ped_stat
ORDER BY
    rd.searchyear DESC,
    rd.gugun_nm,
    rd.ped_stat,
    rd.stat_type;

-- 테이블 및 컬럼 주석 (규칙에 맞게 수정)
COMMENT ON TABLE silver.silver_ped_acid_stats IS '보행 상태별 사고 통계 및 위험도 지표 통합 테이블';

COMMENT ON COLUMN silver.silver_ped_acid_stats.searchyear IS '통계 연도';
COMMENT ON COLUMN silver.silver_ped_acid_stats.gugun_nm IS '자치구명';
COMMENT ON COLUMN silver.silver_ped_acid_stats.ped_stat IS '보행자 상태';
COMMENT ON COLUMN silver.silver_ped_acid_stats.stat_type IS '통계 유형';
COMMENT ON COLUMN silver.silver_ped_acid_stats.stat_data IS '원본 통계값';

COMMENT ON COLUMN silver.silver_ped_acid_stats.occrrnc_cnt IS '보행상태별 발생건수';
COMMENT ON COLUMN silver.silver_ped_acid_stats.dth_cnt IS '보행상태별 사망자수';
COMMENT ON COLUMN silver.silver_ped_acid_stats.injpsn_cnt IS '보행상태별 부상자수';
COMMENT ON COLUMN silver.silver_ped_acid_stats.dth_rate IS '보행상태별 사망률(%)';
COMMENT ON COLUMN silver.silver_ped_acid_stats.injpsn_rate IS '보행상태별 부상률(%)';
COMMENT ON COLUMN silver.silver_ped_acid_stats.prev_year_occrrnc_cnt IS '전년도 발생건수';
COMMENT ON COLUMN silver.silver_ped_acid_stats.occrrnc_cnt_change_rate IS '발생건수 전년 대비 증감률(%)';
COMMENT ON COLUMN silver.silver_ped_acid_stats.occrrnc_rate IS '보행상태별 발생률(%)';
COMMENT ON COLUMN silver.silver_ped_acid_stats.risk_score IS '위험도 점수';
COMMENT ON COLUMN silver.silver_ped_acid_stats.ped_environment IS '보행 환경 분류'; 