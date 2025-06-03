-- 구별/연도별 무면허 사고 건수/사망자/부상자
-- 연도별·구별로 사고 유형별 추이 확인
SELECT
  searchyear,
  gugun_nm,
  stat_type,       
  SUM(data) AS "합계"
FROM tra.unlicensed_driver_stats
GROUP BY searchyear, gugun_nm, stat_type
ORDER BY searchyear, gugun_nm, stat_type;

-- 무면허 사고 건수 vs 전체 사고 건수 (무면허+각구별 데이터 조인)
SELECT
  a.searchyear,
  a.gugun_code,
  a.gugun_nm,
  SUM(CASE WHEN a.stat_type LIKE '발생건수%' THEN a.data END) AS "무면허_사고건수",
  b.total_accident AS "전체_사고건수",
  ROUND(
    (100.0 * SUM(CASE WHEN a.stat_type LIKE '발생건수%' THEN a.data END) / NULLIF(b.total_accident, 0))::numeric
  , 2) AS "무면허_사고비중(%)"
FROM tra.unlicensed_driver_stats a
JOIN (
  SELECT
    searchyear,
    gugun_nm,
    SUM(data) AS total_accident
  FROM tra.district_traffic_stats
  WHERE stat_type LIKE '발생건수%'
  GROUP BY searchyear, gugun_nm
) b
  ON a.searchyear = b.searchyear
  AND a.gugun_nm = b.gugun_nm
GROUP BY a.searchyear, a.gugun_code, a.gugun_nm, b.total_accident
ORDER BY a.searchyear, a.gugun_nm;

-- 무면허 사고 연도별 증감률
SELECT
  searchyear,
  gugun_code,
  gugun_nm,
  SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) AS "무면허_발생건수",
  LAG(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 1)
    OVER (PARTITION BY gugun_code ORDER BY searchyear) AS "전년도",
  ROUND(
    100.0 * (
      SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END)
      - LAG(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 1)
          OVER (PARTITION BY gugun_code ORDER BY searchyear)
    ) / NULLIF(
        LAG(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 1)
          OVER (PARTITION BY gugun_code ORDER BY searchyear), 0)
  , 2) AS "증감률_퍼센트"
FROM tra.unlicensed_driver_stats
GROUP BY searchyear, gugun_code, gugun_nm
ORDER BY gugun_code, searchyear;

-- 무면허 사고 TOP5 구 (연도별/구별)
SELECT *
FROM (
  SELECT
    searchyear,
    gugun_code,
    gugun_nm,
    SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) AS "무면허_사고건수",
    RANK() OVER (PARTITION BY searchyear ORDER BY SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) DESC) AS rn
  FROM tra.unlicensed_driver_stats
  GROUP BY searchyear, gugun_code,gugun_nm
) t
WHERE rn <= 5
ORDER BY searchyear, rn;

-- 무면허 사망률/부상률
SELECT
  searchyear,
  gugun_code,
  gugun_nm,
  ROUND(
    100.0 * SUM(CASE WHEN stat_type LIKE '사망자수%' THEN data END) /
      NULLIF(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 0), 2
  ) AS "사망률(%)",
  ROUND(
    100.0 * SUM(CASE WHEN stat_type LIKE '부상자수%' THEN data END) /
      NULLIF(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 0), 2
  ) AS "부상률(%)"
FROM tra.unlicensed_driver_stats
GROUP BY searchyear, gugun_code,gugun_nm
ORDER BY searchyear, gugun_nm;

-- 구별 총 무면허 사고(2005~2024)
-- 지도 시각화 참고
SELECT
  gugun_code,
  gugun_nm,
  SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END) AS "총_무면허_사고"
FROM tra.unlicensed_driver_stats
GROUP BY gugun_code, gugun_nm
ORDER BY "총_무면허_사고" DESC;