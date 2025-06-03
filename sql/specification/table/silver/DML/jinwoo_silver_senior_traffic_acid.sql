-- 노인사고 유형별 분포
SELECT
  senior_acid_type,
  stat_type,
  SUM(data) AS "합계"
FROM tra.senior_traffic_acid
GROUP BY senior_acid_type, stat_type
ORDER BY senior_acid_type, stat_type;

-- 노인사고 연도별/구별 변화 추이
-- 연도별/구별/사고유형/구분(발생건수, 부상자수, 사망자수) 집계
SELECT
  searchyear,
  gugun_code,
  gugun_nm,
  senior_acid_type,
  stat_type,
  SUM(data)     AS "합계"
FROM tra.senior_traffic_acid
WHERE gugun_nm <> '전체'
GROUP BY searchyear, gugun_code,gugun_nm, senior_acid_type, stat_type
ORDER BY searchyear, gugun_nm, senior_acid_type, stat_type;

-- 노인사고 사망자/부상자 비율
SELECT
  searchyear,
  gugun_code,
  gugun_nm,
  senior_acid_type,
  ROUND(
    100.0 * SUM(CASE WHEN stat_type LIKE '사망자수%' THEN data END)
         / NULLIF(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 0), 2
  ) AS "사망률(%)",
  ROUND(
    100.0 * SUM(CASE WHEN stat_type LIKE '부상자수%' THEN data END)
         / NULLIF(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 0), 2
  ) AS "부상률(%)"
FROM tra.senior_traffic_acid
WHERE gugun_nm <> '전체'
GROUP BY searchyear, gugun_code,gugun_nm, senior_acid_type
ORDER BY searchyear, gugun_nm, senior_acid_type;

-- 노인사고가 많이 일어나는 지역/연도 TOP3
SELECT *
FROM (
  SELECT
    searchyear,
    gugun_code,
    gugun_nm,
    SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) AS "노인사고_건수",
    ROW_NUMBER() OVER (PARTITION BY searchyear ORDER BY SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) DESC) AS rn
  FROM tra.senior_traffic_acid
  WHERE gugun_nm <> '전체'
  GROUP BY searchyear, gugun_code, gugun_nm
) ranked
WHERE rn <= 3
ORDER BY searchyear, rn;

-- 연도별/구별 변화 증감률
SELECT
  searchyear,
  gugun_code,
  gugun_nm,
  SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) AS "노인사고_건수",
  LAG(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 1) OVER (PARTITION BY gugun_nm ORDER BY searchyear) AS "전년도_노인사고",
  ROUND(
    100.0 * (SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) - LAG(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 1) OVER (PARTITION BY gugun_nm ORDER BY searchyear))
    / NULLIF(LAG(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 1) OVER (PARTITION BY gugun_nm ORDER BY searchyear), 0)
  , 2) AS "증감률_퍼센트"
FROM tra.senior_traffic_acid
WHERE gugun_nm <> '전체'
GROUP BY gugun_code,gugun_nm, searchyear
ORDER BY gugun_nm, searchyear;

-- 노인사고가 전체사고에서 차지하는 비율 (노인테이블+자치구별 사고테이블 조인)
SELECT
  a.searchyear,
  a.gugun_nm,
  a.senior_acid_type,
  SUM(CASE WHEN a.stat_type LIKE '발생건수%' THEN a.data END) AS "노인사고_건수",
  b."전체건수",
  ROUND(
    (100.0 * SUM(CASE WHEN a.stat_type LIKE '발생건수%' THEN a.data END)
         / NULLIF(b."전체건수", 0))::numeric
  , 2) AS "노인사고_비율(%)"
FROM tra.senior_traffic_acid a
JOIN (
  SELECT searchyear, gugun_nm, SUM(data) AS "전체건수"
  FROM tra.district_traffic_stats
  WHERE stat_type LIKE '발생건수%' AND gugun_nm <> '전체'
  GROUP BY searchyear, gugun_nm
) b
ON a.searchyear = b.searchyear AND a.gugun_nm = b.gugun_nm
GROUP BY a.searchyear, a.gugun_nm, a.senior_acid_type, b."전체건수"
ORDER BY a.searchyear, a.gugun_nm, a.senior_acid_type;