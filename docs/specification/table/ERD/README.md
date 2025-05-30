# 데이터베이스 관계정의서 (ERD Relationship Specification)

## 관계 요약표

| 관계ID | 부모테이블         | 🔑PK 컬럼          | 타입        | 자식테이블(들)                                                                                                      | 🗝️FK 컬럼              | 관계유형   | 비고                  |
|--------|-------------------|--------------------|-------------|---------------------------------------------------------------------------------------------------------------------|------------------------|------------|-----------------------|
| R01~R18| public.sgg_code   | 🔑gugun_code       | VARCHAR(10) | tra.traffic_acid_stats_by_vehicle<br>tra.traffic_safety_index<br>tra.district_traffic_stats<br>tra.hit_and_run_acid<br>tra.traffic_acid_women<br>tra.unlicensed_driver_stats<br>tra.bicycle_traffic_acid<br>tra.monthly_acid_stats<br>tra.senior_traffic_acid<br>tra.seoul_offending_driver_stats<br>tra.traffic_acid_stats_age<br>tra.traffic_acid_stats_type<br>tra.traffic_acid_stats_weather<br>tra.traffic_acid_by_weekday<br>tra.protect_gear_acid_stats<br>tra.ped_acid_stats<br>tra.traffic_violation_stats<br>tra.driver_age_accident_stats | 🗝️gugun_code           | 1️⃣—♾️    | 구군코드 참조         |
| R17    | public.vehicle_code | 🔑dmge_vhcty_cd    | VARCHAR     | tra.traffic_acid_stats_by_vehicle                                                                                   | 🗝️dmge_vhcty_cd        | 1️⃣—♾️    | 차종코드 참조         |
| R18    | public.violation_code | 🔑aslt_vtr_cd    | TEXT        | tra.traffic_violation_stats                                                                                        | 🗝️aslt_vtr_cd          | 1️⃣—♾️    | 법규위반코드 참조     |
| R19    | public.common_code | 🔑(code_group, code) | TEXT      | tra.traffic_acid_by_weekday                                                                                        | 🗝️(code_group, occrrnc_day_cd) | 1️⃣—♾️ | 요일코드(복합키) 참조 |



---

## 관계 상세 설명

### R01~R18. 시군구코드 관계
- **관계:** 1️⃣ — ♾️ (1:N)
- **tra.traffic_acid_stats_by_vehicle**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.traffic_safety_index**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.district_traffic_stats**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.hit_and_run_acid**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.traffic_acid_women**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.unlicensed_driver_stats**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.bicycle_traffic_acid**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.monthly_acid_stats**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.senior_traffic_acid**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.seoul_offending_driver_stats**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.traffic_acid_stats_age**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.traffic_acid_stats_type**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.traffic_acid_stats_weather**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.traffic_acid_by_weekday**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.protect_gear_acid_stats**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.ped_acid_stats**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.traffic_violation_stats**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **tra.driver_age_accident_stats**.🗝️`gugun_code` → **sgg_code**.🔑`gugun_code`
- **설명:** 사고 통계 데이터의 `gugun_code`는 반드시 마스터 테이블의 시군구 코드만 사용 가능

---

### R10. 차량코드 관계
- **관계:** 1️⃣ — ♾️ (1:N)
- **traffic_acid_stats_by_vehicle**.🗝️`dmge_vhcty_cd` → **vehicle_code**.🔑`dmge_vhcty_cd`
- **설명:** 통계별 차량 구분코드는 마스터 차량코드만 사용

---

### R20. 법규위반코드 관계
- **관계:** 1️⃣ — ♾️ (1:N)
- **traffic_violation_stats**.🗝️`aslt_vtr_cd` → **violation_code**.🔑`aslt_vtr_cd`
- **설명:** 법규위반 통계는 위반코드 마스터값만 입력 가능

---

### R21. 공통코드(요일) 관계
- **관계:** 1️⃣ — ♾️ (1:N, 복합키)
- **traffic_acid_by_weekday**.🗝️`code_group`, `occrrnc_day_cd` → **common_code**.🔑`code_group`, `code`
- **설명:** 요일코드는 반드시 공통코드(요일그룹) 기준 사용


---

## 참고
- **🔑 = Primary Key**
- **🗝️ = Foreign Key**
- **1️⃣—♾️ = 1:N (일대다 관계)**
- 복합키는 여러 컬럼으로 연결됨을 의미합니다.

