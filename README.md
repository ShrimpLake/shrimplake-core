# 🦐 ShrimpLake - Data Lake Project (1st Team Project)

![대시보드_결과물](https://github.com/user-attachments/assets/8cfd05d8-fc44-44bf-bc35-20ac2aaf81a8)


## 🌊 프로젝트 소개

**ShrimpLake**는 Azure Databricks 기반의 데이터 레이크 환경에서  
외부 데이터를 수집, 정제, 분석, 시각화하는 **엔드-투-엔드 데이터 응용 프로그램**을 구현하는 프로젝트입니다.

이 프로젝트의 목표는, 팀원이 함께 실무에 가까운 데이터 파이프라인을 구축하며  
Python, SQL, Power BI, Databricks에 대한 실전 경험을 쌓는 것입니다.

> **"여긴 도망도 못쳐. 일단 타면 악으로 깡으로 낚아야 해." – ShrimpLake Philosophy**


## 🏗️ 아키텍처 개요

```plaintext
📦 외부 데이터 소스 (API / 웹 / CSV)
    ↓
🐍 Python 데이터 수집 및 정제 (python, pandas)
    ↓
💾 Azure Databricks 저장소 (Postgresql, Delta Table)
    ↓
🧠 데이터 분석 (PySpark / SQL)
    ↓
📊 Databricks & Power BI 대시보드 연결 및 시각화
```

## 🛠️ 기술 스택

| 구분           | 사용 기술                                       |
|----------------|------------------------------------------------|
| 데이터 수집     | Python, Postgresql    |
| 데이터 처리     | pandas, PySpark, Databricks SQL                |
| 저장 및 분산처리 | Azure Databricks, Delta Lake                   |
| 시각화         | Databricks& Power BI                                       |
| 버전관리       | Git + GitHub                                   |

## 📁 디렉토리 구조
``` bash
ShrimpLake-Project/
├── team5env/                 # 팀 개발 환경 구성 디렉토리
├── notebooks/                # Databricks 노트북
│   ├── transformation.ipynb
│   └── analysis.ipynb
├── sql/specification/table   # SQL 쿼리문 저장
│   ├── ERD               
│   ├── bronze            
│   ├── silver            
│   └── 기타
├── dashboard/                # 대시보드 파일
│   └── ShrimpLake_dashboard.pbix
├── docs/                     # 프로젝트 문서
│   └── architecture.png
└── README.md
```

## 👥 팀원 및 역할 분담

| 이름 | 역할            | 담당 업무                                  |
|------|-----------------|---------------------------------------------|
| 김진혁    | PM  | 일정 관리, 문서화, 프로젝트 관리                  |
| 김진우    | Data Engineer   | 데이터 프로세스 개발            |
| 서창범    | Data Engineer         | 데이터 프로세스 개발                |
| 정민철    | Data Engineer    | 데이터 프로세스 개발                      |
| 이재훈    | Data Engineer         | 데이터 프로세스 개발                |

> 역할은 유동적으로 조정될 수 있으며, 전원 데이터 분석 전반을 경험합니다.


## 📈 결과물 요약

- 교통사고 통계 데이터 수집
- 메달리온 아키텍처 기반 스키마 및 테이블 설계 및 구축
- Delta Lake 기반 골드 테이블 구조화 저장
- Databricks, pyspark를 활용한 분산 처리
- Databricks&Power BI 대시보드 완성
