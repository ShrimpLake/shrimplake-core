--traffic_violation_stats(법규위반별 교통사고 현황 테이블)--

SELECT --법규 위반 유형별 사고 발생건수, 사망자수, 부상자수 합계
  aslt_vtr_nm AS 법규위반유형,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 발생건수,
  SUM(CASE WHEN stat_type = '사망자수 (명)' THEN data ELSE 0 END) AS 사망자수,
  SUM(CASE WHEN stat_type = '부상자수 (명)' THEN data ELSE 0 END) AS 부상자수
FROM tra.traffic_violation_stats
GROUP BY aslt_vtr_nm
ORDER BY 발생건수 DESC;


SELECT --구군별(지역별) 전체 교통사고 발생건수 상위 TOP 10
  gugun_nm AS 지역,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 총발생건수
FROM tra.traffic_violation_stats
GROUP BY gugun_nm
ORDER BY 총발생건수 DESC
LIMIT 10;


SELECT --법규 위반 유형별 평균 사망자수 및 부상자수
  aslt_vtr_nm AS 법규위반유형,
  ROUND(AVG(CASE WHEN stat_type = '사망자수 (명)' THEN data END), 2) AS 평균사망자수,
  ROUND(AVG(CASE WHEN stat_type = '부상자수 (명)' THEN data END), 2) AS 평균부상자수
FROM tra.traffic_violation_stats
GROUP BY aslt_vtr_nm
ORDER BY 평균부상자수 DESC;


SELECT --사망자수가 높은 교통사고 유형 TOP 5 (연도 기준 집계)
  searchyear AS 연도,
  aslt_vtr_nm AS 법규위반유형,
  SUM(data) AS 사망자수합계
FROM tra.traffic_violation_stats
WHERE stat_type = '사망자수 (명)'
GROUP BY searchyear, aslt_vtr_nm
ORDER BY 사망자수합계 DESC
LIMIT 5;


SELECT --'과속' 위반의 연도별 사고 발생 건수 추이
  searchyear AS 연도,
  aslt_vtr_nm,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 발생건수합계
FROM tra.traffic_violation_stats
WHERE aslt_vtr_nm = '과속'
GROUP BY searchyear, aslt_vtr_nm
ORDER BY 연도;


--traffic_acid_women(서울시 여성운전자 교통사고 현황 통계)--

SELECT --연도별 여성 교통사고 발생 건수, 사망자수, 부상자수 추이
  searchyear AS 연도,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 발생건수,
  SUM(CASE WHEN stat_type = '사망자수 (명)' THEN data ELSE 0 END) AS 사망자수,
  SUM(CASE WHEN stat_type = '부상자수 (명)' THEN data ELSE 0 END) AS 부상자수
FROM tra.traffic_acid_women
GROUP BY searchyear
ORDER BY 연도;


SELECT --지역(구군)별 여성 사고 발생건수 TOP 10
  gugun_nm AS 지역,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 총발생건수
FROM tra.traffic_acid_women
GROUP BY gugun_nm
ORDER BY 총발생건수 DESC
LIMIT 10;


SELECT --여성 교통사고가 가장 많았던 연도 TOP 5
  searchyear AS 연도,
  SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END) AS 총발생건수
FROM tra.traffic_acid_women
GROUP BY searchyear
ORDER BY 총발생건수 DESC
LIMIT 5;


SELECT --지역별 여성 교통사고 평균 사망자수
  gugun_nm AS 지역,
  ROUND(AVG(CASE WHEN stat_type = '사망자수 (명)' THEN data END), 2) AS 평균사망자수
FROM tra.traffic_acid_women
GROUP BY gugun_nm
ORDER BY 평균사망자수 DESC;


SELECT --연도별 stat_type(사망자수, 부상자수, 발생건수)의 최대값과 최소값 
    searchyear,
    stat_type,
    MAX(data) AS max_value,
    MIN(data) AS min_value
