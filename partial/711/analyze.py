"""For each (v,K): take the min-|U| searched config (near-extremal) and the sweeps=0 random config;
compute counts, then fit scalings in N."""
import glob, json, re, numpy as np
from collections import defaultdict
from count import counts, load
best = {}; rand = {}
for f in glob.glob('cfg/*.txt'):
    v, K, sw = map(int, re.findall(r'v(\d+)_K(\d+)_sw(\d+)', f)[0])
    N, U = map(int, open(f).readline().split())
    if sw == 0: rand[(v, K)] = f
    elif (v, K) not in best or U < best[(v, K)][0]: best[(v, K)] = (U, f)
rows = []
for (v, K), (U, f) in sorted(best.items()):
    P, B = load(f); r = counts(P, B, K); r.update(v=v, kind='best', src=f.split('/')[1]); rows.append(r)
    P, B = load(rand[(v, K)]); r = counts(P, B, K); r.update(v=v, kind='random', src=''); rows.append(r)
json.dump(rows, open('results.json', 'w'), indent=0)
def fit(N, Q):
    x, y = np.log(N), np.log(Q)
    A = np.vstack([x, np.ones_like(x)]).T; (a, c), res = np.linalg.lstsq(A, y, rcond=None)[:2]
    rms_pow = np.sqrt(np.mean((A @ [a, c] - y) ** 2))
    out = {'pow_a': a, 'rms_pow': rms_pow}
    for e in (1, 2, 3):   # fixed exponent e with log-power correction: Q = C N^e (log N)^b
        A2 = np.vstack([np.log(x), np.ones_like(x)]).T; z = y - e * x
        (b, c2) = np.linalg.lstsq(A2, z, rcond=None)[0]
        out[f'N^{e}_logb'] = b; out[f'rms_N^{e}'] = np.sqrt(np.mean((A2 @ [b, c2] - z) ** 2))
    # local slopes between consecutive sizes
    out['local'] = list(np.round(np.diff(y) / np.diff(x), 2))
    return out
for kind in ('best', 'random'):
    for K in (3, 4, 6):
        R = [r for r in rows if r['kind'] == kind and r['K'] == K and r['N'] >= 30]
        print(f"\n== {kind} K={K} ==")
        print(" v      N     U   U/N  maxdeg        P3          P5            G3              G5             G5u    P5/N^2")
        for r in R:
            print(f"{r['v']:6d} {r['N']:5d} {r['U']:5d} {r['U']/r['N']:5.2f} {r['maxdeg']:4d} {r['P3']:10d} {r['P5']:12d} {r['G3']:12d} {r['G5']:16d} {r['G5u']:14d} {r['P5']/r['N']**2:8.4f}")
        N = np.array([r['N'] for r in R], float)
        for q in ('P3', 'P5', 'G3', 'G5', 'G5u'):
            Q = np.array([r[q] for r in R], float)
            if (Q <= 0).any(): print(q, 'has zeros'); continue
            o = fit(N, Q)
            print(f"  {q:4s} power a={o['pow_a']:.3f} (rms {o['rms_pow']:.3f}) | N^2(logN)^b b={o['N^2_logb']:.2f} rms {o['rms_N^2']:.3f} | N^3(logN)^b b={o['N^3_logb']:.2f} rms {o['rms_N^3']:.3f} | local {o['local']}")
