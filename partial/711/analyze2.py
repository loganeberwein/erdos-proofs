"""Normalised ratios against the 'generic coincidence' heuristics, and G5p, for best configs."""
import json, numpy as np
from count import load
from count_p import G5p
rows = json.load(open('results.json'))
for r in rows:
    if r['kind'] == 'best' and r['N'] >= 30:
        P, B = load('cfg/' + r['src']); r['G5p'] = G5p(P, B, r['K'])
    v = r['v']
    r['G5_gen'] = r['G5'] / (r['N'] * r['U']**3 / v)        # heuristic N|U|^3/v
    r['G3_gen'] = r['G3'] / (r['N'] * r['U']**2 / v + r['N'] * r['K']**2)
json.dump(rows, open('results.json', 'w'), indent=0)
def fit(N, Q):
    x, y = np.log(N), np.log(Q); a, c = np.polyfit(x, y, 1); rp = np.sqrt(np.mean((np.polyval([a, c], x) - y)**2))
    o = [f"power a={a:.2f} rms {rp:.3f}"]
    for e in (2, 3):
        b, c2 = np.polyfit(np.log(x), y - e*x, 1); o.append(f"N^{e}(logN)^{b:.2f} rms {np.sqrt(np.mean((np.polyval([b,c2],np.log(x))-(y-e*x))**2)):.3f}")
    return ' | '.join(o)
for K in (3, 4, 6):
    R = [r for r in rows if r['kind'] == 'best' and r['K'] == K and r['N'] >= 30]
    print(f"\n== best K={K} ==\n  N    U/N  G5/N^2  G5/(N U^3/v)  G3/(N U^2/v+NK^2)      G5p     G5p/N^2   P5/N^2")
    for r in R: print(f"{r['N']:5d} {r['U']/r['N']:5.2f} {r['G5']/r['N']**2:7.1f} {r['G5_gen']:10.2f} {r['G3_gen']:14.2f} {r['G5p']:12d} {r['G5p']/r['N']**2:9.3f} {r['P5']/r['N']**2:8.4f}")
    N = np.array([r['N'] for r in R], float)
    print("  G5 :", fit(N, np.array([r['G5'] for r in R], float)))
    print("  G5/N^2 vs log N slope (if G5=N^2 (logN)^b):", round(np.polyfit(np.log(np.log(N)), np.log([r['G5']/r['N']**2 for r in R]),1)[0],2))
    print("  P5 :", fit(N, np.array([r['P5'] for r in R], float)))
    print("  G5p:", fit(N, np.array([r['G5p'] for r in R], float)))
