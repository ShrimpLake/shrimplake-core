SELECT --법규 위반 유형별 사고 발생건수, 사망자수, 부상자수 합계
  searchyear,
  gugun_nm,
  aslt_vtr_nm AS 법규위반유형,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 발생건수,
  SUM(CASE WHEN stat_type = '사망자수 (명)' THEN data ELSE 0 END) AS 사망자수,
  SUM(CASE WHEN stat_type = '부상자수 (명)' THEN data ELSE 0 END) AS 부상자수
FROM tra.traffic_violation_stats
GROUP BY aslt_vtr_nm,searchyear, gugun_nm
ORDER BY searchyear ASC;


SELECT --구군별(지역별) 전체 교통사고 발생건수 상위 TOP 10
  searchyear,
  gugun_nm,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 총발생건수
FROM tra.traffic_violation_stats
GROUP BY searchyear, gugun_nm
ORDER BY 총발생건수 DESC
LIMIT 10;


SELECT --법규 위반 유형별 평균 사망자수 및 부상자수
  searchyear,
  gugun_nm,
  aslt_vtr_nm AS 법규위반유형,
  ROUND(AVG(CASE WHEN stat_type = '사망자수 (명)' THEN data END), 2) AS 평균사망자수,
  ROUND(AVG(CASE WHEN stat_type = '부상자수 (명)' THEN data END), 2) AS 평균부상자수
FROM tra.traffic_violation_stats
GROUP BY aslt_vtr_nm, searchyear, gugun_nm
ORDER BY searchyear asc, gugun_nm asc;


SELECT --사망자수가 높은 교통사고 유형 TOP 5 (연도 기준 집계)
  searchyear,
  gugun_nm,
  aslt_vtr_nm,
  SUM(data) AS 사망자수합계
FROM tra.traffic_violation_stats
WHERE stat_type = '사망자수 (명)'
GROUP BY searchyear, gugun_nm, aslt_vtr_nm
ORDER BY 사망자수합계 DESC
LIMIT 5;


SELECT --'과속' 위반의 연도별 사고 발생 건수 추이
  searchyear,
  gugun_nm,
  aslt_vtr_nm,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 발생건수합계
FROM tra.traffic_violation_stats
WHERE aslt_vtr_nm = '과속'
GROUP BY searchyear, aslt_vtr_nm, gugun_nm
ORDER by searchyear;
