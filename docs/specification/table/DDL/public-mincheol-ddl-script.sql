CREATE TABLE traffic_acid_stats_type(  -- 서울시 교통사고 현황(사고유형별) 통계
	id SERIAL PRIMARY KEY,
	searchYear VARCHAR,    -- 연도
	gugun_nm TEXT,         -- 군구명
	gugun_code INTEGER,    -- 군구코드
	acc_ty_lclas_nm TEXT,  -- 사고유형대분류(차대차, 차대사람...)
	stat_type TEXT,      -- 피해지표(발생건수, 사망자수, 부상자수)
	total_cnt INTEGER     -- 각 사고유형별 사고 합계
);

ALTER TABLE traffic_acid_stats_type  RENAME COLUMN total_cnt TO data  --컬럼명 변경

UPDATE tra.traffic_acid_stats_type AS a  -- update 구문(데이터 삽입)
SET gugun_code = b.gugun_code
FROM public.sido_sgg AS b
WHERE a.gugun_nm  = b.gugun_nm;


CREATE TABLE traffic_acid_stats_age(  -- 서울시 교통사고 현황(연령층별 사상자) 통계
	id SERIAL PRIMARY KEY,
	searchYear VARCHAR,    -- 연도
	gugun_nm TEXT,         -- 군구명
	gugun_code VARCHAR,    -- 군구코드
	ages TEXT,  		   -- 연령(12세 이하, 13~20세, 21~30세...)
	stats_type TEXT,        -- 피해지표(사망자수, 부상자수)
	data INTEGER     -- 각 나이별 사고 합계
);

UPDATE tra.traffic_acid_stats_age AS a
SET gugun_code = b.gugun_code
FROM public.sido_sgg AS b
WHERE a.gugun_nm  = b.gugun_nm;


CREATE TABLE hit_and_run_acid(  -- 서울시 뺑소니 교통사고 현황 통계
	id SERIAL PRIMARY KEY,
	searchYear VARCHAR,    -- 연도
	gugun_code VARCHAR,    -- 군구코드
	gugun_nm TEXT,         -- 군구명
	stats_type TEXT,    -- 피해지표(발생건수, 사망자수, 부상자수)
	data INTEGER     -- 각 피해지표별 뺑소니 사고 합계
);

UPDATE tra.hit_and_run_acid AS a
SET gugun_code = b.gugun_code
FROM public.sido_sgg AS b
WHERE a.gugun_nm  = b.gugun_nm ;


DROP TABLE IF EXISTS tra.traffic_acid_stats_weather CASCADE;  -- 테이블 삭제

CREATE TABLE traffic_acid_stats_weather(  -- 서울시 기상상태별 교통사고 현황 통계
	id SERIAL PRIMARY KEY,
	searchYear VARCHAR,    -- 연도
	gugun_nm TEXT,         -- 군구명
	gugun_code VARCHAR,    -- 군구코드
	weather TEXT,  		   -- 날씨유형분류(맑음, 흐림, 비...)
	stats_type TEXT,   -- 피해지표(발생건수, 사망자수, 부상자수)
	data INTEGER     -- 각 날씨별 사고 합계

);

UPDATE tra.traffic_acid_stats_weather AS a
SET gugun_code = b.gugun_code
FROM public.sido_sgg AS b
WHERE a.gugun_nm  = b.gugun_nm;


TRUNCATE TABLE tra.traffic_acid_stats_weather RESTART IDENTITY; -- data 삭제(메모리까지)

CREATE TABLE district_traffic_stats(  -- 서울시 교통사고 현황(구별) 통계
	id SERIAL PRIMARY KEY,
	searchYear VARCHAR,    -- 연도
	gugun_nm TEXT,         -- 군구명
	gugun_code VARCHAR,    -- 군구코드
	stats_type TEXT,       -- 피해지표(발생건수, 사망자수, 부상자수)
	data FLOAT    		   -- 각 피해지표별 합계
);

UPDATE tra.district_traffic_stats AS a
SET gugun_code = b.gugun_code
FROM public.sido_sgg AS b
WHERE a.gugun_nm  = b.gugun_nm;

create table bicycle_traffic_acid(  -- 서울시 자전거 교통사고 통계
	id SERIAL PRIMARY KEY,  
	searchYear VARCHAR,		-- 연도
	gugun_code VARCHAR,		-- 군구코드
	gugun_nm TEXT,			-- 군구명
	acid_bike TEXT,  		-- 자전거 교통사고 유형
	stats_type TEXT,		-- 피해지표(발생건수, 사망자수, 부상자수)
	data INTEGER			-- 각 유형별 사고 합계
	
);

UPDATE tra.bicycle_traffic_acid AS a
SET gugun_code = b.gugun_code
FROM public.sido_sgg AS b
WHERE a.gugun_nm  = b.gugun_nm;


create table seoul_offending_driver_stats( -- 서울시 가해운전자 성별 교통사고 현황 통계
	id SERIAL PRIMARY KEY,  
	searchYear VARCHAR,		-- 연도
	gugun_code VARCHAR,		-- 군구코드
	gugun_nm TEXT,			-- 군구명
	gender TEXT,  			-- 가해운전자 성별 
	stats_type TEXT,		-- 피해지표(발생건수, 사망자수, 부상자수)
	data INTEGER			-- 각 유형별 사고 합계
	
);

UPDATE tra.seoul_offending_driver_stats AS a
SET gugun_code = b.gugun_code
FROM public.sido_sgg AS b
WHERE a.gugun_nm  = b.gugun_nm;


create table traffic_acid_women( -- 서울시 여성운전자 교통사고 현황 통계
	id SERIAL PRIMARY KEY,  
	searchYear VARCHAR,		-- 연도
	gugun_code VARCHAR,		-- 군구코드
	gugun_nm TEXT,			-- 군구명
	stats_type TEXT,		-- 피해지표(발생건수, 사망자수, 부상자수)
	data INTEGER,			-- 각 유형별 사고 합계
);


UPDATE tra.traffic_acid_women AS a
SET gugun_code = b.gugun_code
FROM public.sido_sgg AS b
WHERE a.gugun_nm  = b.gugun_nm;


CREATE TABLE senior_traffic_acid(  -- 서울시 노인 교통사고 현황 통계
	id SERIAL PRIMARY KEY,
	searchYear VARCHAR,    -- 연도
	gugun_code VARCHAR,    -- 군구코드
	gugun_nm TEXT,         -- 군구명
	senior_acid_type TEXT, -- 사고유형분류(노인 교통사고, 노인운전자 교통사고...)
	stats_type TEXT,         -- 피해지표(발생건수, 사망자수, 부상자수)
	data INTEGER     -- 각 사고유형별 사고 합계
);

UPDATE tra.senior_traffic_acid AS a
SET gugun_code = b.gugun_code
FROM public.sido_sgg AS b
WHERE a.gugun_nm  = b.gugun_nm;






