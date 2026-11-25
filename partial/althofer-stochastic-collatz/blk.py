import random, math, sys
from multiprocessing import Pool
def drift(n,T):
    D={n:1.0}
    for t in range(T):
        E={}
        for x,w in D.items():
            for s in (1,-1):
                m=3*x+s
                while not m&1: m>>=1
                E[m]=E.get(m,0)+w*0.5
        D=E
    return sum(w*math.log(x) for x,w in D.items())-math.log(n)
def job(a):
    D,ub,seed,K=a; random.seed(seed); u=random.getrandbits(ub)|1; s=random.choice((1,-1))
    n=(u<<D)+s; T=math.ceil(K*math.log(n)); return (drift(n,T),D,n,T)
if __name__=="__main__":
    K=float(sys.argv[1]); tasks=[]
    for D in (8,16,24,32): 
        for i in range(int(sys.argv[2])): tasks.append((D,20,1000*D+i,K))
    with Pool(2) as p: res=p.map(job,tasks)
    for D in (8,16,24,32):
        r=[x for x in res if x[1]==D]; w=max(r)
        print(f"K={K} depth {D}: worst block drift {w[0]:+.3f} (n={w[2]}, T={w[3]}), mean {sum(x[0] for x in r)/len(r):+.3f}, samples {len(r)}",flush=True)
