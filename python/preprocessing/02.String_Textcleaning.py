#item_price에서 '$' 제거 후 float 변환 → new_price
df["new_price"] = df["item_price"].str[1:].astype(float)

#통화 기호가 항상 첫 글자가 아닐 수 있으면 replace가 더 안전
df["new_price"] = df["item_price"].str.replace("$", "", regex=False).astype(float)

#~으로 시작하는, 끝나는, ~ 이 포함된
df.loc[df["item_name"].str.startswith("N")] # endswith / contains도 동일 패턴

#문자 제거
df["col"] = df["col"].str.replace("*", "", regex=True)
