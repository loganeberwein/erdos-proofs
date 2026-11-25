import random, math
def dist(n,T,L=64):
    D={n:1.0}; out=[]
    for t in range(1,T+1):
        E={}
        for x,w in D.items():
            for s in (1,-1):
                m=3*x+s
                while m%2==0: m//=2
                E[m]=E.get(m,0)+w/2
        D=E
        h=[0.0]*L
        for x,w in D.items(): h[x%L]+=w
        tv=0.5*sum(abs(h[r]-2/L) for r in range(1,L,2))
        drift=sum(w*math.log(x) for x,w in D.items())-math.log(n)
        out.append((t,len(D),round(tv,3),round(drift,3)))
    return out
random.seed(1)
for n in [14369, 12123, random.getrandbits(60)|1, (1<<60)+1, (1<<60)-1]:
    r=dist(n,18); print(n.bit_length(), [ (t,c,tv) for t,c,tv,d in r if t in (4,8,12,16,18)], 'drift18=',r[-1][3])
