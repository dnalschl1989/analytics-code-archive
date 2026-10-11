# 데이터사이언스 실습 아카이브

실무 SQL·Python 사용자를 위한 20~30분 실습 자료입니다. 실습마다 **문제 → 힌트 → 모범 풀이 → 실무 적용 포인트** 순서를 유지합니다.

| 회차 | 주제 | 문서 | 실행 코드 |
|---|---|---|---|
| 01 | 윈도우 함수·시계열 데이터 정합성 | [학습 문서](01-window-functions/README.md) | [BigQuery SQL](01-window-functions/solution.sql) |
| 02 | 실험설계: MDE·Power·ITT·층화무작위 | [학습 문서](02-experiment-design/README.md) | [Python](02-experiment-design/experiment.py) |
| 03 | 데이터 모델링: Grain과 JOIN 중복 | [학습 문서](03-data-modeling/README.md) | [BigQuery SQL](03-data-modeling/solution.sql) |

## 실행 안내
- SQL은 Google BigQuery Standard SQL로 작성했으며, 스크립트 안에 가상의 테스트 데이터를 포함합니다.
- Python은 `pip install -r 02-experiment-design/requirements.txt` 후 `python 02-experiment-design/experiment.py`로 실행합니다.
- 모든 사례는 교육용 가상 고객·매출 데이터이며 실제 회사 내부 데이터는 포함하지 않습니다.

## 학습 팁
1. 문제만 먼저 읽고 5~10분 생각합니다.
2. 힌트를 확인하고 풀이를 직접 시도합니다.
3. 모범 풀이의 함수별 입력, 반환값, 전제조건을 확인합니다.
4. 실무 적용 포인트에서 실제 원천 데이터의 Grain, 누락, 인과관계, 사업적 해석을 점검합니다.

## 자료 출처와 보존 범위

- 기준 자료: 사용자가 첨부한 `data-science-practice.zip`. 기존 저장소의 다른 파일은 수정하지 않았습니다.
- ZIP의 8개 파일을 동일한 상대 구조로 가져왔고 SQL 2개, Python 코드 및 의존성 파일은 원본을 그대로 보존했습니다.
- 각 회차 문서의 **정리 과정에서 추가한 설명**은 새로 보강한 내용입니다. 원래 학습 과정의 문제·힌트·풀이·실무 적용 설명은 유지했습니다.
- 별도 실행 코드는 추가하지 않았습니다. 추가 설명과 검증 결과는 원본 풀이와 구분했습니다.

## 독립적인 Python 실행 환경

저장소 루트에서 다음 순서로 실행합니다. 가상환경은 저장소 밖에 만들어 기존 파일을 보호합니다.

```bash
python3 -m venv /tmp/data-science-practice-venv
/tmp/data-science-practice-venv/bin/python -m pip install -r study/data-science-practice/02-experiment-design/requirements.txt
/tmp/data-science-practice-venv/bin/python study/data-science-practice/02-experiment-design/experiment.py
```

원본 `requirements.txt`는 최소 버전만 지정하므로 잠금 파일처럼 동일한 버전을 보장하지는 않습니다. SQL은 BigQuery 편집기의 GoogleSQL(Standard SQL) 모드에서 각 파일 전체를 실행합니다. 내장 CTE 데이터만 사용하므로 별도 원천 테이블은 필요 없지만 BigQuery 실행에는 프로젝트와 권한이 필요합니다.

## 정리 과정에서 추가한 검증 기록

- 요청한 8개 파일 및 README의 문제 → 힌트 → 모범 풀이 → 실무 적용 포인트 순서를 확인했습니다.
- ZIP 대비 SQL·Python·requirements 파일은 바이트 단위로 동일하고, 원본 README의 모든 행은 원래 순서대로 보존했습니다.
- Python 3.12.14 / NumPy 2.5.4 / pandas 3.0.6 / SciPy 1.18.1 / statsmodels 0.15.0에서 원본 `experiment.py`가 정상 종료했습니다. 필요 표본수 22,639명/그룹, Power 62.57%, MDE 0.610%p, p-value 0.0700 및 층별 50:50 배정을 확인했습니다. 이 버전은 검증 환경 기록이며 원본 의존성 파일의 버전을 변경한 것은 아닙니다.
- SQLGlot 30.22.0으로 두 SQL의 BigQuery 문법을 파싱하고 DuckDB 1.5.6용으로 변환해 내장 가상 데이터 결과를 확인했습니다. 01은 A001만 선별되고 감소율은 0.56, 03의 단순 마진은 50,000원입니다.
- 위 SQL 검증은 로컬 변환 실행입니다. 실제 BigQuery 서비스에서 실행하거나 dry run한 것은 아니므로 운영 적용 전 BigQuery에서 원본 쿼리를 확인해야 합니다.
