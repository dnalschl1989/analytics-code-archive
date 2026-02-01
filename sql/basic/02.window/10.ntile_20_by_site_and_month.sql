/*
Title: NTILE(20) Ranking by Month and Site
Category: SQL Basic / Window
Purpose:
  - (P_YYYYMM, SITE_NM) 그룹 내에서 ASMP_VSIT_TM을 내림차순 정렬 후
    전체를 20등분(quantile)으로 구간화하여 등급 부여

Definition:
  - TM_20 = 1  : 상위(ASMP_VSIT_TM 큼)
  - TM_20 = 20 : 하위(ASMP_VSIT_TM 작음)

Use Case:
  - 사이트별 방문시간 상/중/하 등급화
  - 월별 구간화(스코어링)로 피벗/세그먼트 분석

Dialect:
  - BigQuery

Notes:
  - NTILE은 "행 개수" 기준으로 균등 분할 (값 분포가 균등해지는 것은 아님)
  - NULL 처리 정책을 명확히 해야 함 (NULL을 제외할지, 최하위로 보낼지)
*/

-- Example (template)
-- Replace `your_table` and columns as needed
SELECT
  T.*,
  NTILE(20) OVER (
    PARTITION BY T.P_YYYYMM, T.SITE_NM
    ORDER BY T.ASMP_VSIT_TM DESC
  ) AS tm_20
FROM `your_project.your_dataset.your_table` AS T;

-- NULL handling example: push NULL to the bottom
-- ORDER BY IFNULL(T.ASMP_VSIT_TM, -1) DESC
