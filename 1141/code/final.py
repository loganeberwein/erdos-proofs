exec(open('n0.py').read().split("def count_lb")[0])
from mpmath import exp
def omega_max2(N):
    s=mpf(0); w=0
    for p in PR:
        s+=log(p)
        if s>log(N): return w
        w+=1
def union_lb(K,X,w,y):
    T=floor(K/(6*X)); P5=[l for l in PR if l>=5]; small=[l for l in P5 if l<=y]; large=[l for l in P5 if l>y]; res=None
    for classes,cap in ((4,w-2),(6,w-1)):
        worst=None
        for j in range(0,min(len(small),max(cap,0))+1):
            D=mpf(1)
            for l in small[:j]: D*=1-mpf(1)/l
            m=max(cap-j,0); S=sum(mpf(1)/l for l in large[:m]); g=T*D-mpf(2)**j-((T+1)*S+m)
            worst=g if worst is None else min(worst,g)
        res=classes*worst if res is None else min(res,classes*worst)
    return res
def full_lb(K,X,w):
    T=floor(K/(6*X)); P5=[l for l in PR if l>=5]; res=None
    for classes,cap in ((4,w-2),(6,w-1)):
        cap=max(cap,0); D=exp(sum(log(1-mpf(1)/l) for l in P5[:cap]))
        g=classes*(T*D-mpf(2)**cap); res=g if res is None else min(res,g)
    return res
def check(N1,N2):
    w=omega_max2(N2); X=lemmaA_X(4*N2,w); K=floor(sqrt(mpf(N1)))-1
    lb=full_lb(K,X,w)
    if lb<2 and N1<mpf(10)**700: lb=max([lb]+[union_lb(K,X,w,y) for y in [4]+[p for p in PR if 5<=p<=200]])
    return lb
edges=[mpf('5.142')*10**11]
while edges[-1]<mpf(10)**12: edges.append(edges[-1]*mpf('1.01'))
e=mpf(12)
while e<20: e+=mpf('0.1'); edges.append(mpf(10)**e)
while e<100: e+=mpf('0.5'); edges.append(mpf(10)**e)
while e<20050: e+= (5 if e<2000 else 50); edges.append(mpf(10)**e)
bad=0; tight=None
for a,b in zip(edges,edges[1:]):
    lb=check(a,b)
    if lb<2: bad+=1; print("FAIL at 10^%.2f"%float(log(a)/log(10)))
    if tight is None or lb<tight[0]: tight=(lb,a)
print("intervals checked:",len(edges)-1,"failures:",bad,"; tightest margin",float(tight[0]),"at",float(tight[1]))
