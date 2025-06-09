-- create 사고유형코드
CREATE TABLE accident_type_code (
    acc_ty_lclas_cd TEXT,       -- 사고유형 대분류코드
    acc_ty_lclas_nm TEXT,       -- 사고유형 대분류명
    acc_ty_mlsfc_cd TEXT,       -- 사고유형 중분류코드
    acc_ty_mlsfc_nm TEXT,       -- 사고유형 중분류명
    acc_ty_cd TEXT PRIMARY KEY, -- 사고유형 코드 (PK로 설정)
    acc_ty_nm TEXT              -- 사고유형명
);

-- 테이블 설명
COMMENT ON TABLE accident_type_code IS '사고유형 코드 정보 테이블로, 사고유형의 대분류/중분류 및 상세 유형을 정의함';

-- 컬럼 설명
COMMENT ON COLUMN accident_type_code.acc_ty_lclas_cd IS '사고유형 대분류 코드 (예: 01=차대사람, 02=차대차 등)';
COMMENT ON COLUMN accident_type_code.acc_ty_lclas_nm IS '사고유형 대분류명 (예: 차대사람, 차대차 등)';
COMMENT ON COLUMN accident_type_code.acc_ty_mlsfc_cd IS '사고유형 중분류 코드 (예: 11=횡단중, 21=충돌 등)';
COMMENT ON COLUMN accident_type_code.acc_ty_mlsfc_nm IS '사고유형 중분류명 (예: 횡단중, 충돌, 도로이탈 등)';
COMMENT ON COLUMN accident_type_code.acc_ty_cd IS '사고유형 코드 (최종 상세 사고유형을 식별하는 코드, 예: 01, Z4)';
COMMENT ON COLUMN accident_type_code.acc_ty_nm IS '사고유형명 (최종 상세 사고유형명, 예: 횡단중, 차단기돌파)';


-- create 공통테이블
CREATE TABLE common_code (
    code_group    TEXT NOT NULL,    -- 코드 그룹 (예: 'OCCRRNC_DAY', 'DGHT')
    code          TEXT NOT NULL,    -- 실제 코드 값 (예: '1', '2', ...)
    code_name     TEXT NOT NULL,    -- 코드명 (예: '일', '야간' 등)
    PRIMARY KEY (code_group, code)
);


COMMENT ON TABLE common_code IS '공통 코드 테이블 (발생요일, 주야구분 등 다양한 코드 그룹을 통합 관리)';

COMMENT ON COLUMN common_code.code_group IS '코드 그룹 구분자 (예: OCCRRNC_DAY=발생요일, DGHT=주야구분)';
COMMENT ON COLUMN common_code.code IS '코드 값 (예: 1, 2 등)';
COMMENT ON COLUMN common_code.code_name IS '코드에 대응하는 명칭 (예: 일, 월, 주간, 야간 등)';



-- 도로형태코드 테이블
CREATE TABLE road_form_code (
    road_frm_lclas_cd TEXT,      -- 도로형태 대분류코드
    road_frm_lclas_nm TEXT,      -- 도로형태 대분류명
    road_frm_cd       TEXT PRIMARY KEY,  -- 도로형태 코드
    road_frm_nm       TEXT NOT NULL      -- 도로형태명
);

COMMENT ON TABLE road_form_code IS '도로형태 코드 테이블 (도로형태의 대분류 및 상세 형태 정의)';

COMMENT ON COLUMN road_form_code.road_frm_lclas_cd IS '도로형태 대분류 코드 (예: 01=단일로, 02=교차로 등)';
COMMENT ON COLUMN road_form_code.road_frm_lclas_nm IS '도로형태 대분류명 (예: 단일로, 교차로 등)';
COMMENT ON COLUMN road_form_code.road_frm_cd IS '도로형태 코드 (상세 형태 식별, 예: 01=터널안)';
COMMENT ON COLUMN road_form_code.road_frm_nm IS '도로형태명 (예: 터널안, 횡단보도상 등)';


-- 법규위반코드 테이블
CREATE TABLE violation_code (
    aslt_vtr_cd TEXT PRIMARY KEY,     -- 법규위반 코드
    aslt_vtr_nm TEXT NOT NULL         -- 법규위반 명칭
);

COMMENT ON TABLE violation_code IS '가해자 법규위반 코드 테이블';

COMMENT ON COLUMN violation_code.aslt_vtr_cd IS '가해자 법규위반 코드 (예: 01=과속, 03=신호위반 등)';
COMMENT ON COLUMN violation_code.aslt_vtr_nm IS '가해자 법규위반 명칭';