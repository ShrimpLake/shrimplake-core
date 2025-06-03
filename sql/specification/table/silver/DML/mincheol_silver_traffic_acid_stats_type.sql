SELECT --연도별 전체 사고 발생 추이
	searchyear,
	gugun_nm,
	stat_type,
	SUM(data) AS total_accidents
FROM traffic_acid_stats_type
WHERE acc_ty_lclas_nm = '합계' AND stat_type = '발생건수 (건)'
GROUP BY 
	searchyear,
	stat_type,
	gugun_nm
ORDER BY searchyear;


SELECT --사고 유형별 연도별 사고 발생 건수
	searchyear, 
	gugun_nm,
	acc_ty_lclas_nm, 
	SUM(data) AS total_by_type
FROM traffic_acid_stats_type
WHERE acc_ty_lclas_nm != '합계' AND stat_type = '발생건수 (건)'
GROUP BY searchyear, acc_ty_lclas_nm, gugun_nm
ORDER BY searchyear, total_by_type DESC;


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
