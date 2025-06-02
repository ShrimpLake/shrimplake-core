-- 경력구간별 연도별 사고건수
SELECT
  searchyear,
  gugun_code,
  gugun_nm,
  license_period,
  SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) AS "발생건수"
FROM tra.license_years_accident_stats
WHERE gugun_nm = '전체'
GROUP BY searchyear, gugun_code, gugun_nm, license_period
ORDER BY searchyear, license_period;
-- 비율
SELECT
  searchyear,
  gugun_code,
  gugun_nm,
  license_period,
  ROUND(
    100.0 * SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END)
    / SUM(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END)) OVER (PARTITION BY searchyear)
    , 2
  ) AS "비율"
FROM tra.license_years_accident_stats
WHERE gugun_nm = '전체'
GROUP BY searchyear, gugun_code, gugun_nm, license_period
ORDER BY searchyear, license_period;

-- 경력별 사고건수 / 전체사고건수 비중 (조인)
SELECT
  a.searchyear,
  a.gugun_code,
  a.gugun_nm,
  a.license_period,
  a."발생건수" AS "경력구간_사고건수",
  b.total_accident AS "전체_사고건수",
  ROUND(
    (100.0 * a."발생건수" / NULLIF(b.total_accident, 0))::numeric
  , 2) AS "경력구간_비율(%)"
FROM (
  SELECT
    searchyear,
    gugun_code,
    gugun_nm,
    license_period,
    SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) AS "발생건수"
  FROM tra.license_years_accident_stats
  WHERE gugun_nm <> '전체' AND LICENSE_PERIOD <> '전체'
  GROUP BY searchyear, gugun_code, gugun_nm, license_period
) a
JOIN (
  SELECT
    searchyear,
    SUM(data) AS total_accident
  FROM tra.district_traffic_stats
  WHERE gugun_nm <> '전체'
    AND stat_type LIKE '발생건수%'
  GROUP BY searchyear
) b
  ON a.searchyear = b.searchyear
ORDER BY a.searchyear, a.license_period;

-- 경력구간별 사망률,부상률
SELECT
  searchyear,
  gugun_code,
  gugun_nm,
  license_period,
  ROUND(
    100.0 * SUM(CASE WHEN stat_type LIKE '사망자수%' THEN data END)
    / NULLIF(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 0), 2
  ) AS "사망률",
  ROUND(
    100.0 * SUM(CASE WHEN stat_type LIKE '부상자수%' THEN data END)
    / NULLIF(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 0), 2
  ) AS "부상률"
FROM tra.license_years_accident_stats
WHERE LICENSE_PERIOD <> '전체'
GROUP BY searchyear, gugun_code, gugun_nm, license_period
ORDER BY searchyear, license_period;


-- 구별, 경력별 사고 증감률(자치구없이 서울시 전체로도 비중확인 가능)
SELECT
  searchyear,
  gugun_code,
  gugun_nm,
  license_period,
  SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) AS "발생건수",
  LAG(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 1)
    OVER (PARTITION BY license_period, gugun_nm ORDER BY searchyear) AS "전년도_사고건수",
  ROUND(
    100.0 * (
      SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END)
      - LAG(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 1)
          OVER (PARTITION BY license_period, gugun_nm ORDER BY searchyear)
    ) / NULLIF(
        LAG(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 1)
          OVER (PARTITION BY license_period, gugun_nm ORDER BY searchyear), 0)
  , 2) AS "증감률_퍼센트"
FROM tra.license_years_accident_stats
WHERE gugun_nm <> '전체' AND LICENSE_PERIOD <> '전체'
GROUP BY searchyear, gugun_code, gugun_nm, license_period
ORDER BY gugun_nm, license_period, searchyear;

-- 연도별·구별 “사고건수 TOP 경력구간” 뽑기
SELECT
  ranked.searchyear    AS searchyear,
  ranked.gugun_code    AS gugun_code,
  ranked.gugun_nm      AS gugun_nm,
  ranked.license_period AS license_period,
  ranked.발생건수,
  ranked.rn            AS "rank"
FROM (
  SELECT
    searchyear,
    gugun_code,
    gugun_nm,
    license_period,
    SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) AS 발생건수,
    ROW_NUMBER() OVER (PARTITION BY searchyear, gugun_code ORDER BY SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) DESC) AS rn
  FROM tra.license_years_accident_stats
  WHERE gugun_nm <> '전체' AND license_period <> '전체'
  GROUP BY searchyear, gugun_code, gugun_nm, license_period
) ranked
WHERE ranked.rn <= 3   
ORDER BY ranked.searchyear, ranked.gugun_nm, ranked.rn;