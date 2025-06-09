-- public.sgg_code definition

-- Drop table

-- DROP TABLE public.sgg_code;

CREATE TABLE public.sgg_code (
	gugun_nm varchar(10) NULL, -- 예: 강남구, 서초구 등
	gugun_code varchar(10) NULL -- 각 구에대한 코드
);

-- Column comments

COMMENT ON COLUMN public.sgg_code.gugun_nm IS '예: 강남구, 서초구 등';
COMMENT ON COLUMN public.sgg_code.gugun_code IS '각 구에대한 코드';