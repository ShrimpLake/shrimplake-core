-- 목적: 뺑소니 사고 데이터 통합 및 주요 분석 지표 결합을 통한 머신러닝 분석 기반 제공
-- 머신러닝 적용: 뺑소니 사고 발생 예측, 지역별 위험도 평가, 치명률 예측, 증감 패턴 분석
-- 예측 목표: 지역별 뺑소니 발생 건수 및 치명률 예측, 고위험 지역 식별, 시간적 추세 예측

CREATE TABLE silver.silver_hit_and_run AS
WITH
    -- 원본 데이터 추출
    RawData AS (
        SELECT
            searchyear,
            gugun_nm,
            stat_type,
            data AS stat_data
        FROM
            tra.hit_and_run_acid
    ),
    
    -- 구군별 연도별 지표 계산
    GugunMetrics AS (
        SELECT
            searchyear,
            gugun_nm,
            SUM(CASE WHEN stat_type = '발생건수 (건)' THEN stat_data ELSE 0 END) AS occrrnc_cnt,
            SUM(CASE WHEN stat_type = '사망자수 (명)' THEN stat_data ELSE 0 END) AS dth_cnt,
            SUM(CASE WHEN stat_type = '부상자수 (명)' THEN stat_data ELSE 0 END) AS injpsn_cnt,
            -- 사망률: (사망자수 ÷ 발생건수) × 100
            CASE
                WHEN SUM(CASE WHEN stat_type = '발생건수 (건)' THEN stat_data ELSE 0 END) > 0
                THEN ROUND(SUM(CASE WHEN stat_type = '사망자수 (명)' THEN stat_data ELSE 0 END) * 100.0 / 
                          SUM(CASE WHEN stat_type = '발생건수 (건)' THEN stat_data ELSE 0 END), 2)
                ELSE 0
            END AS dth_rate,
            -- 부상률: (부상자수 ÷ 발생건수) × 100
            CASE
                WHEN SUM(CASE WHEN stat_type = '발생건수 (건)' THEN stat_data ELSE 0 END) > 0
                THEN ROUND(SUM(CASE WHEN stat_type = '부상자수 (명)' THEN stat_data ELSE 0 END) * 100.0 / 
                          SUM(CASE WHEN stat_type = '발생건수 (건)' THEN stat_data ELSE 0 END), 2)
                ELSE 0
            END AS injpsn_rate
        FROM
            RawData
        GROUP BY
            searchyear,
            gugun_nm
    ),
    
    -- 구군별 전년 대비 증감 계산
    GugunYoY AS (
        SELECT
            searchyear,
            gugun_nm,
            occrrnc_cnt,
            -- 전년도 값 조회
            LAG(occrrnc_cnt, 1, 0) OVER (PARTITION BY gugun_nm ORDER BY searchyear) AS prev_year_occrrnc_cnt,
            -- 증감률 계산: ((올해-작년) ÷ 작년) × 100
            CASE
                WHEN LAG(occrrnc_cnt, 1, 0) OVER (PARTITION BY gugun_nm ORDER BY searchyear) > 0
                THEN ROUND((occrrnc_cnt - LAG(occrrnc_cnt, 1, 0) OVER (PARTITION BY gugun_nm ORDER BY searchyear)) * 100.0 / 
                          LAG(occrrnc_cnt, 1, 0) OVER (PARTITION BY gugun_nm ORDER BY searchyear), 2)
                ELSE NULL
            END AS occrrnc_cnt_change_rate
        FROM
            GugunMetrics
    ),
    
    -- 전체 구군 대비 발생률 계산
    GugunOccrrncRate AS (
        SELECT
            searchyear,
            gugun_nm,
            -- 발생률: (구군별 발생건수 ÷ 전체 구군 발생건수 합) × 100
            ROUND(SUM(occrrnc_cnt) * 100.0 / SUM(SUM(occrrnc_cnt)) OVER (PARTITION BY searchyear), 2) AS occrrnc_rate
        FROM
            GugunMetrics
        GROUP BY
            searchyear,
            gugun_nm
    )

