# Validates the necessary condition of README item 2' by brute force: every n <= N passing
# tau(n-k) <= k+2 for k = 1..8 (a consequence of being a solution) and n > 72 must have
# n = 8w+8 with w,2w+1,4w+3,8w+7 prime, or n = 16w+8 with w,4w+1,8w+3,16w+7 prime.
# Also lists all true solutions n <= N by the full condition (exact tau sieve).
import numpy as np, sys
from sympy import isprime
N = int(float(sys.argv[1])) if len(sys.argv) > 1 else 10**7
tau = np.zeros(N + 1, dtype=np.int32)
for d in range(1, N + 1):
    tau[d::d] += 1
ok8 = np.ones(N + 1, dtype=bool); ok8[:10] = False
for k in (1, 2, 4, 8):   # exactly the k used in the proof
    ok8[k + 1:] &= tau[1:N + 1 - k] <= k + 2
bad = []
for n in np.nonzero(ok8)[0]:
    n = int(n)
    if n <= 72: continue
    w = (n - 8) // 8; v = (n - 8) // 16
    b1 = (n - 8) % 8 == 0 and all(isprime(x) for x in (w, 2*w+1, 4*w+3, 8*w+7))
    b2 = (n - 8) % 16 == 0 and all(isprime(x) for x in (v, 4*v+1, 8*v+3, 16*v+7))
    if not (b1 or b2): bad.append(n)
print(f"N={N}: n in (72,N] passing k in {1,2,4,8} filter: {int(ok8[73:].sum())}; not of chain form: {bad[:20]} (count {len(bad)})")
# full condition: running max of m + tau(m)
R = np.maximum.accumulate(np.arange(N + 1) + tau)
sol = [n for n in range(2, N + 1) if R[n - 1] <= n + 2]
print("solutions n <=", N, ":", sol)
