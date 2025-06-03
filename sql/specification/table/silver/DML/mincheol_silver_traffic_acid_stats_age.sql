SELECT --연령대별 전체 사상자 수 (사망 + 부상)
  searchyear,
  gugun_nm,
  ages,
  SUM(CASE WHEN stat_type = '사망자수' THEN data ELSE 0 END) AS total_deaths,
  SUM(CASE WHEN stat_type = '부상자수' THEN data ELSE 0 END) AS total_injuries
FROM traffic_acid_stats_age
WHERE gugun_nm = '전체' and ages!='전체'
GROUP BY ages, searchyear,gugun_nm
ORDER BY ages, searchyear ASC;


SELECT --연도별 사망자수 및 부상자수 변화 추이
  searchyear,
  gugun_nm,
  SUM(CASE WHEN stat_type = '사망자수' THEN data ELSE 0 END) AS total_deaths,
  SUM(CASE WHEN stat_type = '부상자수' THEN data ELSE 0 END) AS total_injuries
FROM traffic_acid_stats_age
WHERE gugun_nm = '전체'
GROUP BY searchyear, gugun_nm
ORDER BY searchyear;


SELECT --연령대별 평균 사망자수
  searchyear,
  gugun_nm,
  ages,
  ROUND(AVG(data), 2) AS avg_deaths
FROM traffic_acid_stats_age
WHERE stat_type = '사망자수' AND gugun_nm = '전체' and ages!='전체'
GROUP BY ages, searchyear, gugun_nm
ORDER BY ages ASC;


SELECT --부상자수가 가장 많았던 상위 5개 연령대 (전체 연도 기준)
  searchyear,
  gugun_nm,
  ages,
  SUM(data) AS total_injuries
FROM traffic_acid_stats_age
WHERE stat_type = '부상자수'
  AND gugun_nm = '전체'
  AND ages <> '전체'
GROUP BY ages, searchyear, gugun_nm
ORDER BY total_injuries DESC
LIMIT 5;
