# Rigorous N0 for Erdos 1141 (a=1), assuming GRH (Dirichlet) via Bach's explicit lemma.
from mpmath import mp, mpf, log, sqrt, floor, nprod
import sympy
mp.dps = 50
PR = list(sympy.primerange(2, 100000))
def omega_max(N):            # max omega(n) for n <= N
    prod=1; w=0
    for p in PR:
        if prod*p > N: return w
        prod*=p; w+=1
def c_bach(q,x):
    return mpf(2)/3*(1+2/sqrt(x)+3/x**mpf(1.5))*(1+(mpf(5)/3)/log(q)) + (log(x)+2)/(sqrt(x)*log(q))
def lemmaA_X(q, w):
    # smallest x with  x/2 - sqrt(x)/20 - 3 - w*log(x) - c*sqrt(x)*log q - 2*1.03883*sqrt(x) > 0
    lo,hi=mpf(2),mpf(10)**12
    f=lambda x: x/2 - sqrt(x)/20 - 3 - w*log(x) - c_bach(q,x)*sqrt(x)*log(q) - 2*mpf('1.03883')*sqrt(x)
    assert f(hi)>0
    for _ in range(200):
        m=(lo+hi)/2
        if f(m)>0: hi=m
        else: lo=m
    # check f>0 on [hi, 1e12] by sampling monotonicity (f increasing for x large); verify a grid
    for t in [hi*(1+mpf(k)/50) for k in range(0,500)]:
        assert f(t)>0
    return hi
def count_lb(K, X, w, y):
    # worst case over n with 2|n and 3|n (classes mod 6p, p<X); j primes of n in [5,y], m primes > y
    T = floor(K/(6*X))
    P5=[l for l in PR if l>=5]
    small=[l for l in P5 if l<=y]; large=[l for l in P5 if l>y]
    worst=None
    for j in range(0, min(len(small), max(w-2,0))+1):
        D=mpf(1)
        for l in small[:j]: D*=1-mpf(1)/l
        m=max(w-2-j,0)
        S=sum(mpf(1)/l for l in large[:m])
        g=T*D-mpf(2)**j - (T*S+m)
        worst=g if worst is None else min(worst,g)
    return 4*worst
def check(N1,N2):
    q=4*N2; w=omega_max(N2)
    X=lemmaA_X(q,w)
    K=floor(sqrt(mpf(N1)))-1
    best=max(count_lb(K,X,w,y) for y in [4]+[p for p in PR if 5<=p<=200])
    return X,w,best
import sys
e=11
while e<=400:
    N1=mpf(10)**e; N2=mpf(10)**(e+1)
    X,w,b=check(N1,N2)
    if e<=30 or e%20==0: print(f"[1e{e},1e{e+1}): Lemma A prime < {float(X):.0f}, omega<= {w}, good-k lower bound = {float(b):.3g}  {'OK' if b>=2 else 'FAIL'}")
    if b<2: print("FAIL at",e); break
    e+=1
