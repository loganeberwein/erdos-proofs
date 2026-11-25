"""G5p on the random (unsearched) configurations, and G5p/(heuristic) on both kinds.
Heuristic for G5p with no structure: G5 * (|U|/H) * (N/v)^2   [u2 in U, two window-prime divisibility events]."""
import json, numpy as np
from count import load
from count_p import G5p
rows = json.load(open('results.json'))
src = {}
import glob, re
for f in glob.glob('cfg/*_sw0_*.txt'):
    v, K = map(int, re.findall(r'v(\d+)_K(\d+)', f)[0]); src[(v, K)] = f
for r in rows:
    if r['kind'] == 'random' and r['N'] >= 30 and 'G5p' not in r:
        P, B = load(src[(r['v'], r['K'])]); r['G5p'] = G5p(P, B, r['K'])
    if 'G5p' in r: r['G5p_heur'] = r['G5'] * (r['U'] / r['H']) * (r['N'] / r['v'])**2
json.dump(rows, open('results.json', 'w'), indent=0)
for kind in ('best', 'random'):
    for K in (3, 4, 6):
        R = [r for r in rows if r['kind'] == kind and r['K'] == K and r['N'] >= 30]
        N = np.array([r['N'] for r in R], float); Q = np.array([r['G5p'] for r in R], float)
        a = np.polyfit(np.log(N), np.log(Q), 1)[0]; loc = np.round(np.diff(np.log(Q)) / np.diff(np.log(N)), 2)
        print(f"{kind:6s} K={K}: G5p power a={a:.2f}; local {list(loc)}; G5p/heur = {[round(r['G5p']/r['G5p_heur'],2) for r in R]}")
