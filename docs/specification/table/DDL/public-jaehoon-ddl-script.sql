-- public.sido_sgg definition

-- Drop table

-- DROP TABLE public.sido_sgg;

CREATE TABLE public.sido_sgg (
	sido_nm varchar(50) NULL, -- 예: 서울특별시, 부산광역시 등
	sido_code varchar(10) NULL, -- 예: 서울특별시=1100, 부산광역시=1200 등
	gugun_nm varchar(50) NULL, -- 예: 강남구, 서초구 등
	gugun_code varchar(10) NULL -- 예: 강남구=1116, 서초구=1119 등
);
COMMENT ON TABLE public.sido_sgg IS '관공서에서 제공하는 시구군 식별 코드';

-- Column comments

COMMENT ON COLUMN public.sido_sgg.sido_nm IS '예: 서울특별시, 부산광역시 등';
COMMENT ON COLUMN public.sido_sgg.sido_code IS '예: 서울특별시=1100, 부산광역시=1200 등';
COMMENT ON COLUMN public.sido_sgg.gugun_nm IS '예: 강남구, 서초구 등';
COMMENT ON COLUMN public.sido_sgg.gugun_code IS '예: 강남구=1116, 서초구=1119 등';