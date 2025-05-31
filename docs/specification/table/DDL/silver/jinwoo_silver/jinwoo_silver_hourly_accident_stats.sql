- 시간대별 사고 발생 패턴 분석
-- 연도/시간대별 서울시 전체 발생건수,사망,부상자수 
SELECT
  searchyear,
  hour,
  stat_type,
  SUM(data) AS 합계
FROM tra.hourly_accident_stats
WHERE gugun_code <> '000' AND HOUR <> '전체'
GROUP BY searchyear, hour, stat_type
ORDER BY searchyear, hour, stat_type;

- 연도별/구별/시간대별 추세
-- 연도/구별 각 시간대에 따른 발생건수,사망,부상자수 
SELECT
  searchyear,
  GUGUN_CODE,
  gugun_nm,
  hour,
  stat_type,
  SUM(data) AS 합계
FROM tra.hourly_accident_stats
WHERE gugun_code <>'000' AND HOUR <>'전체'
GROUP BY searchyear, gugun_code, gugun_nm, hour, stat_type
ORDER BY searchyear, gugun_nm, hour, stat_type;

- 요일별 교차 집계(가능 시)
* 평일 vs 주말 시간대별 패턴 차이

- TOP3 위험 시간대
-- 구별로 “사고건수 많은 TOP3 시간대” 조회 (연도별)
SELECT
  ranked.searchyear AS searchyear,
  ranked.gugun_code AS gugun_code,
  ranked.gugun_nm   AS gugun_nm,
  ranked.hour AS hour,
  ranked.발생건수,
  ranked.rn AS rank
FROM (
  SELECT
    a.searchyear,
    a.gugun_code,
    a.gugun_nm,
    a.hour,
    SUM(CASE WHEN a.stat_type LIKE '발생건수%' THEN a.data END) AS 발생건수,
    ROW_NUMBER() OVER (PARTITION BY a.searchyear ORDER BY SUM(CASE WHEN a.stat_type LIKE '발생건수%' THEN a.data END) DESC) AS rn
  FROM tra.hourly_accident_stats a
  WHERE a.gugun_nm <>'전체' AND a.hour <>'전체'
  GROUP BY a.searchyear, a.gugun_code, a.gugun_nm, a.hour
) ranked
WHERE ranked.rn <= 3
ORDER BY ranked.searchyear, ranked.gugun_code, ranked.rn;

-- 시간대별 사망자수/부상자수 비율
SELECT
  searchyear,
  gugun_nm,
  hour,
  COALESCE(
    ROUND(
      100.0 * SUM(CASE WHEN stat_type LIKE '사망자수%' THEN data END)
      / NULLIF(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 0)
    , 2)
  , 0) AS "사망률",
  COALESCE(
    ROUND(
      100.0 * SUM(CASE WHEN stat_type LIKE '부상자수%' THEN data END)
      / NULLIF(SUM(CASE WHEN stat_type LIKE '발생건수%' THEN data END), 0)
    , 2)
  , 0) AS "부상률"
FROM tra.hourly_accident_stats 
WHERE gugun_nm <> '전체' AND hour <> '전체'
GROUP BY searchyear, gugun_nm, hour
ORDER BY 1, 2, 3;

-- 구군별 사고발생 증감률
SELECT
  searchyear,
  gugun_nm,
  hour,
  stat_type,
  SUM(data)  AS "합계",
  LAG(SUM(data), 1) OVER (
    PARTITION BY stat_type, gugun_nm, hour
    ORDER BY searchyear
  ) AS "전년도_합계",
  ROUND(
    100.0 * (
      SUM(data) - LAG(SUM(data), 1) OVER (PARTITION BY stat_type, gugun_nm, hour ORDER BY searchyear)
    ) / NULLIF(LAG(SUM(data), 1) OVER (PARTITION BY stat_type, gugun_nm, hour ORDER BY searchyear), 0)
    , 2
  ) AS "증감률_퍼센트"
FROM tra.hourly_accident_stats
WHERE gugun_nm <> '전체' AND hour <> '전체'
GROUP BY searchyear, gugun_nm, hour, stat_type
ORDER BY gugun_nm, hour, stat_type, searchyear;


