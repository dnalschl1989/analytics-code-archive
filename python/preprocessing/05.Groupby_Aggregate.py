# group별 neighbourhood 개수
Ans = df.groupby(["neighbourhood_group", "neighbourhood"], as_index=False).size()

# group별 neighbourhood 개수의 최댓값
Ans = (
    df.groupby(["neighbourhood_group", "neighbourhood"], as_index=False)
      .size()
      .groupby(["neighbourhood_group"], as_index=False)
      .max()
)

# neighbourhood별 price 통계(평균/분산/최대/최소)
Ans = (
    df[df["neighbourhood_group"] == "Queens"]
      .groupby("neighbourhood")
      .price
      .agg(["mean", "var", "max", "min"])
)
