# Erdős #366, fixed shapes. Every 2-full n is a^2 b^3 (b squarefree) and every 3-full m is
# K c^3 with K = d^4 e^5 (d, e squarefree, coprime). For a fixed shape (b, K):
#   a^2 b^3 + 1 = K c^3   <=>   Y^2 = X^3 - K^2 b^3   with X = K b c, Y = K b^3 a.
# So every solution of shape (b, K), of ANY size, is an integral point on one Mordell curve.
# Sage's integral_points (rigorous, via Mordell-Weil basis + Baker bounds) lists them all.
# Validation: the reverse problem K c^3 + 1 = a^2 b^3 gives Y^2 = X^3 + K^2 b^3 and must
# recover (8, 9) and (12167, 12168).
import sys, signal
from sage.all__sagemath_schemes import EllipticCurve, Integer
from math import gcd
def sqfree(n):
    p=2
    while p*p<=n:
        if n%(p*p)==0: return False
        p+=1
    return True
def solve(b,K,sign,tlim=600):
    k=K*K*b**3
    E=EllipticCurve([0, sign*k])     # Y^2 = X^3 + sign*k
    class TO(Exception): pass
    def h(*a): raise TO()
    signal.signal(signal.SIGALRM,h); signal.alarm(tlim)
    try:
        pts=E.integral_points(both_signs=False)
        signal.alarm(0)
    except TO: return None
    except Exception as ex:
        signal.alarm(0); return ('ERR',str(ex)[:80])
    sols=[]
    for P in pts:
        X,Y=Integer(P[0]),Integer(abs(P[1]))
        if X%(K*b) or Y%(K*b**3): continue
        c=X//(K*b); a=Y//(K*b**3)
        if c<=0 or a<=0: continue
        n=a*a*b**3 if sign<0 else K*c**3
        sols.append(int(n))
    return sols
if __name__=="__main__":
    B=int(sys.argv[1]); Ks=[int(x) for x in sys.argv[2].split(',')]; sign=int(sys.argv[3]); part=int(sys.argv[4]); nparts=int(sys.argv[5])
    jobs=[(b,K) for K in Ks for b in range(1,B+1) if sqfree(b)]
    for i,(b,K) in enumerate(jobs):
        if i%nparts!=part: continue
        r=solve(b,K,sign)
        print(f"b={b} K={K} sign={sign} -> {r}",flush=True)
