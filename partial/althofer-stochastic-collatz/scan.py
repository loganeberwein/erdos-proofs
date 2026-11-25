import math
from multiprocessing import Pool
from blk import drift
def f(a):
    k,s,K=a; n=(1<<k)+s; return (drift(n,math.ceil(K*math.log(n))),k,s)
if __name__=="__main__":
    for K in (1.2,1.5):
        with Pool(2) as p: r=p.map(f,[(k,s,K) for k in range(12,61) for s in (1,-1)])
        w=sorted(r,reverse=True)[:5]
        print(f"K={K}: worst five over 2^k±1, k=12..60:",[(round(d,3),k,'+' if s>0 else '-') for d,k,s in w],flush=True)
