SELECT --특정 날씨 조건('비' 또는 '눈')일 때 지역별 평균 사고 수
  searchyear,
  gugun_nm, 
  weather, 
  stat_type,
  ROUND(AVG(data), 1) AS avg_accidents
FROM traffic_acid_stats_weather
WHERE weather IN ('비', '눈') AND stat_type = '발생건수 (건)' and gugun_nm != '전체'
GROUP BY gugun_nm, searchyear, weather, stat_type
ORDER by searchyear asc;


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
  searchyear,
  gugun_nm,
  weather,
  data,
  ROUND(
    data * 100.0 / NULLIF(SUM(data) OVER (PARTITION BY gugun_nm), 0), 2
  ) AS percentage_by_weather
FROM traffic_acid_stats_weather
WHERE searchyear = '2022' AND stat_type = '발생건수 (건)' and weather !='모든 날씨'
ORDER BY gugun_nm, percentage_by_weather DESC;
