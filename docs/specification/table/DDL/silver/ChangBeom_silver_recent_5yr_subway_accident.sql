
-- 최근 5년간 지하철사고 통계 recent_5yr_subway_accident


--사고 유형별 연도별 사고 발생 건수
SELECT
	EXTRACT(YEAR FROM acid_date) AS 발생연도,
	acid_type AS 사고유형,
	count(*) AS 발생건수
FROM tra.recent_5yr_subway_accident
GROUP BY EXTRACT(YEAR FROM acid_date), acid_type
ORDER BY 발생건수 DESC, 발생연도 DESC
-- WHERE EXTRACT(YEAR FROM acid_date) = 2024 -> 2024년도 자료


-- 최근 5년간 연도별 사고 발생 건수
SELECT
	EXTRACT(YEAR FROM acid_date) AS 발생연도,
	count(*) AS 발생건수
FROM tra.recent_5yr_subway_accident
GROUP BY EXTRACT(YEAR FROM acid_date)
ORDER BY 발생연도 ASC
-- WHERE EXTRACT(YEAR FROM acid_date) = 2024 -> 2024년도 자료



-- 최근 5년간 사고 유형별 통계

SELECT
	acid_type AS 사고유형,
	count(*) AS 발생건수
FROM tra.recent_5yr_subway_accident
GROUP BY acid_type
ORDER BY 발생건수 DESC




-- 최근 5년간 사고발생이 가장 많은 역 TOP 10

SELECT
	station_name AS 지하철역,
	count(*) AS 발생건수
FROM tra.recent_5yr_subway_accident
GROUP BY station_name
ORDER BY 발생건수 DESC LIMIT 10



-- 최근 5년간 사고발생이 가장 많은 시간대 TOP 10

SELECT
	EXTRACT(HOUR FROM acid_time) AS 사고시간대,
	count(*) 발생건수
FROM tra.recent_5yr_subway_accident
WHERE EXTRACT(HOUR FROM acid_time) != 0
--'미정'이라 써 있는 부분을 00이라고 입력하여 집계에서 제외
GROUP BY 사고시간대
ORDER BY 발생건수 DESC LIMIT 10


