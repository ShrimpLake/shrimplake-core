-- 목적: 보호장구 착용 여부에 따른 사고 결과 분석 및 착용률 변화 추적을 통한 안전도 예측 모델링 기반 구축
-- 머신러닝 적용: 보호장구 종류별 착용 효과 분석, 특정 지역/장구의 착용률 예측, 미착용 시 위험도 증가분 예측
-- 예측 목표: 보호장구 착용 시 사망/부상 감소율 예측, 미래 착용률 예측, 지역별 보호장구 안전도 비교

CREATE TABLE silver.silver_protect_gear_stats AS
WITH
    -- 원본 데이터에서 '전체' rate_type을 기준으로 발생/사망/부상 건수 추출
    RawPivotedCounts AS (
        SELECT
            searchyear,
            gugun_nm,
            gear_type,          -- 보호장구 종류 (예: 안전벨트/카시트, 안전모(헬멧))
            wearing_status,     -- 착용여부 (예: 착용, 미착용, 착용불명)
            SUM(CASE WHEN stat_type = '발생건수' THEN data ELSE 0 END) AS occrrnc_cnt,
            SUM(CASE WHEN stat_type = '사망자수' THEN data ELSE 0 END) AS dth_cnt,
            SUM(CASE WHEN stat_type = '부상자수' THEN data ELSE 0 END) AS injpsn_cnt
        FROM
            tra.protect_gear_acid_stats
        WHERE
            rate_type = '전체'  -- 실제 사상자수 데이터 필터링
            AND gear_type != '전체' AND wearing_status != '전체' -- 세부 항목만 사용
        GROUP BY
            searchyear,
            gugun_nm,
            gear_type,
            wearing_status
    )

-- 최종 통합 테이블 (Grain: 연도, 구군, 보호장구종류, 착용여부)
SELECT
    rpc.searchyear,
    rpc.gugun_nm,
    rpc.gear_type,
    rpc.wearing_status,
    NULLIF(rpc.occrrnc_cnt, 0) AS occrrnc_cnt,
    NULLIF(rpc.dth_cnt, 0) AS dth_cnt,
    NULLIF(rpc.injpsn_cnt, 0) AS injpsn_cnt,
    CASE WHEN rpc.occrrnc_cnt > 0 THEN ROUND(rpc.dth_cnt * 100.0 / rpc.occrrnc_cnt, 2) ELSE NULL END AS dth_rate,
    CASE WHEN rpc.occrrnc_cnt > 0 THEN ROUND(rpc.injpsn_cnt * 100.0 / rpc.occrrnc_cnt, 2) ELSE NULL END AS injpsn_rate
FROM
    RawPivotedCounts rpc
ORDER BY
    rpc.searchyear DESC,
    rpc.gugun_nm,
    rpc.gear_type,
    rpc.wearing_status;

-- 테이블 및 컬럼 주석 (규칙에 맞게 수정)
COMMENT ON TABLE silver.silver_protect_gear_stats IS '보호장구 착용별 사고 통계(발생, 사망, 부상, 사망률, 부상률)';

COMMENT ON COLUMN silver.silver_protect_gear_stats.searchyear IS '통계 연도';
COMMENT ON COLUMN silver.silver_protect_gear_stats.gugun_nm IS '자치구명';
COMMENT ON COLUMN silver.silver_protect_gear_stats.gear_type IS '보호장구 종류';
COMMENT ON COLUMN silver.silver_protect_gear_stats.wearing_status IS '착용여부';
COMMENT ON COLUMN silver.silver_protect_gear_stats.occrrnc_cnt IS '발생건수';
COMMENT ON COLUMN silver.silver_protect_gear_stats.dth_cnt IS '사망자수';
COMMENT ON COLUMN silver.silver_protect_gear_stats.injpsn_cnt IS '부상자수';
COMMENT ON COLUMN silver.silver_protect_gear_stats.dth_rate IS '사망률(%)';
COMMENT ON COLUMN silver.silver_protect_gear_stats.injpsn_rate IS '부상률(%)'; 