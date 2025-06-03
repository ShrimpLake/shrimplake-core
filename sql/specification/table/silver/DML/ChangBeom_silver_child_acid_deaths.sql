-- 아동안전사고 사망자 현황 테이블 (교통사고건) child_acid_deaths

SELECT * FROM tra.child_acid_deaths;

-- 남아 교통사고 사망자수

SELECT
	searchyear AS 연도,
	gender AS 성별,
	base_population AS 총인원수,
	DATA AS 사망자수
FROM tra.child_acid_deaths
WHERE gender = '남자'
ORDER BY searchyear ASC;



-- 여아 교통사고 사망자수

SELECT
	searchyear AS 연도,
	gender AS 성별,
	base_population AS 총인원수,
	DATA AS 사망자수
FROM tra.child_acid_deaths
WHERE gender = '남자'
ORDER BY searchyear ASC;


-- 남아인구 10만명당 사망자 수

SELECT
	searchyear AS 연도,
	gender AS 성별,
	base_population AS 총인원수,
	DATA AS 사망자수,
	round((DATA::numeric / base_population::numeric) * 100000, 2) AS "10만명당_사망자수"
FROM tra.child_acid_deaths
WHERE gender = '남자'
ORDER BY searchyear ASC;



-- 여아인구 10만명당 사망자 수

SELECT
	searchyear AS 연도,
	gender AS 성별,
	base_population AS 총인원수,
	DATA AS 사망자수,
	round((DATA::numeric / base_population::numeric) * 100000, 2) AS "10만명당_사망자수"
FROM tra.child_acid_deaths
WHERE gender = '여자'
ORDER BY searchyear ASC;



-- 남아 여아 10만명당 사망자수 비교 테이블

SELECT
	searchyear AS 연도,
	max(CASE
		WHEN gender = '남자'
		THEN round((DATA::numeric / base_population::numeric) * 100000, 2)
		END) AS "남아_10만명당 사망자수",
	max(CASE
		WHEN gender = '여자'
		THEN round((DATA::numeric / base_population::numeric) * 100000, 2)
		END) AS "여아_10만명당 사망자수"
FROM tra.child_acid_deaths
GROUP BY searchyear
ORDER BY searchyear ASC