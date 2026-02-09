#quantity == 3인 데이터의 첫 5행
Ans = df.loc[df["quantity"] == 3].head(5)

#item_name에 'Chips' 포함하는 행
Ans = df.loc[df["item_name"].str.contains("Chips")]

#item_name에 'Chips' 포함하지 않는 행
df.loc[~df["item_name"].str.contains("Chips")]
