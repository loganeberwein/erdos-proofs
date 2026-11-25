import random, math, sys
from multiprocessing import Pool
from blk import drift
def climb(a):
    D,ub,seed,K,iters=a; random.seed(seed); s=random.choice((1,-1))
    u=random.getrandbits(ub)|1
    f=lambda u: drift((u<<D)+s, math.ceil(K*math.log((u<<D)+s)))
    best=f(u)
    for it in range(iters):
        v=u ^ (1<<random.randrange(1,ub))
        fv=f(v)
        if fv>best: u,best=v,fv
    return best,D,(u<<D)+s
if __name__=="__main__":
    K=float(sys.argv[1])
    tasks=[(D,24,7*D+i,K,int(sys.argv[2])) for D in (2,4,8,16,24,32) for i in range(4)]
    with Pool(2) as p: res=p.map(climb,tasks)
    for D in (2,4,8,16,24,32):
        r=max(x for x in res if x[1]==D)
        print(f"K={K} D={D}: adversarial worst drift {r[0]:+.3f} at n={r[2]}",flush=True)
    for k in (20,30,40,50):
        for s in (1,-1):
            n=(1<<k)+s; print(f"pure trap 2^{k}{'+' if s>0 else '-'}1: drift {drift(n,math.ceil(K*math.log(n))):+.3f}")
