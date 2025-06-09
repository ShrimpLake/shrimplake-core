
-- 원인별 화재사고 통계 현황(2009년~) fire_cause_stats_by_firestation

-- 화재사고 유형 통계
SELECT
CASE WHEN cause_type = '소계'
	THEN '자연적 요인'
	ELSE cause_type
	END AS 사고유형,
  SUM(data) AS 합계
FROM tra.fire_cause_stats_by_firestation
GROUP BY cause_type
ORDER BY 합계 DESC
-- 소계 데이터는 자연적 요인에 의한 화재.


-- 화재사고 유형 통계
SELECT
searchyear AS 연도,
CASE WHEN cause_type = '소계'
	THEN '자연적 요인'
	ELSE cause_type
	END AS 사고유형,
  SUM(data) AS 합계
FROM tra.fire_cause_stats_by_firestation
GROUP BY searchyear, cause_type
ORDER BY 연도 ASC, 합계 DESC;
-- 소계 데이터는 자연적 요인에 의한 화재.


-- 이 중 주제에 맞게 교통사고만 통계
SELECT
	searchyear AS 연도,
	cause_type AS 화재원인,
	sum(data) AS 합계
FROM tra.fire_cause_stats_by_firestation
WHERE cause_type = '교통사고'
GROUP BY searchyear, cause_type
ORDER BY 합계 DESC;


-- 소방서별 교통사고가 원인인 화재 통계
SELECT
	CASE WHEN district = '소계'
	THEN '전체' ELSE district END AS 소방서,
	cause_type AS 화재원인,
	sum(data) AS 합계
FROM tra.fire_cause_stats_by_firestation
WHERE cause_type = '교통사고'
GROUP BY district, cause_type
ORDER BY 합계 DESC



-- 특정 소방서의 연도별, 교통사고로 인한 화재 건수
SELECT
	searchyear  AS 연도,
	district AS 소방서,
	cause_type AS 화재원인,
	sum(data) AS 합계
FROM tra.fire_cause_stats_by_firestation
WHERE district = '강남소방서' AND cause_type = '교통사고'
GROUP BY searchyear, district, cause_type
ORDER BY searchyear ASC

