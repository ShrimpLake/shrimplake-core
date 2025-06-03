# 데이터베이스 관계정의서 (ERD Relationship Specification)

## 관계 요약표

| 관계ID   | 부모테이블        | PK            | 타입        | FK           | 유형 | 비고          |
|----------|------------------|---------------|-------------|--------------|------|---------------|
| R01~R21  | public.sgg_code  | gugun_code    | VARCHAR(10) | gugun_code   | 1:N  | 구군코드 참조 |
| R22      | public.vehicle_code | dmge_vhcty_cd | VARCHAR   | dmge_vhcty_cd | 1:N | 차종코드 참조 |
| R23      | public.violation_code | aslt_vtr_cd | TEXT     | aslt_vtr_cd   | 1:N | 법규위반코드 참조 |
| R24      | public.common_code | (code_group, code) | TEXT | (code_group, occrrnc_day_cd) | 1:N | 요일코드(복합키) 참조 |

### R01~R21 자식테이블(들)  
- tra.traffic_acid_stats_by_vehicle
- tra.traffic_safety_index
- tra.district_traffic_stats
- tra.hit_and_run_acid
- tra.traffic_acid_women
- tra.unlicensed_driver_stats
- tra.bicycle_traffic_acid
- tra.monthly_acid_stats
- tra.senior_traffic_acid
- tra.seoul_offending_driver_stats
- tra.traffic_acid_stats_age
- tra.traffic_acid_stats_type
- tra.traffic_acid_stats_weather
- tra.traffic_acid_by_weekday
- tra.protect_gear_acid_stats
- tra.ped_acid_stats
- tra.traffic_violation_stats
- tra.driver_age_accident_stats
- tra.license_years_accident_stats
- tra.drunken_acid_stats
- tra.hourly_accident_stats

### R22 자식테이블
- tra.traffic_acid_stats_by_vehicle

### R23 자식테이블
- tra.traffic_violation_stats

### R24 자식테이블
- tra.traffic_acid_by_weekday
---

## 관계 상세 설명

### R01~R21. 시군구코드 관계
- **관계: 1:N**
- **tra.traffic_acid_stats_by_vehicle.gugun_code** → **sgg_code.gugun_code**
- **tra.traffic_safety_index.gugun_code** → **sgg_code.gugun_code**
- **tra.district_traffic_stats.gugun_code** → **sgg_code.gugun_code**
- **tra.hit_and_run_acid.gugun_code** → **sgg_code.gugun_code**
- **tra.traffic_acid_women.gugun_code** → **sgg_code.gugun_code**
- **tra.unlicensed_driver_stats.gugun_code** → **sgg_code.gugun_code**
- **tra.bicycle_traffic_acid.gugun_code** → **sgg_code.gugun_code**
- **tra.monthly_acid_stats.gugun_code** → **sgg_code.gugun_code**
- **tra.senior_traffic_acid.gugun_code** → **sgg_code.gugun_code**
- **tra.seoul_offending_driver_stats.gugun_code** → **sgg_code.gugun_code**
- **tra.traffic_acid_stats_age.gugun_code** → **sgg_code.gugun_code**
- **tra.traffic_acid_stats_type.gugun_code** → **sgg_code.gugun_code**
- **tra.traffic_acid_stats_weather.gugun_code** → **sgg_code.gugun_code**
- **tra.traffic_acid_by_weekday.gugun_code** → **sgg_code.gugun_code**
- **tra.protect_gear_acid_stats.gugun_code** → **sgg_code.gugun_code**
- **tra.ped_acid_stats.gugun_code** → **sgg_code.gugun_code**
- **tra.traffic_violation_stats.gugun_code** → **sgg_code.gugun_code**
- **tra.driver_age_accident_stats.gugun_code** → **sgg_code.gugun_code**
- **tra.license_years_accident_stats.gugun_code** → **sgg_code.gugun_code**
- **tra.drunken_acid_stats.gugun_code** → **sgg_code.gugun_code**
- **tra.hourly_accident_stats.gugun_code** → **sgg_code.gugun_code**
- **설명:** 사고 통계 데이터의 `gugun_code`는 반드시 마스터 테이블의 시군구 코드만 사용 가능

---

### R22. 차량코드 관계
- **관계: 1:N**
- **traffic_acid_stats_by_vehicle.dmge_vhcty_cd** → **vehicle_code.dmge_vhcty_cd**
- **설명:** 통계별 차량 구분코드(`dmge_vhcty_cd`)는 마스터 차량코드만 사용

---

### R23. 법규위반코드 관계
- ***관계: 1:N**
- **traffic_violation_stats.aslt_vtr_cd** → **violation_code.aslt_vtr_cd**
- **설명:** 법규위반 통계는 위반코드(`aslt_vtr_cd`) 마스터값만 입력 가능

---

### R24. 공통코드(요일) 관계
- **관계: 1:N(복합키)**
- **traffic_acid_by_weekday.code_group, occrrnc_day_cd** → **common_code.code_group, code**
- **설명:** 요일코드는 반드시 공통코드(요일그룹(`code_group, occrrnc_day_cd`)) 기준 사용


---

## 참고
- 복합키는 여러 컬럼으로 연결됨을 의미합니다.

