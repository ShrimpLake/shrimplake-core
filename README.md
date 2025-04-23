# 🦐 ShrimpLake - Data Lake Project (1st Team Project)


## 🌊 프로젝트 소개

**ShrimpLake**는 Azure Databricks 기반의 데이터 레이크 환경에서  
외부 데이터를 수집, 정제, 분석, 시각화하는 **엔드-투-엔드 데이터 응용 프로그램**을 구현하는 프로젝트입니다.

이 프로젝트의 목표는, 팀원이 함께 실무에 가까운 데이터 파이프라인을 구축하며  
Python, SQL, Power BI, Databricks에 대한 실전 경험을 쌓는 것입니다.

> **"한 마리의 데이터도 허투루 보지 않는다." – ShrimpLake Philosophy**


## 🏗️ 아키텍처 개요

```plaintext
📦 외부 데이터 소스 (API / 웹 / CSV)
    ↓
🐍 Python 데이터 수집 및 정제 (requests, pandas)
    ↓
💾 Azure Databricks 저장소 (Delta Table)
    ↓
🧠 데이터 분석 (PySpark / SQL)
    ↓
📊 Power BI 대시보드 연결 및 시각화
```

## 🛠️ 기술 스택

| 구분           | 사용 기술                                       |
|----------------|------------------------------------------------|
| 데이터 수집     | Python (requests, BeautifulSoup, Selenium 등)   |
| 데이터 처리     | pandas, PySpark, Databricks SQL                |
| 저장 및 분산처리 | Azure Databricks, Delta Lake                   |
| 시각화         | Power BI                                       |
| 버전관리       | Git + GitHub                                   |

## 📁 디렉토리 구조
``` bash
ShrimpLake-Project/
├── data/                # 원본 데이터 및 정제된 파일
│   ├── raw/
│   └── cleaned/
├── notebooks/           # Databricks 노트북
│   ├── ingestion.ipynb
│   ├── transformation.ipynb
│   └── analysis.ipynb
├── sql/                 # SQL 쿼리문 저장
│   └── summary_queries.sql
├── dashboard/           # Power BI 파일
│   └── ShrimpLake_dashboard.pbix
├── docs/                # 프로젝트 문서
│   └── architecture.png
├── README.md
```

## 👥 팀원 및 역할 분담

| 이름 | 역할            | 담당 업무                                  |
|------|-----------------|---------------------------------------------|
| 미정    | Data Collector  | 외부 데이터 수집 및 자동화                  |
| 미정    | Data Engineer   | 정제 로직 설계, Delta Table 구성            |
| 미정    | Analyst         | 통계 분석 및 피처 엔지니어링                |
| 미정    | BI Developer    | Power BI 대시보드 설계                      |
| 미정    | PM & QA         | 일정 관리, 문서화, 최종 발표                |

> 역할은 유동적으로 조정될 수 있으며, 전원 데이터 분석 전반을 경험합니다.


## 📈 결과물 요약

- 데이터 수집 자동화
- Delta Lake 기반 구조화 저장
- Databricks를 활용한 분산 처리
- Power BI 대시보드 완성
