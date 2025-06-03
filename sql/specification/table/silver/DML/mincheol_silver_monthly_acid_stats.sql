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
