CREATE TABLE tra.child_acid_deaths (
	id int4 DEFAULT nextval('tra.child_accident_deaths_id_seq'::regclass) NOT NULL,
	searchyear varchar NOT NULL, -- 연도
	gender varchar NOT NULL, -- 성별
	"stat_type" text NOT NULL, -- 분류컬럼 (사망자수)
	accident_type text NOT NULL, -- 사교유형 (교통사고)
	base_population int4 NOT NULL, -- 타겟 인원수
	"data" int4 NULL, -- 합계 (총 사망자수)
	CONSTRAINT child_accident_deaths_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE tra.child_acid_deaths IS '아동안전사고 사망자 현황 테이블 (교통사고건)';

-- Column comments

COMMENT ON COLUMN tra.child_acid_deaths.searchyear IS '연도';
COMMENT ON COLUMN tra.child_acid_deaths.gender IS '성별';
COMMENT ON COLUMN tra.child_acid_deaths."stat_type" IS '분류컬럼 (사망자수)';
COMMENT ON COLUMN tra.child_acid_deaths.accident_type IS '사교유형 (교통사고)';
COMMENT ON COLUMN tra.child_acid_deaths.base_population IS '타겟 인원수';
COMMENT ON COLUMN tra.child_acid_deaths."data" IS '합계 (총 사망자수)';

CREATE TABLE tra.fire_cause_stats_by_firestation (
	id int4 DEFAULT nextval('tra.fire_cause_stats_by_firsstation_id_seq'::regclass) NOT NULL,
	searchyear varchar NOT NULL, -- 연도
	district varchar NOT NULL, -- 소방서명
	fire_type text NOT NULL, -- 화재유형1
	cause_type text NOT NULL, -- 화재유형2
	"data" int4 NULL, -- 합계
	CONSTRAINT fire_cause_stats_by_firsstation_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE tra.fire_cause_stats_by_firestation IS '서울시 원인별 화재발생(소방서별)';

-- Column comments

COMMENT ON COLUMN tra.fire_cause_stats_by_firestation.searchyear IS '연도';
COMMENT ON COLUMN tra.fire_cause_stats_by_firestation.district IS '소방서명';
COMMENT ON COLUMN tra.fire_cause_stats_by_firestation.fire_type IS '화재유형1';
COMMENT ON COLUMN tra.fire_cause_stats_by_firestation.cause_type IS '화재유형2';
COMMENT ON COLUMN tra.fire_cause_stats_by_firestation."data" IS '합계';


CREATE TABLE tra.traffic_acid_by_weekday (
	id serial4 NOT NULL,
	searchyear varchar NOT NULL, -- 연도
	gugun_code varchar NOT NULL, -- 자치구코드
	gugun_nm varchar NOT NULL, -- 자치구명
	occrrnc_day_cd varchar(1) NOT NULL, -- 요일코드
	occrrnc_day_nm varchar(3) NOT NULL, -- 요일명
	"stat_type" text NULL, -- 분류컬럼
	"data" int4 NULL, -- 데이터
	CONSTRAINT traffic_acid_by_weekday_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE tra.traffic_acid_by_weekday IS '요일별 교통사고 현황 테이블';

-- Column comments

COMMENT ON COLUMN tra.traffic_acid_by_weekday.searchyear IS '연도';
COMMENT ON COLUMN tra.traffic_acid_by_weekday.gugun_code IS '자치구코드';
COMMENT ON COLUMN tra.traffic_acid_by_weekday.gugun_nm IS '자치구명';
COMMENT ON COLUMN tra.traffic_acid_by_weekday.occrrnc_day_cd IS '요일코드';
COMMENT ON COLUMN tra.traffic_acid_by_weekday.occrrnc_day_nm IS '요일명';
COMMENT ON COLUMN tra.traffic_acid_by_weekday."stat_type" IS '분류컬럼';
COMMENT ON COLUMN tra.traffic_acid_by_weekday."data" IS '데이터';

CREATE TABLE tra.traffic_acid_stats_by_vehicle (
	id int4 DEFAULT nextval('tra.traffic_accident_stats_by_vehicle_id_seq'::regclass) NOT NULL,
	searchyear varchar NULL, -- 연도
	gugun_code varchar NULL, -- 자치구코드
	gugun_nm text NULL, -- 자치구명
	dmge_vhcty_cd varchar(2) NULL, -- 차종코드
	vehicle_use_type text NULL, -- 차량유형대분류
	vehicle_mid_category varchar NULL, -- 차량유형중분류
	vehicle_sub_category varchar NULL, -- 차량유형소분류
	"stat_type" text NULL, -- 분류컬럼
	"data" int4 NULL, -- 데이터
	CONSTRAINT traffic_accident_stats_by_vehicle_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE tra.traffic_acid_stats_by_vehicle IS '차량용도별 교통사고 현황 테이블';

-- Column comments

COMMENT ON COLUMN tra.traffic_acid_stats_by_vehicle.searchyear IS '연도';
COMMENT ON COLUMN tra.traffic_acid_stats_by_vehicle.gugun_code IS '자치구코드';
COMMENT ON COLUMN tra.traffic_acid_stats_by_vehicle.gugun_nm IS '자치구명';
COMMENT ON COLUMN tra.traffic_acid_stats_by_vehicle.dmge_vhcty_cd IS '차종코드';
COMMENT ON COLUMN tra.traffic_acid_stats_by_vehicle.vehicle_use_type IS '차량유형대분류';
COMMENT ON COLUMN tra.traffic_acid_stats_by_vehicle.vehicle_mid_category IS '차량유형중분류';
COMMENT ON COLUMN tra.traffic_acid_stats_by_vehicle.vehicle_sub_category IS '차량유형소분류';
COMMENT ON COLUMN tra.traffic_acid_stats_by_vehicle."stat_type" IS '분류컬럼';
COMMENT ON COLUMN tra.traffic_acid_stats_by_vehicle."data" IS '데이터';


CREATE TABLE tra.unlicensed_driver_stats ( -- 무면허운전자 교통사고 현황 테이블
	id serial4 NOT NULL,
	searchyear varchar NOT NULL, -- 연도
	gugun_code varchar NOT NULL, -- 자치구코드
	gugun_nm text NOT NULL, -- 자치구명
	"stat_type" text NOT NULL, -- 분류컬럼(발생건수 등)
	total_count int4 NULL, -- 데이터
	CONSTRAINT unlicensed_driver_stats_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE tra.unlicensed_driver_stats IS '무면허운전자 교통사고 현황 테이블';

-- Column comments

COMMENT ON COLUMN tra.unlicensed_driver_stats.searchyear IS '연도';
COMMENT ON COLUMN tra.unlicensed_driver_stats.gugun_code IS '자치구코드';
COMMENT ON COLUMN tra.unlicensed_driver_stats.gugun_nm IS '자치구명';
COMMENT ON COLUMN tra.unlicensed_driver_stats."stat_type" IS '분류컬럼(발생건수 등)';
COMMENT ON COLUMN tra.unlicensed_driver_stats.total_count IS '데이터';

CREATE TABLE tra.traffic_violation_stats (
	id serial4 NOT NULL,
	searchyear varchar NOT NULL, -- 연도
	gugun_code varchar NOT NULL, -- 자치구코드
	gugun_nm varchar NOT NULL, -- 자치구명
	aslt_vtr_cd varchar(2) NOT NULL, -- 법규위반코드
	aslt_vtr_nm varchar NOT NULL, -- 법규위반명
	"stat_type" text NULL, -- 분류컬럼(발생건수 등)
	"data" int4 NULL, -- 데이터
	CONSTRAINT traffic_violation_stats_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE tra.traffic_violation_stats IS '법규위반별 교통사고 현황 테이블';

-- Column comments

COMMENT ON COLUMN tra.traffic_violation_stats.searchyear IS '연도';
COMMENT ON COLUMN tra.traffic_violation_stats.gugun_code IS '자치구코드';
COMMENT ON COLUMN tra.traffic_violation_stats.gugun_nm IS '자치구명';
COMMENT ON COLUMN tra.traffic_violation_stats.aslt_vtr_cd IS '법규위반코드';
COMMENT ON COLUMN tra.traffic_violation_stats.aslt_vtr_nm IS '법규위반명';
COMMENT ON COLUMN tra.traffic_violation_stats."stat_type" IS '분류컬럼(발생건수 등)';
COMMENT ON COLUMN tra.traffic_violation_stats."data" IS '데이터';


CREATE TABLE tra.traffic_safety_index (
	id serial4 NOT NULL,
	"searchYear" varchar NOT NULL, -- 연도
	gugun_code varchar NOT NULL, -- 자치구코드
	gugun_nm varchar NOT NULL, -- 자치구명
	"data" float8 NULL, -- 데이터
	CONSTRAINT traffic_safety_index_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE tra.traffic_safety_index IS '교통안전지수 통계';

-- Column comments

COMMENT ON COLUMN tra.traffic_safety_index."searchYear" IS '연도';
COMMENT ON COLUMN tra.traffic_safety_index.gugun_code IS '자치구코드';
COMMENT ON COLUMN tra.traffic_safety_index.gugun_nm IS '자치구명';
COMMENT ON COLUMN tra.traffic_safety_index."data" IS '데이터';