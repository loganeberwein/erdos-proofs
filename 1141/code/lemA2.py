exec(open('final.py').read().split("edges=")[0])          # union_lb, full_lb, omega_max2, PR, mp tools
from mpmath import mpf, log, sqrt, floor
# Lippmann-McGown Prop 1, X0 = 2^11 (requires x > 2048); m0 rows -> C2 (max of the two parity tables at X0=2^11)
ROWS=[(10,1.541),(16,1.381),(32,1.217),(64,1.105),(128,1.026),(256,0.969),(512,0.927),(1024,0.896),(2048,0.874)]
C1=mpf('0.047')
def C2logf_max(fmax):
    best=0
    for i,(m0,c) in enumerate(ROWS):
        if m0>fmax: break
        top = ROWS[i+1][0] if i+1<len(ROWS) else fmax
        top=min(top,fmax)
        best=max(best, mpf(c)*log(top))
    return best
def lemmaA_X2(q,w):
    A=C2logf_max(q)
    f=lambda x: x/2 - C1*sqrt(x) - 2*w*log(x) - A*sqrt(x) - 2*mpf('1.03883')*sqrt(x)
    lo,hi=mpf(2048),mpf(10)**13
    assert f(hi)>0
    if f(lo)>0: return lo
    for _ in range(200):
        m=(lo+hi)/2
        if f(m)>0: hi=m
        else: lo=m
    for t in [hi*(1+mpf(k)/40) for k in range(400)]: assert f(t)>0
    return hi
# small conductors f in {3,4,5,7,8}: chi=1 classes; need a prime p<X, p odd, p∤n with chi(p)=1
import sympy
cls={3:[1],4:[1],5:[1,4],7:[1,2,4],8:[1,7]}
def X_small(w):
    worst=0
    for f,good in cls.items():
        cnt=0
        for p in sympy.primerange(3,10**6):
            if p%f in good:
                cnt+=1
                if cnt==w+1: worst=max(worst,p+1); break
    return worst
def check2(N1,N2):
    w=omega_max2(N2); X=max(lemmaA_X2(4*N2,w), X_small(w))
    K=floor(sqrt(mpf(N1)))-1
    lb=full_lb(K,X,w)
    if lb<2 and N1<mpf(10)**700: lb=max([lb]+[union_lb(K,X,w,y) for y in [4]+[p for p in PR if 5<=p<=200]])
    return X,w,lb
a=mpf(5)*10**11
while True:
    X,w,lb=check2(a,a*mpf('1.01'))
    if lb>=2: print("new threshold:",float(a)," X=",float(X)," w=",w," lb=",float(lb)); break
    a*=mpf('1.01')
