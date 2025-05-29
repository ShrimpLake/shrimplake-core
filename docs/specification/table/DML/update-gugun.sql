-- tra 스키마의 모든 테이블(테스트 테이블 제외)의 구군코드를 새로운 코드체계로 일괄 업데이트
-- 기존 4자리 코드를 3자리 표준코드로 변환
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
    tbl RECORD;
    i int;
    updated_count int;
    total_updated int := 0;
BEGIN
    RAISE NOTICE 'Starting REAL code update process in tra schema...';
    
    -- tra 스키마에서 gugun_code 컬럼이 있는 모든 테이블 (테스트 테이블 제외)
    FOR tbl IN
        SELECT table_schema, table_name
        FROM information_schema.columns
        WHERE column_name = 'gugun_code'
          AND table_schema = 'tra'  -- tra 스키마만!
          AND table_name != 'test_bicycle_traffic_acid'  -- 테스트 테이블 제외
    LOOP
        RAISE NOTICE 'Processing tra table: %.%', tbl.table_schema, tbl.table_name;
        
        -- 구별로 반복
        FOR i IN 1 .. array_length(code_map, 1)
        LOOP
            EXECUTE format(
                'UPDATE %I.%I SET gugun_code = %L WHERE gugun_code = %L',
                tbl.table_schema, tbl.table_name,
                code_map[i][2],  -- 새 코드
                code_map[i][1]   -- 기존 코드
            );
            GET DIAGNOSTICS updated_count = ROW_COUNT;
            
            IF updated_count > 0 THEN
                RAISE NOTICE 'tra.%: Updated % rows (%s -> %s)', 
                    tbl.table_name, updated_count, 
                    code_map[i][1], code_map[i][2];
                total_updated := total_updated + updated_count;
            END IF;
        END LOOP;
    END LOOP;
    
    RAISE NOTICE 'REAL Code update completed in tra schema! Total updated rows: %', total_updated;
END $$;