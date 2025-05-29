-- tra 스키마의 모든 테이블에서 유효하지 않은 구군코드를 검사
-- 유효한 구군코드: 3자리 숫자이며 허용된 코드 목록에 있는 값
DO $$
DECLARE
    table_record record;
    check_query text;
    result_record record;
    found_invalid boolean := false;
BEGIN
    -- gugun_code 컬럼이 있는 테이블만 검사
    FOR table_record IN 
        SELECT t.table_name 
        FROM information_schema.tables t
        JOIN information_schema.columns c 
            ON c.table_schema = t.table_schema 
            AND c.table_name = t.table_name
        WHERE t.table_schema = 'tra' 
        AND t.table_type = 'BASE TABLE'
        AND c.column_name = 'gugun_code'
    LOOP
        -- 각 테이블에 대한 검사 쿼리 생성
        check_query := format(
            'SELECT id, gugun_code 
            FROM tra.%I 
            WHERE gugun_code IS NOT NULL 
            AND (
                LENGTH(gugun_code) <> 3 
                OR gugun_code NOT IN (
                    ''000'',''110'',''140'',''170'',''200'',''215'',''230'',
                    ''260'',''290'',''305'',''320'',''350'',''380'',''410'',
                    ''440'',''470'',''500'',''530'',''545'',''560'',''590'',
                    ''620'',''650'',''680'',''710'',''740''
                )
            )',
            table_record.table_name
        );

        -- 검사 실행
        FOR result_record IN EXECUTE check_query
        LOOP
            found_invalid := true;
            RAISE NOTICE '테이블: %, ID: %, 구군코드: %',
                table_record.table_name,
                result_record.id,
                result_record.gugun_code;
        END LOOP;
    END LOOP;

    -- 검사 결과 요약
    IF NOT found_invalid THEN
        RAISE NOTICE '모든 테이블의 구군코드가 정상입니다.';
    END IF;
END $$;