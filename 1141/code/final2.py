exec(open('lemA2.py').read().split("a=mpf(5)*10**11")[0])
import functools
X_small=functools.lru_cache(None)(X_small)
edges=[mpf('1.1649')*10**12]
while edges[-1]<mpf(10)**13: edges.append(edges[-1]*mpf('1.01'))
e=mpf(13)
while e<20: e+=mpf('0.1'); edges.append(mpf(10)**e)
while e<100: e+=mpf('0.5'); edges.append(mpf(10)**e)
while e<20050: e+=(5 if e<2000 else 50); edges.append(mpf(10)**e)
bad=0; tight=None
for a,b in zip(edges,edges[1:]):
    X,w,lb=check2(a,b)
    if lb<2: bad+=1; print("FAIL at 10^%.2f"%float(log(a)/log(10)))
    if tight is None or lb<tight[0]: tight=(lb,a)
print("intervals:",len(edges)-1,"failures:",bad,"tightest margin",float(tight[0]),"at",float(tight[1]))