FROM traffic_acid_women
GROUP BY searchyear, stat_type
ORDER BY searchyear, stat_type;


--traffic_acid_stats_age(교통사고 현황(연령층별 사상자) 테이블)--

SELECT --연령대별 전체 사상자 수 (사망 + 부상)
  ages,
  SUM(CASE WHEN stat_type = '사망자수' THEN data ELSE 0 END) AS total_deaths,
  SUM(CASE WHEN stat_type = '부상자수' THEN data ELSE 0 END) AS total_injuries
FROM traffic_acid_stats_age
WHERE gugun_nm = '전체'
GROUP BY ages
ORDER BY ages;


SELECT --연도별 사망자수 및 부상자수 변화 추이
  searchyear,
  SUM(CASE WHEN stat_type = '사망자수' THEN data ELSE 0 END) AS total_deaths,
  SUM(CASE WHEN stat_type = '부상자수' THEN data ELSE 0 END) AS total_injuries
FROM traffic_acid_stats_age
WHERE gugun_nm = '전체'
GROUP BY searchyear
ORDER BY searchyear;


SELECT --연령대별 평균 사망자수
  ages,
  ROUND(AVG(data), 2) AS avg_deaths
FROM traffic_acid_stats_age
WHERE stat_type = '사망자수' AND gugun_nm = '전체'
GROUP BY ages
ORDER BY ages ASC;


SELECT --부상자수가 가장 많았던 상위 5개 연령대 (전체 연도 기준)
  ages,
  SUM(data) AS total_injuries
FROM traffic_acid_stats_age
WHERE stat_type = '부상자수'
  AND gugun_nm = '전체'
  AND ages <> '전체'
GROUP BY ages
ORDER BY total_injuries DESC
LIMIT 5;


SELECT --연령대별 사고 데이터 존재 연도 범위
  ages,
  MIN(searchyear) AS start_year,
  MAX(searchyear) AS end_year,
  COUNT(DISTINCT searchyear) AS years_reported
FROM traffic_acid_stats_age
WHERE gugun_nm = '전체'
GROUP BY ages
ORDER BY ages;


--traffic_acid_stats_type(교통사고 현황(사고유형별) 통계)--

SELECT --연도별 전체 사고 발생 추이
	searchyear, 
	stat_type,
	SUM(data) AS total_accidents
FROM traffic_acid_stats_type
WHERE acc_ty_lclas_nm = '합계' AND stat_type = '발생건수 (건)'
GROUP BY 
	searchyear,
	stat_type
ORDER BY searchyear;


SELECT --사고 유형별 연도별 사고 발생 건수
	searchyear, 
	acc_ty_lclas_nm, 
	SUM(data) AS total_by_type
FROM traffic_acid_stats_type
WHERE acc_ty_lclas_nm != '합계' AND stat_type = '발생건수 (건)'
GROUP BY searchyear, acc_ty_lclas_nm
ORDER BY searchyear, total_by_type DESC;


SELECT --사고 유형별 연도별 평균 사고 발생 건수
    searchyear, 
    acc_ty_lclas_nm, 
    ROUND(AVG(data), 1) AS avg_accidents
FROM traffic_acid_stats_type
WHERE acc_ty_lclas_nm != '합계'
  AND stat_type = '발생건수 (건)'
GROUP BY searchyear, acc_ty_lclas_nm
ORDER BY searchyear, avg_accidents DESC;


SELECT --특정 연도(예: 2010) 기준 지역별 사고 유형별 비중 -> 특정 연도 기준으로 지역마다 어떤 유형이 높은 비율을 차지했는지 확인 가능
  	searchyear, 
	gugun_nm, 
    acc_ty_lclas_nm,
    ROUND(
    data * 100.0 / NULLIF(SUM(data) OVER (PARTITION BY gugun_nm), 0), 2
  ) AS percentage
