SELECT --연도별 여성 교통사고 발생 건수, 사망자수, 부상자수 추이
  searchyear,
  gugun_nm,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 발생건수,
  SUM(CASE WHEN stat_type = '사망자수 (명)' THEN data ELSE 0 END) AS 사망자수,
  SUM(CASE WHEN stat_type = '부상자수 (명)' THEN data ELSE 0 END) AS 부상자수
FROM tra.traffic_acid_women
GROUP BY searchyear, gugun_nm
ORDER BY searchyear;


SELECT --지역(구군)별 여성 사고 발생건수 TOP 10
  searchyear,
  gugun_nm,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 총발생건수
FROM tra.traffic_acid_women
GROUP BY gugun_nm, searchyear
ORDER BY 총발생건수 DESC
LIMIT 10;


SELECT --여성 교통사고가 가장 많았던 연도 TOP 5
  searchyear,
  gugun_nm,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 총발생건수
FROM tra.traffic_acid_women
GROUP BY searchyear, gugun_nm
ORDER BY 총발생건수 DESC
LIMIT 5;


SELECT --지역별 여성 교통사고 평균 사망자수
  searchyear,
  gugun_nm,
  ROUND(AVG(CASE WHEN stat_type = '사망자수 (명)' THEN data END), 2) AS 평균사망자수
FROM tra.traffic_acid_women
GROUP BY gugun_nm, searchyear
ORDER BY 평균사망자수 DESC;


SELECT --연도별 stat_type(사망자수, 부상자수, 발생건수)의 최대값과 최소값 
    searchyear,
    gugun_nm,
    stat_type,
    MAX(data) AS max_value,
    MIN(data) AS min_value
FROM traffic_acid_women
GROUP BY searchyear, stat_type, gugun_nm
ORDER BY searchyear, stat_type;
