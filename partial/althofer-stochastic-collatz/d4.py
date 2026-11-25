import random, math
def step(D):
    E={}
    for x,w in D.items():
        for s in (1,-1):
            m=3*x+s
            while m%2==0: m//=2
            E[m]=E.get(m,0)+w/2
    return E
def tv(D,L):
    h=[0.0]*(1<<L)
    for x,w in D.items(): h[x%(1<<L)]+=w
    return 0.5*sum(abs(h[r]-2/(1<<L)) for r in range(1,1<<L,2))
random.seed(5)
for Dp in (8,16,32,64,128):
    res=[]
    for trial in range(3):
        u=random.getrandbits(60)|1
        n=(u<<Dp)-1
        D={n:1.0}; T=int(Dp*0.9)+12
        for t in range(T): D=step(D)
        res.append((round(tv(D,4),3),round(tv(D,6),3),len(D)))
    print("depth",Dp,"steps",T,"(TV mod16, TV mod64, support):",res)
