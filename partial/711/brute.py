"""Brute-force check of count.py on small configs: enumerate paths, collect distinct images,
and enumerate the possible-image sets directly."""
import numpy as np, subprocess, itertools, sys
from count import counts
def brute(P, B, K):
    S = {p: [b + j*p for j in range(K)] for p, b in zip(P, B)}
    U = sorted(set(x for l in S.values() for x in l)); Us = set(U)
    on = {}
    for p, l in S.items():
        for j, x in enumerate(l): on.setdefault(x, []).append((p, j))
    idx = {(p, x): j for p, l in S.items() for j, x in enumerate(l)}
    im3 = set(); p3 = 0; im5 = set(); p5 = 0
    for d1, l in S.items():
        for i1, u1 in enumerate(l):
            for i2, u2 in enumerate(l):
                if i1 == i2 or (i1 - i2) % 2: continue
                for d0, _ in on[u1]:
                    if d0 == d1: continue
                    p3 += 1; im3.add((d0, (u1+u2)//2, u2))
                    for d2, j2 in on[u2]:
                        if d2 == d1: continue
                        for jw, w in enumerate(S[d2]):
                            if jw == j2 or (jw - j2) % 2: continue
                            p5 += 1; im5.add((d0, (u1+u2)//2, (u2+w)//2, w))
    G3 = sum(1 for d in P for x in U for w in U if 2*x - w in set(S[d]))
    Sset = {d: set(S[d]) for d in P}
    G5 = G5u = 0
    for x2 in U:
        for w in U:
            u2 = 2*x2 - w
            for x1 in U:
                t = 2*x1 - u2
                k = sum(1 for d in P if t in Sset[d]); G5 += k
                if u2 in Us: G5u += k
    return dict(P3=p3, im3=len(im3), P5=p5, im5=len(im5), G3=G3, G5=G5, G5u=G5u)
for v, K, seed in [(300, 3, 1), (500, 4, 2), (700, 3, 3)]:
    out = subprocess.run(['./search', str(v), str(v//4), str(K), '10', str(seed), 'r'], capture_output=True, text=True).stdout
    a = np.array([list(map(int, l.split())) for l in out.strip().split('\n')[1:]])
    fast = counts(a[:, 0], a[:, 1], K); br = brute(list(a[:, 0]), list(a[:, 1]), K)
    print(v, K, {k: fast[k] for k in ['N','U','P3','P5','G3','G5','G5u']}, br)
    assert all(fast[k] == br[k] for k in ['P3','P5','G3','G5','G5u']) and br['im3'] == br['P3'] and br['im5'] == br['P5']
print("brute-force check passed")
