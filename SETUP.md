# ⚙️ ShrimpLake 개발 환경 세팅 가이드

본 문서는 ShrimpLake 프로젝트에 참여하기 위한 로컬 및 클라우드 개발 환경을 설정하는 방법을 안내합니다.



## 💡 필수 요구 사항

| 항목 | 버전 |
|------|------|
| Python | 3.9 이상 |
| pip | 최신 버전 권장 |
| Power BI | Desktop 버전 |
| Azure Databricks | Workspace 접근 권한 필요 |



## 🐍 Python 개발 환경

1. 가상환경 생성

```bash
python -m venv venv
source venv/bin/activate # Windows: venv\Scripts\activate
```

2. 가상환경 생성

```bash
pip install -r requirements.txt
```
3. 환경 변수 파일 설정

```bash
cp .env.example .env
# 또는 직접 생성
touch .env
```

## 📊 Power BI

1. [Power BI Desktop 설치](https://powerbi.microsoft.com/ko-kr/desktop/)
2. `dashboards/` 폴더 내 `.pbix` 파일을 열어 확인  
   - Gold Delta Table 경로 연결 필요 (예: Databricks SQL Endpoint)


## 🖥️ Azure Databricks

1. [Databricks 포털](https://community.cloud.databricks.com/) 접속 후 워크스페이스 선택
2. 프로젝트 노트북/코드 업로드
3. 클러스터 생성 및 연결 (Runtime: 10.x 이상, DBR/PySpark 지원)
4. Delta 테이블 작성 예시:

```python
from pyspark.sql import SparkSession

df = spark.read.json("dbfs:/mnt/bronze/earthquake_raw/")
df.write.format("delta").mode("overwrite").save("dbfs:/mnt/silver/earthquake_cleaned/")
``` 


## 📂 폴더 구조 요약
```plaintext
ShrimpLake/
├── data_fishing/
├── data_processing/
├── databricks_jobs/
├── dashboards/
├── docs/
├── .env.example
├── requirements.txt
└── ...
```


## 📞 문의 및 지원
- 환경 구성 중 문제가 발생하면 `GitHub Issues` 또는 `Discussions`에 남겨주세요.
- 클러스터 권한/스토리지 마운트 관련 이슈는 PM에게 요청 바랍니다.