# Retry curves where mwrank could not certify a Mordell-Weil basis: get rank bounds and points from
# PARI's ellrank (2-descent with more effort); accept only if the bounds meet (r1 == r2), then
# saturate in Sage and pass the basis to integral_points.
import re,sys
from sage.all__sagemath_schemes import EllipticCurve, Integer, QQ
import cypari2; pari=cypari2.Pari(); pari.allocatemem(2*10**9)
from shapes import sqfree
def run(b,K,sign=-1):
    k=K*K*b**3; E=EllipticCurve([0,sign*k])
    for effort in (2,5,10):
        r=pari.ellrank(pari.ellinit([0,0,0,0,sign*k]),effort)
        r1,r2=int(r[0]),int(r[1])
        if r1==r2: break
    if r1!=r2: return f"UNRESOLVED rank in [{r1},{r2}]"
    pts=[E([QQ(str(t)) for t in P]) for P in r[3]]
    if len(pts)!=r1: return f"UNRESOLVED points {len(pts)} vs rank {r1}"
    if r1: pts,_,_=E.saturation(pts)
    ip=E.integral_points(mw_base=pts,both_signs=False)
    sols=[]
    for P in ip:
        X,Y=Integer(P[0]),Integer(abs(P[1]))
        if X%(K*b) or Y%(K*b**3): continue
        c=X//(K*b); a=Y//(K*b**3)
        if c>0 and a>0: sols.append(int(a*a*b**3))
    return f"rank {r1} -> {sols}"
for line in open(sys.argv[1]):
    m=re.match(r"b=(\d+) K=(\d+) sign=-1 -> \('ERR'",line)
    if m:
        b,K=int(m.group(1)),int(m.group(2))
        print(f"b={b} K={K} retry: {run(b,K)}",flush=True)
