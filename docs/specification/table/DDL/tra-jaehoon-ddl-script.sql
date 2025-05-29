-- tra.hourly_accident_stats definition

-- Drop table

-- DROP TABLE tra.hourly_accident_stats;

CREATE TABLE tra.hourly_accident_stats (
	id serial4 NOT NULL, -- 고유번호(PK, 자동증가)
	searchyear text NOT NULL, -- 연도(예: 2005, 2006 등)
	gugun_nm varchar(50) NOT NULL, -- 자치구명(예: 전체, 종로구 등)
	"stat_type" text NOT NULL, -- 통계 항목(발생건수, 사망자수, 부상자수)
	"hour" text NOT NULL, -- 시간대(전체, 00시-02시, 02시-04시 등)
	"data" int4 NOT NULL, -- 통계값(해당 구간의 건수)
	CONSTRAINT hourly_accident_stats_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE tra.hourly_accident_stats IS '시간대별 교통사고 통계';

-- Column comments

COMMENT ON COLUMN tra.hourly_accident_stats.id IS '고유번호(PK, 자동증가)';
COMMENT ON COLUMN tra.hourly_accident_stats.searchyear IS '연도(예: 2005, 2006 등)';
COMMENT ON COLUMN tra.hourly_accident_stats.gugun_nm IS '자치구명(예: 전체, 종로구 등)';
COMMENT ON COLUMN tra.hourly_accident_stats."stat_type" IS '통계 항목(발생건수, 사망자수, 부상자수)';
COMMENT ON COLUMN tra.hourly_accident_stats."hour" IS '시간대(전체, 00시-02시, 02시-04시 등)';
COMMENT ON COLUMN tra.hourly_accident_stats."data" IS '통계값(해당 구간의 건수)';

-- tra.license_years_accident_stats definition

-- Drop table

-- DROP TABLE tra.license_years_accident_stats;

CREATE TABLE tra.license_years_accident_stats (
	id serial4 NOT NULL, -- 고유번호(PK, 자동증가)
	searchyear text NOT NULL, -- 통계 연도(예: 2012, 2013 등)
	gugun_nm varchar(50) NOT NULL, -- 자치구명(예: 전체, 종로구 등)
	"stat_type" text NOT NULL, -- 통계 항목(발생건수 (건), 사망자수 (명), 부상자수 (명))
	license_period text NOT NULL, -- 운전면허 취득 경과년수 구간(전체, 5년 미만, 10년 미만, 15년 미만, 15년 이상, 기타불명)
	"data" int4 NOT NULL, -- 통계값(해당 구간의 건수)
	CONSTRAINT license_years_accident_stats_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE tra.license_years_accident_stats IS '운전면허 취득경과년수별 교통사고 현황 통계';

-- Column comments

COMMENT ON COLUMN tra.license_years_accident_stats.id IS '고유번호(PK, 자동증가)';
COMMENT ON COLUMN tra.license_years_accident_stats.searchyear IS '통계 연도(예: 2012, 2013 등)';
COMMENT ON COLUMN tra.license_years_accident_stats.gugun_nm IS '자치구명(예: 전체, 종로구 등)';
COMMENT ON COLUMN tra.license_years_accident_stats."stat_type" IS '통계 항목(발생건수 (건), 사망자수 (명), 부상자수 (명))';
COMMENT ON COLUMN tra.license_years_accident_stats.license_period IS '운전면허 취득 경과년수 구간(전체, 5년 미만, 10년 미만, 15년 미만, 15년 이상, 기타불명)';
COMMENT ON COLUMN tra.license_years_accident_stats."data" IS '통계값(해당 구간의 건수)';

-- tra.driver_age_accident_stats definition

-- Drop table

-- DROP TABLE tra.driver_age_accident_stats;

CREATE TABLE tra.driver_age_accident_stats (
	id serial4 NOT NULL, -- 고유번호(PK, 자동증가)
	searchyear text NOT NULL, -- 통계 연도(예: 2005, 2006 등)
	gugun_nm varchar(50) NOT NULL, -- 자치구명(예: 전체, 종로구 등)
	"stat_type" text NOT NULL, -- 통계 항목(발생건수, 사망자수, 부상자수)
	age_group text NOT NULL, -- 가해 운전자 연령대(전체, 20세이하, 21~30세, ..., 연령불명)
	"data" int4 NOT NULL, -- 통계값(해당 연령대의 건수)
	gugun_code varchar(10) NULL, -- 구군 코드
	CONSTRAINT driver_age_accident_stats_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE tra.driver_age_accident_stats IS '가해 운전자 연령대별 교통사고 현황 통계';

-- Column comments

COMMENT ON COLUMN tra.driver_age_accident_stats.id IS '고유번호(PK, 자동증가)';
COMMENT ON COLUMN tra.driver_age_accident_stats.searchyear IS '통계 연도(예: 2005, 2006 등)';
COMMENT ON COLUMN tra.driver_age_accident_stats.gugun_nm IS '자치구명(예: 전체, 종로구 등)';
COMMENT ON COLUMN tra.driver_age_accident_stats."stat_type" IS '통계 항목(발생건수, 사망자수, 부상자수)';
COMMENT ON COLUMN tra.driver_age_accident_stats.age_group IS '가해 운전자 연령대(전체, 20세이하, 21~30세, ..., 연령불명)';
COMMENT ON COLUMN tra.driver_age_accident_stats."data" IS '통계값(해당 연령대의 건수)';
COMMENT ON COLUMN tra.driver_age_accident_stats.gugun_code IS '구군 코드';

-- tra.ped_acid_stats definition

-- Drop table

-- DROP TABLE tra.ped_acid_stats;

CREATE TABLE tra.ped_acid_stats (
	id serial4 NOT NULL, -- 고유번호(PK, 자동증가)
	searchyear text NOT NULL, -- 통계 연도(예: 2005, 2006 등)
	gugun_nm varchar(50) NOT NULL, -- 자치구명(예: 전체, 종로구 등)
	ped_stat text NOT NULL, -- 보행자의 사고 당시 상태(전체, 횡단중, 차도 통행중, 길가장자리구역통행중, 보도통행중, 기타)
	"stat_type" text NOT NULL, -- 통계 항목(발생건수, 사망자수, 부상자수)
	"data" int4 NOT NULL, -- 통계값(해당 구간의 건수)
	gugun_code varchar(10) NULL,
	CONSTRAINT ped_acid_stats_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE tra.ped_acid_stats IS '보행 교통사고 현황 통계(연도, 자치구, 보행상태, 통계항목, 값)';

-- Column comments

COMMENT ON COLUMN tra.ped_acid_stats.id IS '고유번호(PK, 자동증가)';
COMMENT ON COLUMN tra.ped_acid_stats.searchyear IS '통계 연도(예: 2005, 2006 등)';
COMMENT ON COLUMN tra.ped_acid_stats.gugun_nm IS '자치구명(예: 전체, 종로구 등)';
COMMENT ON COLUMN tra.ped_acid_stats.ped_stat IS '보행자의 사고 당시 상태(전체, 횡단중, 차도 통행중, 길가장자리구역통행중, 보도통행중, 기타)';
COMMENT ON COLUMN tra.ped_acid_stats."stat_type" IS '통계 항목(발생건수, 사망자수, 부상자수)';
COMMENT ON COLUMN tra.ped_acid_stats."data" IS '통계값(해당 구간의 건수)';

-- tra.protect_gear_acid_stats definition

-- Drop table

-- DROP TABLE tra.protect_gear_acid_stats;

CREATE TABLE tra.protect_gear_acid_stats (
	id int4 DEFAULT nextval('tra.protet_gear_acid_stats_id_seq'::regclass) NOT NULL, -- 고유번호(PK, 자동증가)
	searchyear text NOT NULL, -- 통계 연도(예: 2011, 2012 등)
	gugun_nm varchar(50) NOT NULL, -- 자치구명(예: 전체, 종로구 등)
	gear_type text NOT NULL, -- 보호장구 종류(전체, 안전벨트/카시트, 안전모(헬멧))
	wearing_status text NOT NULL, -- 착용여부(전체, 착용, 미착용, 착용불명)
	rate_type text NOT NULL, -- 전체/착용률(%) 구분
	"stat_type" text NOT NULL, -- 통계 항목(사망자수, 부상자수)
	"data" int4 NOT NULL, -- 통계값(사상자수 또는 착용률, 소수 가능)
	gugun_code varchar(10) NULL, -- 구군 구별 코드
	CONSTRAINT protet_gear_acid_stats_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE tra.protect_gear_acid_stats IS '보호장구 착용여부별 교통사고 사상자수 통계';

-- Column comments

COMMENT ON COLUMN tra.protect_gear_acid_stats.id IS '고유번호(PK, 자동증가)';
COMMENT ON COLUMN tra.protect_gear_acid_stats.searchyear IS '통계 연도(예: 2011, 2012 등)';
COMMENT ON COLUMN tra.protect_gear_acid_stats.gugun_nm IS '자치구명(예: 전체, 종로구 등)';
COMMENT ON COLUMN tra.protect_gear_acid_stats.gear_type IS '보호장구 종류(전체, 안전벨트/카시트, 안전모(헬멧))';
COMMENT ON COLUMN tra.protect_gear_acid_stats.wearing_status IS '착용여부(전체, 착용, 미착용, 착용불명)';
COMMENT ON COLUMN tra.protect_gear_acid_stats.rate_type IS '전체/착용률(%) 구분';
COMMENT ON COLUMN tra.protect_gear_acid_stats."stat_type" IS '통계 항목(사망자수, 부상자수)';
COMMENT ON COLUMN tra.protect_gear_acid_stats."data" IS '통계값(사상자수 또는 착용률, 소수 가능)';
COMMENT ON COLUMN tra.protect_gear_acid_stats.gugun_code IS '구군 구별 코드';

-- tra.drunken_acid_stats definition

-- Drop table

-- DROP TABLE tra.drunken_acid_stats;

CREATE TABLE tra.drunken_acid_stats (
	id serial4 NOT NULL, -- 고유 식별자(PK)
	searchyear text NOT NULL, -- 연도
	gugun_nm varchar(50) NOT NULL, -- 군구 이름(전국은 전체)
	"stat_type" text NOT NULL, -- 통계 구분(발생건수, 사망자수, 부상자수)
	"data" int4 NOT NULL, -- 해당 통계 수치
	CONSTRAINT drunken_acid_stats_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE tra.drunken_acid_stats IS '음주운전 교통사고 연도별 통계(구군별, 발생건수/사망자수/부상자수)';

-- Column comments

COMMENT ON COLUMN tra.drunken_acid_stats.id IS '고유 식별자(PK)';
COMMENT ON COLUMN tra.drunken_acid_stats.searchyear IS '연도';
COMMENT ON COLUMN tra.drunken_acid_stats.gugun_nm IS '군구 이름(전국은 전체)';
COMMENT ON COLUMN tra.drunken_acid_stats."stat_type" IS '통계 구분(발생건수, 사망자수, 부상자수)';
COMMENT ON COLUMN tra.drunken_acid_stats."data" IS '해당 통계 수치';
