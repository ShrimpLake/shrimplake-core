

---- 서울시 교통사고 현황(구별) 통계 district_traffic_stats

SELECT * FROM district_traffic_stats;



-- 연도별 교통사고 발생 건수, 사망자수, 부상자수 추이
SELECT 
searchyear AS 연도,
	SUM(CASE WHEN stat_type = '발생건수 (건)'
		THEN DATA
		ELSE 0
		END) AS 발생건수,
	SUM(CASE WHEN stat_type = '자동차 1만대당 발생건수 (건)'
		THEN DATA
		ELSE 0
		END) AS 자동차_1만대당_발생건수,
	SUM(CASE WHEN stat_type = '부상자수 (명)'
		THEN DATA
		ELSE 0
		END) AS 부상자수,
	SUM(CASE WHEN stat_type = '인구 10만명당 부상자수 (명)'
		THEN DATA
		ELSE 0
		END) AS 인구_10만명당_부상자수,
	SUM(CASE WHEN stat_type = '사망자수 (명)'
		THEN DATA
		ELSE 0
		END) AS 사망자수
FROM tra.district_traffic_stats
GROUP BY searchyear
ORDER BY 연도;
-- 1999년부터 2004년까지는 수집된 데이터가 적은지 수치가 매우 적게 잡힘.



-- 지역(구군)별 사고 발생건수 TOP 10
SELECT 
	gugun_nm AS 지역,
	SUM(CASE WHEN stat_type = '발생건수 (건)'
		THEN DATA
		ELSE 0
		END) AS 총발생건수
FROM tra.district_traffic_stats
WHERE gugun_nm != '전체'
GROUP BY gugun_nm
ORDER BY 총발생건수 DESC
LIMIT 10;



--지역(구군)별 자동차_1만대당_발생건수 TOP 10
SELECT 
	gugun_nm AS 지역,
	SUM(CASE WHEN stat_type = '자동차 1만대당 발생건수 (건)'
		THEN DATA
		ELSE 0
		END) AS 자동차_1만대당_발생건수
FROM tra.district_traffic_stats
WHERE gugun_nm != '전체'
GROUP BY gugun_nm
ORDER BY 자동차_1만대당_발생건수 DESC
LIMIT 10;



--지역(구군)별 사고 사망자수 TOP 10
SELECT 
	gugun_nm AS 지역,
	SUM(CASE WHEN stat_type = '사망자수 (명)'
		THEN DATA
		ELSE 0
		END) AS 총사망자수
FROM tra.district_traffic_stats
WHERE gugun_nm != '전체'
GROUP BY gugun_nm
ORDER BY 총사망자수 DESC
LIMIT 10;


-- 지역별 교통사고 평균 사상자수
SELECT 
	gugun_nm AS 지역,
	round(avg(CASE WHEN stat_type = '사망자수 (명)'
			THEN DATA::numeric
			END), 2) AS 평균사망자수,
	round(avg(CASE WHEN stat_type = '부상자수 (명)'
			THEN DATA::numeric
			END), 2) AS 평균부상자수,
	round(
		avg(CASE WHEN stat_type = '사망자수 (명)'
			THEN DATA::numeric
			END)
		+
		avg(CASE WHEN stat_type = '부상자수 (명)'
			THEN DATA::numeric
			END), 2
	) AS 평균사상자수
FROM tra.district_traffic_stats
GROUP BY gugun_nm
ORDER BY 평균사상자수 DESC;


-- 인구 10만명당 평균 사상자수
SELECT 
	gugun_nm AS 지역,
	round(avg(CASE WHEN stat_type = '인구 10만명당 사망자수 (명)'
			THEN DATA::numeric
			END), 2) AS 인구10만명당_평균사망자수,
	round(avg(CASE WHEN stat_type = '인구 10만명당 부상자수 (명)'
			THEN DATA::numeric
			END), 2) AS 인구10만명당_평균부상자수,
	round(
		avg(CASE WHEN stat_type = '인구 10만명당 사망자수 (명)'
			THEN DATA::numeric
			END)
		+
		avg(CASE WHEN stat_type = '인구 10만명당 부상자수 (명)'
			THEN DATA::numeric
			END), 2
	) AS 인구10만명당_평균사상자수
FROM tra.district_traffic_stats
GROUP BY gugun_nm
ORDER BY 인구10만명당_평균사상자수 DESC;


-- 서울지역 전체 평균 사상자수
SELECT 
	gugun_nm AS 지역,
	round(avg(CASE WHEN stat_type = '인구 10만명당 사망자수 (명)'
			THEN DATA::numeric
			END), 2) AS 인구10만명당_평균사망자수,
	round(avg(CASE WHEN stat_type = '인구 10만명당 부상자수 (명)'
			THEN DATA::numeric
			END), 2) AS 인구10만명당_평균부상자수,
	round(
		avg(CASE WHEN stat_type = '인구 10만명당 사망자수 (명)'
			THEN DATA::numeric
			END)
		+
		avg(CASE WHEN stat_type = '인구 10만명당 부상자수 (명)'
			THEN DATA::numeric
			END), 2
	) AS 인구10만명당_평균사상자수
FROM tra.district_traffic_stats
WHERE gugun_nm = '전체'
GROUP BY gugun_nm
ORDER BY 인구10만명당_평균사상자수

