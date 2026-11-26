# Erdős #1196 blind control, toy check of the prefix-chain kernel (README item 3).
# For the chain that multiplies by primes in nondecreasing order, the target hitting probability
# h(n) = 1/(n log n) needs transition probabilities q(m,p) = h(mp)/h(m) = log m / (p log(mp)), p >= P(m).
# The chain is sub-stochastic at m iff S(m) = sum_{p >= P(m)} q(m,p) <= 1.
# Prediction: S(m) ~ log(1 + log m / log P(m)), which is <= 1 iff log P(m)/log m >= 1/(e-1) ≈ 0.582.
import math
from sympy import primerange
PR = list(primerange(2, 10**7))
def S(m, P):
    L = math.log(m); s = 0.0
    for p in PR:
        if p < P: continue
        s += L / (p * (L + math.log(p)))
    # tail p > 10^7 by the integral ∫ du/(u(1+u/L)) from log 1e7 (Mertens density 1/(p log p) dp)
    u0 = math.log(PR[-1]); s += math.log(1 + L / u0)
    return s
for (m, P) in [(2*3*5*7*11*13, 13), (101*103, 103), (2**20*1000003, 1000003), (2**40, 2), (999983**2, 999983), (6, 3)]:
    L = math.log(m); v = math.log(P) / L
    print(f"m={m} P(m)={P} logP/logm={v:.3f} S={S(m,P):.3f} predicted={math.log(1+1/v):.3f}")
