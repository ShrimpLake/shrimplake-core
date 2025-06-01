

-- 서울시 자전거 교통사고 통계 bicycle_traffic_acid

-- 연도별 자전거 교통사고 발생 건수, 사망자수, 부상자수 추이
SELECT 
searchyear AS 연도,
	SUM(CASE WHEN stat_type = '발생건수 (건)'
		THEN DATA
		ELSE 0
		END) AS 발생건수,
	SUM(CASE WHEN stat_type = '사망자수 (명)'
		THEN DATA
		ELSE 0
		END) AS 사망자수,
	SUM(CASE WHEN stat_type = '부상자수 (명)'
		THEN DATA
		ELSE 0
		END) AS 부상자수
FROM tra.bicycle_traffic_acid
GROUP BY searchyear
ORDER BY 연도;



-- 지역(구군)별 자전거교통사고 사고 발생건수 TOP 10
SELECT 
	gugun_nm AS 지역,
	SUM(CASE WHEN stat_type = '발생건수 (건)'
		THEN DATA
		ELSE 0
		END) AS 총발생건수
FROM tra.bicycle_traffic_acid
WHERE gugun_nm != '전체'
GROUP BY gugun_nm
ORDER BY 총발생건수 DESC
LIMIT 10;



-- 지역(구군)별 자전거교통사고 총사망자수 TOP 10
SELECT 
	gugun_nm AS 지역,
	SUM(CASE WHEN stat_type = '사망자수 (명)'
		THEN DATA
		ELSE 0
		END) AS 총사망자수
FROM tra.bicycle_traffic_acid
WHERE gugun_nm != '전체'
GROUP BY gugun_nm
ORDER BY 총사망자수 DESC
LIMIT 10;



-- 자전거 교통사고가 가장 많았던 연도 TOP 10
SELECT 
	searchyear AS 연도,
	SUM(CASE WHEN stat_type = '발생건수 (건)'
		THEN DATA
		ELSE 0
		END) AS 총발생건수
FROM tra.bicycle_traffic_acid
GROUP BY searchyear
ORDER BY 총발생건수 DESC
LIMIT 10;


-- 지역별 자전거 교통사고 평균 사망자수
SELECT 
	gugun_nm AS 지역,
	round(avg(CASE WHEN stat_type = '사망자수 (명)'
			THEN DATA
			END), 2) AS 평균사망자수
FROM tra.bicycle_traffic_acid
GROUP BY gugun_nm, acid_bike
ORDER BY 평균사망자수 DESC;


-- 지역별 자전거 교통사고 평균 사망자수 - 가해운전자 사고
SELECT 
	gugun_nm AS 지역,
	acid_bike,
	round(avg(CASE WHEN stat_type = '사망자수 (명)'
			THEN DATA
			END), 2) AS 평균사망자수
FROM tra.bicycle_traffic_acid
WHERE acid_bike = '자전거 가해운전자 교통사고'
GROUP BY gugun_nm, acid_bike
ORDER BY 평균사망자수 DESC;

-- 지역별 자전거 교통사고 평균 사망자수 - 피해운전자 사고
SELECT 
	gugun_nm AS 지역,
	acid_bike,
	round(avg(CASE WHEN stat_type = '사망자수 (명)'
			THEN DATA
			END), 2) AS 평균사망자수
FROM tra.bicycle_traffic_acid
WHERE acid_bike = '자전거 피해운전자 교통사고'
GROUP BY gugun_nm, acid_bike
ORDER BY 평균사망자수 DESC;


-- 지역별 자전거 교통사고 평균 부상자수
SELECT
	gugun_nm AS 지역,
	round(avg(data), 2) AS 평균부상자수
FROM tra.bicycle_traffic_acid
WHERE stat_type = '부상자수 (명)'
-- WHERE gugun_nm != '전체'  --> 전체데이터를 제외하고자 하면 사용.
GROUP BY gugun_nm
ORDER BY 평균부상자수 DESC;

-- 지역별 자전거 교통사고 평균 부상자수 - 가해운전자 사고
SELECT 
	gugun_nm AS 지역,
	acid_bike,
	round(avg(data), 2) AS 평균부상자수
FROM tra.bicycle_traffic_acid
WHERE acid_bike = '자전거 가해운전자 교통사고'
AND stat_type = '부상자수 (명)'
-- gugun_nm != '전체'  --> 전체데이터를 제외하고자 하면 사용.
GROUP BY gugun_nm, acid_bike
ORDER BY 평균부상자수 DESC;

-- 지역별 자전거 교통사고 평균 부상자수 - 피해운전자 사고
SELECT 
	gugun_nm AS 지역,
	acid_bike,
	round(avg(data), 2) AS 평균부상자수
FROM tra.bicycle_traffic_acid
WHERE acid_bike = '자전거 피해운전자 교통사고'
AND stat_type = '부상자수 (명)'
-- AND gugun_nm != '전체'  --> 전체데이터를 제외하고자 하면 사용.
GROUP BY gugun_nm, acid_bike
ORDER BY 평균부상자수 DESC;



-- 지역별 자전거 교통 사고 평균 사상자수
SELECT 
	gugun_nm AS 지역,
	round(avg(CASE WHEN stat_type = '사망자수 (명)'
			THEN DATA
			END), 2) AS 평균사망자수,
	round(avg(CASE WHEN stat_type = '부상자수 (명)'
			THEN DATA
			END), 2) AS 평균부상자수,
	round(
		avg(CASE WHEN stat_type = '사망자수 (명)'
			THEN DATA
			END)
		+
		avg(CASE WHEN stat_type = '부상자수 (명)'
			THEN DATA
			END), 2
	) AS 평균사상자수
FROM tra.bicycle_traffic_acid
GROUP BY gugun_nm
ORDER BY 평균사상자수 DESC;


SELECT -- 최대, 최소 발생건수
	searchyear,
	acid_bike,
	stat_type,
	max(data) AS 최대치,
	min(data) AS 최소치
FROM tra.bicycle_traffic_acid
WHERE acid_bike LIKE '%피해운전자%'
-- WHERE acid_bike LIKE '%가해운전자%'  --> 가해운전자일 경우 사용
GROUP BY searchyear, acid_bike, stat_type
ORDER BY stat_type