-- 최종 통합 테이블
SELECT
    rd.searchyear,                              -- 연도
    rd.gugun_nm,                                -- 구군명
    rd.stat_type,                               -- 통계 유형
    rd.stat_data,                               -- 원본 데이터값
    
    -- GugunMetrics에서
    gm.occrrnc_cnt,                             -- 구군별 발생건수
    gm.dth_cnt,                                 -- 구군별 사망자수
    gm.injpsn_cnt,                              -- 구군별 부상자수
    gm.dth_rate,                                -- 구군별 사망률(%)
    gm.injpsn_rate,                             -- 구군별 부상률(%)
    
    -- GugunYoY에서
    gyoy.prev_year_occrrnc_cnt,                 -- 전년도 발생건수
    gyoy.occrrnc_cnt_change_rate,               -- 발생건수 전년 대비 증감률(%)
    
    -- GugunOccrrncRate에서
    gor.occrrnc_rate,                           -- 구군별 발생률(%)
    
    -- 구군별 순위 계산 (기존 risk_group 유지)
    gr.risk_group                               -- 위험도 그룹(1:상위, -1:하위, 0:중간)

FROM
    RawData rd
LEFT JOIN
    GugunMetrics gm ON rd.searchyear = gm.searchyear AND rd.gugun_nm = gm.gugun_nm
LEFT JOIN
    GugunYoY gyoy ON rd.searchyear = gyoy.searchyear AND rd.gugun_nm = gyoy.gugun_nm
LEFT JOIN
    GugunOccrrncRate gor ON rd.searchyear = gor.searchyear AND rd.gugun_nm = gor.gugun_nm
LEFT JOIN
    (
        SELECT
            searchyear,
            gugun_nm,
            occrrnc_cnt,
            -- 위험도 그룹 분류: 상위 3개(1), 하위 3개(-1), 나머지(0)
            CASE
                WHEN ROW_NUMBER() OVER (PARTITION BY searchyear ORDER BY occrrnc_cnt DESC) <= 3 THEN 1
                WHEN ROW_NUMBER() OVER (PARTITION BY searchyear ORDER BY occrrnc_cnt ASC) <= 3 THEN -1
                ELSE 0
            END AS risk_group
        FROM
            GugunMetrics
    ) gr ON rd.searchyear = gr.searchyear AND rd.gugun_nm = gr.gugun_nm
ORDER BY
    rd.searchyear DESC,
    rd.gugun_nm,
    rd.stat_type;

-- 테이블 및 컬럼 주석 (규칙에 맞게 수정)
COMMENT ON TABLE silver.silver_hit_and_run IS '뺑소니 사고 통계 및 증감 지표 통합 테이블';

COMMENT ON COLUMN silver.silver_hit_and_run.searchyear IS '통계 연도';
COMMENT ON COLUMN silver.silver_hit_and_run.gugun_nm IS '자치구명';
COMMENT ON COLUMN silver.silver_hit_and_run.stat_type IS '통계 항목(발생건수, 사망자수, 부상자수)';
COMMENT ON COLUMN silver.silver_hit_and_run.stat_data IS '원본 통계값';

COMMENT ON COLUMN silver.silver_hit_and_run.occrrnc_cnt IS '구군별 발생건수';
COMMENT ON COLUMN silver.silver_hit_and_run.dth_cnt IS '구군별 사망자수';
COMMENT ON COLUMN silver.silver_hit_and_run.injpsn_cnt IS '구군별 부상자수';
COMMENT ON COLUMN silver.silver_hit_and_run.dth_rate IS '구군별 사망률(%)';
COMMENT ON COLUMN silver.silver_hit_and_run.injpsn_rate IS '구군별 부상률(%)';
COMMENT ON COLUMN silver.silver_hit_and_run.prev_year_occrrnc_cnt IS '전년도 발생건수';
COMMENT ON COLUMN silver.silver_hit_and_run.occrrnc_cnt_change_rate IS '발생건수 전년 대비 증감률(%)';
COMMENT ON COLUMN silver.silver_hit_and_run.occrrnc_rate IS '구군별 발생률(%)';
COMMENT ON COLUMN silver.silver_hit_and_run.risk_group IS '위험도 그룹(1:상위, -1:하위, 0:중간)'; 