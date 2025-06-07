-- bicycle_traffic_acid 테이블의 구군코드 업데이트를 위한 테스트
-- 1. 테스트 테이블 생성 2. 데이터 복사 3. 업데이트 4. 결과 검증

-- 1. 시퀀스 생성
CREATE SEQUENCE tra.test_bicycle_traffic_acid_id_seq;

-- 2. 테이블 생성
CREATE TABLE tra.test_bicycle_traffic_acid (LIKE tra.bicycle_traffic_acid INCLUDING ALL);

-- 3. 시퀀스를 컬럼의 기본값으로 설정
ALTER TABLE tra.test_bicycle_traffic_acid 
    ALTER COLUMN id SET DEFAULT nextval('tra.test_bicycle_traffic_acid_id_seq');

-- 4. 데이터 복사
INSERT INTO tra.test_bicycle_traffic_acid 
SELECT *
FROM tra.bicycle_traffic_acid
ORDER BY id
LIMIT 1000;

-- 5. 시퀀스 현재 값을 마지막 id로 설정
SELECT setval('tra.test_bicycle_traffic_acid_id_seq', 
             (SELECT MAX(id) FROM tra.test_bicycle_traffic_acid));

-- 6. 테이블 구조 확인
SELECT column_name, data_type, column_default, is_nullable
FROM information_schema.columns
WHERE table_schema = 'tra' 
AND table_name = 'test_bicycle_traffic_acid'
ORDER BY ordinal_position;

-- 2. 테스트 테이블 업데이트 (tra 스키마 명시)
DO $$
DECLARE
    rec RECORD;
    code_map CONSTANT text[][] := ARRAY[
        ARRAY['0000', '000'], -- 전체
        ARRAY['1101', '110'], -- 종로구
        ARRAY['1103', '170'], -- 용산구
        ARRAY['1104', '200'], -- 성동구
        ARRAY['1105', '230'], -- 동대문구
        ARRAY['1106', '290'], -- 성북구
        ARRAY['1107', '320'], -- 도봉구
        ARRAY['1108', '380'], -- 은평구
        ARRAY['1109', '410'], -- 서대문구
        ARRAY['1110', '440'], -- 마포구
        ARRAY['1112', '530'], -- 구로구
        ARRAY['1113', '560'], -- 영등포구
        ARRAY['1114', '590'], -- 동작구
        ARRAY['1115', '620'], -- 관악구
        ARRAY['1116', '680'], -- 강남구
        ARRAY['1117', '740'], -- 강동구
        ARRAY['1118', '710'], -- 송파구
        ARRAY['1119', '650'], -- 서초구
        ARRAY['1120', '470'], -- 양천구
        ARRAY['1121', '260'], -- 중랑구
        ARRAY['1122', '350'], -- 노원구
        ARRAY['1123', '215'], -- 광진구
        ARRAY['1124', '305'], -- 강북구
        ARRAY['1125', '545'], -- 금천구
        ARRAY['1212', '500'], -- 강서구
        ARRAY['2601', '140']  -- 중구
    ];
    i int;
    updated_count int;
    total_updated int := 0;
BEGIN
    RAISE NOTICE 'Starting TEST code update process in tra schema...';
    
    -- tra 스키마의 테스트 테이블에서 구별로 코드 업데이트
    FOR i IN 1 .. array_length(code_map, 1)
    LOOP
        UPDATE tra.test_bicycle_traffic_acid 
        SET gugun_code = code_map[i][2]  -- 새 코드
        WHERE gugun_code = code_map[i][1]; -- 기존 코드
        
        GET DIAGNOSTICS updated_count = ROW_COUNT;
        
        IF updated_count > 0 THEN
            RAISE NOTICE 'TEST: Updated % rows (%s -> %s)', 
                updated_count, code_map[i][1], code_map[i][2];
            total_updated := total_updated + updated_count;
        END IF;
    END LOOP;
    
    RAISE NOTICE 'TEST Code update completed! Total updated rows: %', total_updated;
END $$;

-- 3-1. 업데이트 후 새로운 구군코드 확인
SELECT 
    gugun_code,
    gugun_nm,
    COUNT(*) as count
FROM tra.test_bicycle_traffic_acid 
WHERE gugun_code IS NOT NULL
GROUP BY gugun_code, gugun_nm
ORDER BY gugun_code;

-- 3-2. sgg_code 테이블과 매칭 확인 (tra 스키마 명시)
SELECT 
    t.gugun_code, 
    t.gugun_nm,
    s.gugun_code as sgg_table_code,
    s.gugun_nm as ssg_table_name,
    CASE 
        WHEN t.gugun_code = s.gugun_code AND t.gugun_nm = s.gugun_nm THEN 'MATCH'
        ELSE 'MISMATCH'
    END as status
FROM (
    SELECT DISTINCT gugun_code, gugun_nm 
    FROM tra.test_bicycle_traffic_acid 
    WHERE gugun_code IS NOT NULL
) t
LEFT JOIN tra.sgg_code s ON t.gugun_nm = s.gugun_nm  -- tra 스키마 명시
ORDER BY t.gugun_code;