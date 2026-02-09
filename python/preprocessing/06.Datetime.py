# 100년 빼서 재정의
import pandas as pd

def fix_century(x):
    import datetime
    year = x.year - 100 if x.year >= 2061 else x.year
    return pd.to_datetime(datetime.date(year, x.month, x.day))

df["Yr_Mo_Dy"] = df["Yr_Mo_Dy"].apply(fix_century)
Ans = df.head(4)

# 기준 주말(1) / 평일(0)
df["WeekCheck"] = df["weekday"].map(lambda x: 1 if x in [5, 6] else 0)

# 1차 차분
Ans = df["RPT"].diff()

# RPT/VAL 7일 이동평균
Ans = df[["RPT", "VAL"]].rolling(7).mean()

# '년-월-일:시' → datetime (24시 처리)
import pandas as pd

def change_date(x):
    import datetime
    hour = x.split(":")[1]
    date = x.split(":")[0]

    if hour == "24":
        hour = "00:00:00"
        FinalDate = pd.to_datetime(date + " " + hour) + datetime.timedelta(days=1)
    else:
        hour = hour + ":00:00"
        FinalDate = pd.to_datetime(date + " " + hour)

    return FinalDate

df["(년-월-일:시)"] = df["(년-월-일:시)"].apply(change_date)
Ans = df

# 영어요일명 dayName 컬럼
df["dayName"] = df["(년-월-일:시)"].dt.day_name()

# 시간 연속성 체크 (차분 값이 동일한지)
check = len(df["(년-월-일:시)"].diff().unique())
Ans = True if check == 2 else False

# 10시와 22시의 PM10 평균
Ans = df.groupby(df["(년-월-일:시)"].dt.hour).mean().iloc[[10, 22], [0]]

# 날짜 컬럼을 index로
df.set_index("(년-월-일:시)", inplace=True, drop=True)

