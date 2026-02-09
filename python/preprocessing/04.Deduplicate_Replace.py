# Steak Salad 또는 Bowl만 추출 후 item_name 중복 제거(마지막만)
tmp = df.loc[(df["item_name"] == "Steak Salad") | (df["item_name"] == "Bowl")]
Ans = tmp.drop_duplicates("item_name", keep="last")

# 치환
df.loc[df["item_name"] == "Izze", "item_name"] = "Fizzy Lizzy"
Ans = df

# 결측치를 'NoData'로 대체
df.loc[df["choice_description"].isnull(), "choice_description"] = "NoData"
Ans = df

# 결측치: 직전값(ffill) → 첫행 결측은 뒤값(bfill)
df = df.fillna(method="ffill").fillna(method="bfill")
