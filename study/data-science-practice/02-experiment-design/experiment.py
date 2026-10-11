"""실습 02 — 적정 모수, Power, MDE, ITT, 층화무작위.

설치: pip install -r requirements.txt
실행: python experiment.py
자료는 학습을 위한 가상 데이터입니다.
"""
import math

import numpy as np
import pandas as pd
from scipy.optimize import brentq
from statsmodels.stats.power import NormalIndPower
from statsmodels.stats.proportion import proportion_effectsize, proportions_ztest

# STEP 1: 실험 '전'에 우리가 검출하고 싶은 차이를 정의합니다.
p_control = 0.04      # Control 고객의 예상 해지율 (4.0%)
p_treatment = 0.035  # Treatment의 목표 해지율 (3.5%)
alpha = 0.05          # 실제 효과가 없어도 잘못 유의하다고 말할 확률의 기준
power_target = 0.80   # 목표 효과가 진짜 존재할 때 그 효과를 찾아낼 확률
group_size = 15_000   # 실제 실험에서 한 집단에 배정 가능한 고객 수

# proportion_effectsize는 비율 차이를 검정에 사용하는 표준화 효과크기로 바꿉니다.
effect_size = proportion_effectsize(p_control, p_treatment)

# NormalIndPower(): 표본수·검정력 계산에 사용하는 객체(계산기)를 생성합니다.
calculator = NormalIndPower()

# STEP 2: 목표 효과를 찾기 위해 '그룹당' 필요한 표본수를 계산합니다.
required_n = calculator.solve_power(
    effect_size=effect_size,  # 검출하고 싶은 효과 크기
    power=power_target,       # 검정력 목표 80%
    alpha=alpha,              # 양측 5% 유의수준
    ratio=1.0,                # 두 그룹에 같은 인원을 배정
    alternative="two-sided"  # 증가·감소 두 방향 검정
)
print("[실험 전 설계]")
print(f"표준화 효과크기: {effect_size:.8f}")
print(f"필요 모수: {math.ceil(required_n):,}명/그룹, 총 {2 * math.ceil(required_n):,}명")

# STEP 3: 이미 각 15,000명밖에 없다면, 효과를 탐지할 검정력은?
current_power = calculator.power(
    effect_size=effect_size,
    nobs1=group_size,  # 첫 집단의 고객 수; ratio=1로 다른 집단도 같음
    alpha=alpha,
    ratio=1.0,
    alternative="two-sided"
)
print(f"15,000명/그룹의 Power: {current_power:.2%}")

# STEP 4: 현재 표본에서 80% Power를 확보하는 목표 해지율(MDE) 역산
# brentq는 함수 결과가 0이 되는 입력값을 구간 내에서 찾아줍니다.
def difference_from_target_power(treatment_rate):
    h = proportion_effectsize(p_control, treatment_rate)
    calculated_power = calculator.power(
        effect_size=h,
        nobs1=group_size,
        alpha=alpha,
        ratio=1.0,
        alternative="two-sided"
    )
    return calculated_power - power_target

mde_treatment_rate = brentq(
    difference_from_target_power,  # 이 함수의 값이 0이 되는 해지율 탐색
    0.01,                          # 탐색구간 하한: 1%
    p_control - 1e-8               # 탐색구간 상한: 4% 미만
)
mde_pp = (p_control - mde_treatment_rate) * 100
print(f"MDE 대응 Treatment 해지율: {mde_treatment_rate:.3%}")
print(f"MDE (절대 해지율 감소폭): {mde_pp:.3f}%p")

# STEP 5: 실험 '후', 배정된 모든 고객을 사용하여 ITT 검정
# count에는 해지 수를, nobs에는 메시지를 읽었는지와 상관없이 배정 인원을 넣습니다.
count = [600, 540]        # Control, Treatment 해지 건수
nobs = [15_000, 15_000]   # Control, Treatment 최초 배정 인원
z_stat, p_value = proportions_ztest(count=count, nobs=nobs, alternative="two-sided")
observed_control = count[0] / nobs[0]
observed_treatment = count[1] / nobs[1]
observed_diff = observed_treatment - observed_control

# 두 비율 차이의 비풀링 정규근사 신뢰구간 (Treatment - Control)
se = math.sqrt(
    observed_control * (1 - observed_control) / nobs[0]
    + observed_treatment * (1 - observed_treatment) / nobs[1]
)
ci_low = observed_diff - 1.96 * se
ci_high = observed_diff + 1.96 * se
print("\n[실험 후 검정]")
print(f"ITT 차이: {observed_diff * 100:.3f}%p")
print(f"z 통계량: {z_stat:.4f}; 양측 p-value: {p_value:.4f}")
print(f"95% 근사 신뢰구간: [{ci_low*100:.3f}, {ci_high*100:.3f}]%p")
print("5% 유의수준 판정:", "유의" if p_value < alpha else "통계적으로 유의하지 않음")

# STEP 6: 각 가입기간 그룹 안에서 무작위로 50:50 배정합니다.
df = pd.DataFrame({
    "customer_id": np.arange(1, 30_001),
    "tenure_group": ["1-2y"] * 15_000 + ["3-5y"] * 9_000 + ["6y+"] * 6_000,
})
df["assignment"] = "control"
rng = np.random.default_rng(42)  # 동일한 예제를 재실행할 때 재현할 수 있게 시드 지정
for _, indices in df.groupby("tenure_group").groups.items():
    shuffled = rng.permutation(np.asarray(list(indices)))
    df.loc[shuffled[:len(shuffled) // 2], "assignment"] = "treatment"

print("\n[층화무작위 배정]")
print(pd.crosstab(df["tenure_group"], df["assignment"]))
