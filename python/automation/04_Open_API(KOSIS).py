import requests
import pandas as pd

# KOSIS Open API 인증키
API_KEY = "OThiMWRlYjIyNDg0YTZmMjVlYmQ0ZjZkMDRmZDgyMzQ="

# KOSIS 통계 데이터 조회 URL
URL = "https://kosis.kr/openapi/Param/statisticsParameterData.do"

# 조회할 기준월
# key   : API에 넣을 값
# value : 최종 표에 표시할 컬럼명
TARGET_MONTHS = {
    "202312": "2023-12",
    "202412": "2024-12",
    "202512": "2025-12",
    "202603": "2026-03"
}

# 조회할 항목 코드
# 반드시 실제로 총인구 항목인지 확인 필요
ITEM_CODE = "T2"


def call_kosis(prd_de):
    """
    특정 기준월(prd_de)에 대해 KOSIS API를 호출하고
    결과를 DataFrame으로 반환하는 함수
    """

    # API 요청 파라미터 구성
    params = {
        "method": "getList",     # 데이터 목록 조회
        "apiKey": API_KEY,       # 인증키
        "itmId": ITEM_CODE,      # 항목 코드
        "objL1": "00",           # 전국
        "objL2": "ALL",          # 연령 전체
        "format": "json",        # JSON 형식으로 반환
        "jsonVD": "Y",           # JSON 응답 옵션
        "prdSe": "M",            # 월 단위 데이터
        "startPrdDe": prd_de,    # 시작월
        "endPrdDe": prd_de,      # 종료월 = 시작월 (한 달만 조회)
        "orgId": "101",          # 기관 코드
        "tblId": "DT_1B04005N"   # 통계표 ID
    }

    # GET 방식으로 API 호출
    resp = requests.get(URL, params=params, timeout=30)

    # HTTP 오류가 있으면 예외 발생
    resp.raise_for_status()

    # JSON 응답을 파이썬 객체로 변환
    data = resp.json()

    # KOSIS 자체 에러 메시지 처리
    if isinstance(data, dict) and "err" in data:
        raise ValueError(
            f"KOSIS API 오류 - err: {data['err']}, errMsg: {data.get('errMsg')}"
        )

    # 정상 응답은 list 형태여야 함
    if not isinstance(data, list):
        raise ValueError(
            f"예상하지 못한 응답 형식: {type(data)} / 내용: {data}"
        )

    # 리스트를 DataFrame으로 변환해서 반환
    return pd.DataFrame(data)


def pick_first_existing(columns, candidates):
    """
    컬럼 후보 목록(candidates) 중에서
    실제 columns에 존재하는 첫 번째 컬럼명을 반환
    """
    for c in candidates:
        if c in columns:
            return c
    return None


# 월별 API 결과를 담을 리스트
dfs = []

# 각 기준월에 대해 반복 조회
for prd_de in TARGET_MONTHS.keys():
    df_part = call_kosis(prd_de)
    dfs.append(df_part)

# 월별 결과를 하나의 DataFrame으로 합치기
df = pd.concat(dfs, ignore_index=True)

# 실제 응답 컬럼명은 다를 수 있으므로 자동 탐색
col_prd = pick_first_existing(df.columns, ["PRD_DE", "prdDe"])
col_value = pick_first_existing(df.columns, ["DT", "dt"])
col_age = pick_first_existing(df.columns, ["C2_NM", "c2_nm", "OBJ_L2_NM", "objL2Nm"])

# 필요한 컬럼만 추출
result = df[[col_prd, col_age, col_value]].copy()

# 컬럼명을 이해하기 쉬운 이름으로 변경
result.columns = ["기준월", "나이", "인구수"]

# 기준월 형식 정리
# 예: 2023.12 -> 202312 / 2023-12 -> 202312
result["기준월"] = (
    result["기준월"]
    .astype(str)
    .str.replace(".", "", regex=False)
    .str.replace("-", "", regex=False)
)

# 우리가 원하는 4개 기준월만 남기기
result = result[result["기준월"].isin(TARGET_MONTHS.keys())].copy()

# 보기 좋은 기준시점 컬럼 생성
# 예: 202312 -> 2023-12
result["기준시점"] = result["기준월"].map(TARGET_MONTHS)

# 인구수 문자열을 숫자로 변환
# 예: "1,234,567" -> 1234567
result["인구수"] = pd.to_numeric(
    result["인구수"].astype(str).str.replace(",", "", regex=False),
    errors="coerce"
)

# 중복 확인: 같은 기준월-나이 조합이 여러 건인지 체크
dup_check = result.groupby(["기준월", "나이"]).size().reset_index(name="건수")
dup_rows = dup_check[dup_check["건수"] > 1]

if not dup_rows.empty:
    print("중복 조합 발견:")
    print(dup_rows.head(20))

    # 완전히 같은 중복 행 제거
    result = result.drop_duplicates(subset=["기준월", "나이", "인구수"]).copy()

    # 중복 제거 후 다시 검사
    dup_check2 = result.groupby(["기준월", "나이"]).size().reset_index(name="건수")
    dup_rows2 = dup_check2[dup_check2["건수"] > 1]

    # 여전히 중복이면 다른 숨은 차원이 있다는 뜻
    if not dup_rows2.empty:
        raise ValueError(
            "중복이 여전히 남아 있습니다. 원본 응답의 다른 차원 컬럼을 확인해야 합니다."
        )

# 피벗 테이블 생성
# 행: 나이
# 열: 기준시점
# 값: 인구수
pivot_df = result.pivot_table(
    index="나이",
    columns="기준시점",
    values="인구수",
    aggfunc="first"   # 중복 합산 방지
).reset_index()

# 컬럼 순서 고정
pivot_df = pivot_df[["나이", "2023-12", "2024-12", "2025-12", "2026-03"]]

# 결과 확인
print(pivot_df)

# 엑셀 파일로 저장
pivot_df.to_excel(r"C:\Users\minu1212\Downloads\kosis_national_age_pivot.xlsx", index=False)

print("저장 완료: kosis_national_age_pivot.xlsx")
