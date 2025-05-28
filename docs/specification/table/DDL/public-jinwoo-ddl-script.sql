CREATE TABLE public.vehicle_code (
	dmge_vhcty_cd varchar NOT NULL, -- 차종코드
	dmge_vhcty_nm varchar NOT NULL, -- 차종명
	CONSTRAINT vehicle_code_pkey PRIMARY KEY (dmge_vhcty_cd)
);
COMMENT ON TABLE public.vehicle_code IS '차종 코드 마스터 테이블';

-- Column comments

COMMENT ON COLUMN public.vehicle_code.dmge_vhcty_cd IS '차종코드';
COMMENT ON COLUMN public.vehicle_code.dmge_vhcty_nm IS '차종명';