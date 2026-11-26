# Independent check of wit317.c: exact lcm, direct residues. For forbidden band T (T = 1 is the real
# condition L/p ≡ ±1 mod p), list every n in [5, N] for which EVERY prime p in (n/2, n] has L/p mod p in
# [1,T] ∪ [p−T, p−1]. wit317 must report exactly these n as SURVIVORs.
import sys
from sympy import primerange
from math import lcm
N, T = int(sys.argv[1]), int(sys.argv[2])
L = 1; surv = []
for n in range(1, N + 1):
    L = lcm(L, n)
    if n < 5: continue
    ps = list(primerange(n // 2 + 1, n + 1))
    if all((L // p) % p <= T or (L // p) % p >= p - T for p in ps):
        surv.append(n)
print(f"N={N} T={T} survivors={surv}")