FROM traffic_acid_stats_type
WHERE stat_type = '발생건수 (건)' AND searchyear = '2010' AND acc_ty_lclas_nm != '합계'
ORDER BY gugun_nm, percentage DESC;


SELECT --연도별·지역별 특정 사고 유형(예: 차대사람) 발생 건수
  searchyear, 
  gugun_nm, 
  acc_ty_lclas_nm,
  data AS pedestrian_accidents
FROM traffic_acid_stats_type
WHERE stat_type = '발생건수 (건)' AND acc_ty_lclas_nm = '차대사람'
ORDER BY searchyear, pedestrian_accidents DESC;


--traffic_acid_stats_weather(서울시 기상상태별 교통사고 현황 통계)--

SELECT --특정 날씨 조건('비' 또는 '눈')일 때 지역별 평균 사고 수
  gugun_nm, gugun_code, weather, stat_type,
  ROUND(AVG(data), 1) AS avg_accidents
FROM traffic_acid_stats_weather
WHERE weather IN ('비', '눈') AND stat_type = '발생건수 (건)' and gugun_nm != '전체'
GROUP BY gugun_nm, gugun_code, weather, stat_type
ORDER BY avg_accidents DESC;


SELECT --특정 연도 기준(예: 2023) 지역별 날씨 사고 건수 순위
  searchyear,
  gugun_nm,
  weather,
  stat_type,
  data
FROM traffic_acid_stats_weather
WHERE searchyear = '2005' AND stat_type = '발생건수 (건)' and weather !='모든 날씨' and gugun_nm !='전체'
ORDER BY gugun_nm asc, data desc ;


SELECT  --특정 연도 기준 날씨 조건별 사고 발생 비율
  gugun_nm,
  weather,
  data,
  ROUND(
    data * 100.0 / NULLIF(SUM(data) OVER (PARTITION BY gugun_nm), 0), 2
  ) AS percentage_by_weather
FROM traffic_acid_stats_weather
WHERE searchyear = '2022' AND stat_type = '발생건수 (건)' and weather !='모든 날씨'
ORDER BY gugun_nm, percentage_by_weather DESC;


--monthly_acid_stats(월별 교통사고 통계 현황 테이블)--

SELECT --가장 사고가 많이 발생한 연도·월 TOP 10
  searchyear,
  searchmonth,
  stat_type,
  data
FROM monthly_acid_stats
WHERE stat_type = '발생건수 (건)'
ORDER BY data DESC
LIMIT 10;


SELECT --사망자가 가장 많이 발생한 연도·월 TOP 10
  searchyear,
  searchmonth,
  stat_type,
  data
FROM monthly_acid_stats
WHERE stat_type = '사망자수 (명)'
ORDER BY data DESC
LIMIT 10;


SELECT --특정 월의 사고다발 구 TOP 3
  searchyear,
  searchmonth,
  gugun_nm,
  stat_type,
  data
FROM monthly_acid_stats
WHERE searchmonth = '6' AND stat_type = '발생건수 (건)'
ORDER BY data DESC
LIMIT 3;


SELECT --사고 발생 건수가 일정 수 이상인 구·월
  searchyear,
  searchmonth,
  gugun_nm,
  stat_type,
  data
FROM monthly_acid_stats
WHERE stat_type = '발생건수 (건)' AND data >= 3880
ORDER BY data DESC;


select --연도별, 월별, 지역별 사망률
  searchyear,
  searchmonth,
  gugun_nm,
  '사망률 (%)' AS stat_type,
  ROUND(
    SUM(CASE WHEN stat_type = '사망자수 (명)' THEN data ELSE 0 END) * 100.0 /
    NULLIF(SUM(CASE WHEN stat_type = '발생건수 (건)' THEN data ELSE 0 END), 0),
    2
  ) AS data
FROM monthly_acid_stats
GROUP BY searchyear, searchmonth, gugun_nm
ORDER BY searchyear, searchmonth, data DESC;


















