-- 서울시 가해운전자 성별 교통사고 현황 통계 seoul_offending_driver_stats


-- 가해운전자 성별에 따른 사고 발생건수, 사망자수, 부상자수 합계
SELECT 
  gender AS 가해운전자성별,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 발생건수,
  SUM(CASE WHEN stat_type = '사망자수 (명)' THEN data ELSE 0 END) AS 사망자수,
  SUM(CASE WHEN stat_type = '부상자수 (명)' THEN data ELSE 0 END) AS 부상자수
FROM tra.seoul_offending_driver_stats
GROUP BY gender
ORDER BY 발생건수 DESC;


--구군별(지역별) 전체 교통사고 발생건수 상위 TOP 10

SELECT
  gugun_nm AS 지역,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 총발생건수
FROM tra.seoul_offending_driver_stats
WHERE gugun_nm != '전체'
GROUP BY gugun_nm
ORDER BY 총발생건수 DESC
LIMIT 10;



--가해운전자 성별에 따른 평균 사망자수 및 부상자수

SELECT 
  gender AS 가해운전자성별,
  ROUND(AVG(CASE WHEN stat_type = '사망자수 (명)' THEN data END), 2) AS 평균사망자수,
  ROUND(AVG(CASE WHEN stat_type = '부상자수 (명)' THEN data END), 2) AS 평균부상자수
FROM tra.seoul_offending_driver_stats
GROUP BY gender
ORDER BY 평균부상자수 DESC;




-- 가해운전자 성별에 따른 사망자수 집계, 높은 유형 (연도 기준 집계)
SELECT
  searchyear AS 연도,
  gender AS 가해운전자성별,
  SUM(data) AS 사망자수합계
FROM tra.seoul_offending_driver_stats
WHERE stat_type = '사망자수 (명)' AND gender != '모든 성별'
GROUP BY searchyear, gender
ORDER BY 사망자수합계 DESC



--연도별 가해운전자=남성 교통사고 발생 건수, 사망자수, 부상자수 추이
SELECT
  searchyear AS 연도,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 발생건수,
  SUM(CASE WHEN stat_type = '사망자수 (명)' THEN data ELSE 0 END) AS 사망자수,
  SUM(CASE WHEN stat_type = '부상자수 (명)' THEN data ELSE 0 END) AS 부상자수
FROM tra.seoul_offending_driver_stats
WHERE gender = '남자'
GROUP BY searchyear
ORDER BY 연도;


--연도별 가해운전자=여성 교통사고 발생 건수, 사망자수, 부상자수 추이
SELECT
  searchyear AS 연도,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 발생건수,
  SUM(CASE WHEN stat_type = '사망자수 (명)' THEN data ELSE 0 END) AS 사망자수,
  SUM(CASE WHEN stat_type = '부상자수 (명)' THEN data ELSE 0 END) AS 부상자수
FROM tra.seoul_offending_driver_stats
WHERE gender = '여자'
GROUP BY searchyear
ORDER BY 연도;

--연도별 stat_type(사망자수, 부상자수, 발생건수)의 최대값과 최소값 
SELECT
    searchyear,
    stat_type,
    MAX(data) AS 최대값,
    MIN(data) AS 최소값
FROM tra.seoul_offending_driver_stats
WHERE gender = '남자'
GROUP BY searchyear, stat_type
ORDER BY searchyear, stat_type;


-- 자치구별 가해운전자=남성운전자 교통사고
SELECT 
	searchyear AS 년도,
	gugun_code AS 구군코드,
	gugun_nm AS 구군명,
	stat_type AS 사고지표,
	sum(data) AS 사고건수
FROM
	tra.seoul_offending_driver_stats
WHERE
	gender = '남자'
	AND gugun_nm = '강남구'
	AND stat_type = '발생건수 (건)'
GROUP BY searchyear, gugun_code, gugun_nm, stat_type
ORDER BY searchyear, gugun_nm, 사고지표


-- 이 주제는 여성운전자 교통사고 데이터가 겹치는 것으로 보임.