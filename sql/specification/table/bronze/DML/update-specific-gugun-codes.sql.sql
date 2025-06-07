-- 중구(1102 → 140), 강서구(1111 → 500)로 일괄 변경

-- traffic_acid_by_weekday 테이블
UPDATE tra.traffic_acid_by_weekday
SET gugun_code = CASE
    WHEN gugun_code = '1102' THEN '140'   -- 중구
    WHEN gugun_code = '1111' THEN '500'   -- 강서구
    ELSE gugun_code
END
WHERE gugun_code IN ('1102', '1111');

-- traffic_acid_stats_by_vehicle 테이블
UPDATE tra.traffic_acid_stats_by_vehicle
SET gugun_code = CASE
    WHEN gugun_code = '1102' THEN '140'   -- 중구
    WHEN gugun_code = '1111' THEN '500'   -- 강서구
    ELSE gugun_code
END
WHERE gugun_code IN ('1102', '1111');

-- traffic_safety_index 테이블
UPDATE tra.traffic_safety_index
SET gugun_code = CASE
    WHEN gugun_code = '1102' THEN '140'   -- 중구
    WHEN gugun_code = '1111' THEN '500'   -- 강서구
    ELSE gugun_code
END
WHERE gugun_code IN ('1102', '1111');

-- traffic_violation_stats 테이블
UPDATE tra.traffic_violation_stats
SET gugun_code = CASE
    WHEN gugun_code = '1102' THEN '140'   -- 중구
    WHEN gugun_code = '1111' THEN '500'   -- 강서구
    ELSE gugun_code
END
WHERE gugun_code IN ('1102', '1111');

-- unlicensed_driver_stats 테이블
UPDATE tra.unlicensed_driver_stats
SET gugun_code = CASE
    WHEN gugun_code = '1102' THEN '140'   -- 중구
    WHEN gugun_code = '1111' THEN '500'   -- 강서구
    ELSE gugun_code
END
WHERE gugun_code IN ('1102', '1111');