# 🏗️ Architecture Overview – ShrimpLake

ShrimpLake는 **Azure 기반 Medallion Architecture**를 중심으로,  
데이터 수집부터 분석 및 시각화까지 이어지는 **엔드-투-엔드 파이프라인**을 설계합니다.


## 🔄 데이터 흐름 요약 (Data process overview)
![Medallion Architecture](/docs/image/image1.png)


## 🧱 구성 요소별 설명

### 1. Data Ingestion – Azure Data Factory
- 매일 `~~` API로부터 데이터 수집
- API 요청 시 `startDate`, `endDate` 자동 설정
- Delta 포맷으로 **Bronze 레이어**에 저장

### 2. Data Processing – Azure Databricks
- **Silver 레이어**에서 중복 제거, Null 처리, 스키마 정규화
- PySpark 사용

### 3. Aggregation – Business Logic
- **Gold 레이어**에서 국가 코드 부여, 통계 집계 수행
- 분석 및 시각화를 위한 최종 테이블 생성

### 4. Visualization – Power BI
- Gold 테이블 기반 대시보드 구성
- 예: 날짜별 지진 발생 추이, 규모별 분포, 지역별 시계열 등


## 🧩 사용 기술 스택

| 컴포넌트         | 역할                                |
|------------------|-------------------------------------|
| Azure Data Factory | ETL 파이프라인 트리거, API 호출     |
| Azure Databricks   | PySpark 처리, Delta 테이블 작성    |
| Delta Lake         | Bronze → Silver → Gold 데이터 계층 |
| Azure Data Lake    | 스토리지 계층                      |
| Power BI           | 데이터 시각화 및 대시보드          |



## 📌 Medallion Architecture 개념

| 계층     | 설명 |
|----------|------|
| 🥉 **Bronze** | 수집된 원본 데이터 (정제 전 상태, 재처리 가능) |
| 🥈 **Silver** | 정제된 구조화 데이터 (Null 제거, 정규화) |
| 🥇 **Gold**   | 분석 목적에 맞게 집계/가공된 데이터 |



## 🖼️ 아키텍처 요약

> 아래 이미지를 참조하세요:

![Medallion_Architecture](/docs/image/image2.png)



## 📌 참고 API

- ~~ API: 작성중 


- 예시 Endpoint:  
  `https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2024-01-01&endtime=2024-01-31`
