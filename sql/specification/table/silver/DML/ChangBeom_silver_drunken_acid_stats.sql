-- 음주운전 교통사고 연도별 통계(구군별, 발생건수/사망자수/부상자수) drunken_acid_stats

-- 연도별 음주 교통사고 발생 건수, 사망자수, 부상자수 추이
SELECT 
searchyear AS 연도,
	SUM(CASE WHEN stat_type = '발생건수'
		THEN DATA
		ELSE 0
		END) AS 발생건수,
	SUM(CASE WHEN stat_type = '사망자수'
		THEN DATA
		ELSE 0
		END) AS 사망자수,
	SUM(CASE WHEN stat_type = '부상자수'
		THEN DATA
		ELSE 0
		END) AS 부상자수
FROM tra.drunken_acid_stats
GROUP BY searchyear
ORDER BY 연도;



-- 지역(구군)별 음주운전 사고 발생건수 TOP 10
SELECT 
	gugun_nm AS 지역,
	SUM(CASE WHEN stat_type = '발생건수'
		THEN DATA
		ELSE 0
		END) AS 총발생건수
FROM tra.drunken_acid_stats
WHERE gugun_nm != '전체'
GROUP BY gugun_nm
ORDER BY 총발생건수 DESC
LIMIT 10;



-- 지역(구군)별 음주운전 사고 총사망자수 TOP 10
SELECT 
	gugun_nm AS 지역,
	SUM(CASE WHEN stat_type = '사망자수'
		THEN DATA
		ELSE 0
		END) AS 총사망자수
FROM tra.drunken_acid_stats
WHERE gugun_nm != '전체'
GROUP BY gugun_nm
ORDER BY 총사망자수 DESC
LIMIT 10;



-- 음주운전 교통사고가 가장 많았던 연도 TOP 10
SELECT 
	searchyear AS 연도,
	SUM(CASE WHEN stat_type = '발생건수'
		THEN DATA
		ELSE 0
		END) AS 총발생건수
FROM tra.drunken_acid_stats
GROUP BY searchyear
ORDER BY 총발생건수 DESC
LIMIT 10;



-- 지역별 음주운전 사고 평균 사망자수
SELECT 
	gugun_nm AS 지역,
	round(avg(CASE WHEN stat_type = '사망자수'
			THEN DATA
			END), 2) AS 평균사망자수
FROM tra.drunken_acid_stats
GROUP BY gugun_nm
ORDER BY 평균사망자수 DESC;



-- 지역별 음주운전 사고 평균 부상자수
SELECT 
	gugun_nm AS 지역,
	round(avg(CASE WHEN stat_type = '부상자수'
			THEN DATA
			END), 2) AS 평균부상자수
FROM tra.drunken_acid_stats
GROUP BY gugun_nm
ORDER BY 평균부상자수 DESC;



-- 지역별 음주운전 사고 평균 사상자수
SELECT 
	gugun_nm AS 지역,
	round(avg(CASE WHEN stat_type = '사망자수'
			THEN DATA
			END), 2) AS 평균사망자수,
	round(avg(CASE WHEN stat_type = '부상자수'
			THEN DATA
			END), 2) AS 평균부상자수,
	round(
		avg(CASE WHEN stat_type = '사망자수'
			THEN DATA
			END)
		+
		avg(CASE WHEN stat_type = '부상자수'
			THEN DATA
			END), 2
	) AS 평균사상자수
FROM tra.drunken_acid_stats
GROUP BY gugun_nm
ORDER BY 평균사상자수 DESC;



SELECT -- 최대, 최소 발생건수
	searchyear,
	stat_type,
	max(data) AS 최대치,
	min(data) AS 최소치
FROM drunken_acid_stats
GROUP BY searchyear, stat_type
ORDER BY searchyear, stat_type


