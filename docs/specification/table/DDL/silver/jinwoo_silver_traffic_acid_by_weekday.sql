-- 요일별 집계
SELECT
  occrrnc_day_nm AS "요일",
  stat_type AS "구분",
  SUM(data) AS "합계"
FROM tra.traffic_acid_by_weekday
GROUP BY occrrnc_day_nm, stat_type
ORDER BY occrrnc_day_nm, stat_type;

-- 연도별/요일별 집계
SELECT
  searchyear AS "연도",
  occrrnc_day_nm AS "요일",
  stat_type AS "구분",
  SUM(data) AS "합계"
FROM tra.traffic_acid_by_weekday
GROUP BY searchyear, occrrnc_day_nm, stat_type
ORDER BY searchyear, occrrnc_day_nm, stat_type;

-- 연도별/구별/요일별 발생건수,사망률,부상률
SELECT
  searchyear,
  gugun_code,
  gugun_nm,
  occrrnc_day_nm AS "요일",
  SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) AS "발생건수",
  ROUND(
    100.0 * SUM(CASE WHEN stat_type LIKE '사망자수%' THEN data END)
         / NULLIF(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 0), 2
  ) AS "사망률(%)",
  ROUND(
    100.0 * SUM(CASE WHEN stat_type LIKE '부상자수%' THEN data END)
         / NULLIF(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 0), 2
  ) AS "부상률(%)"
FROM tra.traffic_acid_by_weekday
GROUP BY searchyear, gugun_code, gugun_nm, occrrnc_day_nm
ORDER BY searchyear, "발생건수" DESC;

-- 평일 vs 주말 발생건수 비교
SELECT
  CASE
    WHEN occrrnc_day_nm IN ('토요일','일요일') THEN '주말'
    ELSE '주중'
  END AS "구분",
  SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) AS "사고건수"
FROM tra.traffic_acid_by_weekday
GROUP BY "구분";

-- 전체연도 요일별 발생건수 평균과 연도별/요일별 발생건수를 비교하여 특정연도 요일에 발생건수 이상치 탐색
SELECT
  t.searchyear,
  t.occrrnc_day_nm,
  t.sum_data AS "사고건수",
  a.avg_data AS "요일_평균",
  t.sum_data - a.avg_data AS "평균과의_차이"
FROM (
  SELECT searchyear, occrrnc_day_nm, SUM(data) AS sum_data
  FROM tra.traffic_acid_by_weekday
  WHERE stat_type LIKE '발생건수%'
  GROUP BY searchyear, occrrnc_day_nm
) t
JOIN (
  SELECT occrrnc_day_nm, AVG(sum_data) AS avg_data
  FROM (
    SELECT searchyear, occrrnc_day_nm, SUM(data) AS sum_data
    FROM tra.traffic_acid_by_weekday
    WHERE stat_type LIKE '발생건수%'
    GROUP BY searchyear, occrrnc_day_nm
  ) x
  GROUP BY occrrnc_day_nm
) a
  ON t.occrrnc_day_nm = a.occrrnc_day_nm
ORDER BY t.searchyear, t.occrrnc_day_nm;

-- 구별/요일별 다발지역(연도빼고 구별/요일별로 어느지역에 무슨요일이 사고가 많은지도 확인가능)
SELECT
  searchyear, gugun_code, gugun_nm, occrrnc_day_nm,
  SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) AS "발생건수"
FROM tra.traffic_acid_by_weekday
GROUP BY searchyear, gugun_code, gugun_nm, occrrnc_day_nm
ORDER BY searchyear, gugun_nm, "발생건수" DESC;

-- 연도별/요일별 사고다발 요일 TOP3
SELECT *
FROM (
  SELECT
    searchyear,
    gugun_code,
    gugun_nm,
    occrrnc_day_nm AS "요일",
    SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) AS "발생건수",
    ROW_NUMBER() OVER (PARTITION BY searchyear, gugun_nm ORDER BY SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) DESC) AS rn
  FROM tra.traffic_acid_by_weekday
  GROUP BY searchyear, gugun_code, gugun_nm, occrrnc_day_nm
) ranked
WHERE rn <= 3
ORDER BY searchyear, gugun_nm, rn;

-- 연도별/요일별 발생건수 증감률
SELECT
  searchyear,
  occrrnc_day_nm AS "요일",
  SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) AS "발생건수",
  LAG(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 1) OVER (PARTITION BY occrrnc_day_nm ORDER BY searchyear) AS "전년도_사고건수",
  ROUND(
    100.0 *
    (SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) - LAG(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 1) OVER (PARTITION BY occrrnc_day_nm ORDER BY searchyear))
    / NULLIF(LAG(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 1) OVER (PARTITION BY occrrnc_day_nm ORDER BY searchyear), 0)
  , 2) AS "증감률_퍼센트"
FROM tra.traffic_acid_by_weekday
GROUP BY occrrnc_day_nm, searchyear
ORDER BY occrrnc_day_nm, searchyear;

-- 요일별 + 자치구별 전체 조인
-- 요일별 사고 비중(비율) 확인가능 --> ex: 강남구는 금요일에 사고 비중이 20%로, 다른 구보다 높다
-- 연도별로 특정 요일 사고 비중이 증가/감소하는지
SELECT
  a.searchyear,
  a.gugun_code,
  a.gugun_nm,
  a.occrrnc_day_nm,
  SUM(a.data) AS "요일별_사고건수",
  SUM(b.data) AS "구별_전체사고건수",
  ROUND(
    100.0 * SUM(a.data) / NULLIF(SUM(b.data), 0)
  ::NUMERIC , 2) AS "비중(%)"
FROM tra.traffic_acid_by_weekday a
JOIN tra.district_traffic_stats b
  ON a.searchyear = b.searchyear
  AND a.gugun_nm = b.gugun_nm
  AND b.stat_type LIKE '발생건수%'
WHERE a.stat_type LIKE '발생건수%'
GROUP BY a.searchyear, a.gugun_code, a.gugun_nm, a.occrrnc_day_nm
ORDER BY a.searchyear, a.gugun_nm, a.occrrnc_day_nm;
