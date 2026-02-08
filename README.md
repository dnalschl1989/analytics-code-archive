# analytics-code-archive
SQL and Python code archive for analytics, CRM, and data operations

# 📦 Analytics Code Archive

이 저장소는 데이터 분석 및 CRM 마케팅 업무에서 사용해온  
**SQL · Python 코드들을 아카이브 형태로 정리한 개인 저장소**입니다.

완성된 프로젝트 결과물을 정리하는 목적이 아니라,  
실무에서 반복적으로 활용되는 **쿼리, 분석 로직, 전처리 코드**를  
업무 맥락 기준으로 분류·관리하는 것을 목표로 합니다.

---

## 🔍 What this repository is
- 프로젝트 결과 저장소 ❌
- 튜토리얼 / 예제 모음 ❌  
- **실무 기반 코드 아카이브 ⭕**

분석 업무 중 실제로 사용했던 코드를  
재사용 가능하도록 일반화해 정리합니다.

---

## 📁 Repository Structure

```text
sql/
 ├─ basic/        # SQL 기본 패턴 (JOIN, WINDOW, DATE 등)
 ├─ analytics/    # 분석용 쿼리 (churn, retention, funnel 등)
 └─ operations/   # 운영/정합성/지표 집계 쿼리

python/
 ├─ preprocessing/  # 데이터 전처리 (결측치, 타입 변환 등)
 ├─ analysis/       # 분석 및 모델링 코드
 └─ automation/     # API 호출, 배치, 반복 작업 자동화

snippets/           # 자주 사용하는 짧은 코드 조각

