-- 연도별/구별 교통안전지수 순위
SELECT
  searchyear,
  gugun_code,
  gugun_nm,
  data,
  RANK() OVER (PARTITION BY searchyear ORDER BY data DESC) AS "rank"
FROM tra.traffic_safety_index
ORDER BY searchyear, "rank";

-- 연도별 안전지수 추이(자치구 필터링)
-- 서울 전체/구별로 안전지수가 얼마나 개선(또는 악화)되었나?
SELECT
  searchyear,
  gugun_code,
  gugun_nm,
  data
FROM tra.traffic_safety_index
WHERE gugun_nm = '강서구'   
ORDER BY searchyear;

-- 안전지수+각구별 발생건수 조인
-- 발생건수가 높은 구는 안전지수가 높을까?(발생건수가 적으면 안전지수가 높을 것이라고 기대대)
-- 결과 : 2005년에 상위5구, 하위5구의 발생건수 평균차이를 고려해본 결과, 발생건수가 많은 구가 안전지수가 높았음
-- 여러 요인들의 영향이 있을 것이라 판단(인구, 도로 환경, 예방정책, 시민 의식 등등)
SELECT
  a.searchyear,
  a.gugun_nm,
  a.data AS "교통안전지수",
  SUM(b.data) AS "발생건수"
FROM tra.traffic_safety_index a
JOIN tra.DISTRICT_TRAFFIC_STATS b
  ON a.searchyear = b.searchyear AND a.gugun_nm = b.gugun_nm AND b.stat_type LIKE '발생건수%'
GROUP BY a.searchyear, a.gugun_nm, a.data
ORDER BY a.searchyear, a.data DESC;
-- 상위5구, 하위5구 발생건수 평균
SELECT
  AVG(사고발생건수) AS 상위5구_평균발생건수
FROM (
  SELECT b.gugun_nm, SUM(b.data) AS 사고발생건수
  FROM tra.DISTRICT_TRAFFIC_STATS b
  WHERE b.searchyear = '2005'
    AND b.gugun_nm IN (
      SELECT gugun_nm
      FROM tra.traffic_safety_index
      WHERE searchyear = '2005'
      ORDER BY data desc -- asc
      LIMIT 5
    )
    AND b.stat_type LIKE '발생건수%'
  GROUP BY b.gugun_nm
) t;

-- 구별/연도별 안전지수 증감률
SELECT
  searchyear,
  gugun_nm,
  data AS "교통안전지수",
  LAG(data, 1) OVER (PARTITION BY gugun_nm ORDER BY searchyear) AS "전년도_안전지수",
  ROUND(
    (100.0 * (data - LAG(data, 1) OVER (PARTITION BY gugun_nm ORDER BY searchyear))
    / NULLIF(LAG(data, 1) OVER (PARTITION BY gugun_nm ORDER BY searchyear), 0))::numeric
  , 2) AS "증감률(%)"
FROM tra.traffic_safety_index
ORDER BY gugun_nm, searchyear;
