# Erdős #891, k = 2. A window of 6 consecutive integers with every element having <= 2 distinct prime
# factors must contain m0 = 6u with u = 2^x 3^y (the multiple of 6 has omega <= 2), and, for large
# exponents, three linear forms in u must be prime powers. The six window placements and their forms:
#   j=0 (m0..m0+5):   3u+1, 2u+1, 3u/2+1      j=5 (m0-5..m0): 3u-1, 2u-1, 3u/2-1
#   j=1 (m0-1..m0+4): 3u+1, 2u+1, 3u/2+1      j=4 (m0-4..m0+1): 3u/2-1, 2u-1, 3u-1
#   j=2 (m0-2..m0+3): 3u-1, 3u+1, 2u+1        j=3 (m0-3..m0+2): 2u-1, 3u-1, 3u+1
# (3u/2 needs x >= 1.) We look for a covering: a period M and primes p with ord_p(2), ord_p(3) | M
# such that for every (x, y) mod M one of the three forms is divisible by some p.
import sys, numpy as np
from sympy import primerange, n_order
M=int(sys.argv[1]); PMAX=int(sys.argv[2])
forms={ # each form: (coefficient as 2^ex * 3^ey, sign)  value = 2^(x+ex) 3^(y+ey) + sign
 '3u+1':(0,1,+1),'2u+1':(1,0,+1),'3u/2+1':(-1,1,+1),
 '3u-1':(0,1,-1),'2u-1':(1,0,-1),'3u/2-1':(-1,1,-1)}
placements={'j0/j1':['3u+1','2u+1','3u/2+1'],'j4/j5':['3u-1','2u-1','3u/2-1'],
            'j2':['3u-1','3u+1','2u+1'],'j3':['2u-1','3u-1','3u+1']}
primes=[p for p in primerange(5,PMAX) if M%n_order(2,p)==0 and M%n_order(3,p)==0]
print(f"M={M}: {len(primes)} usable primes up to {PMAX}: {primes[:30]}{'...' if len(primes)>30 else ''}")
X=np.arange(M)
for name,fs in placements.items():
    cov=np.zeros((M,M),dtype=bool); used=[]
    for p in primes:
        p2=np.array([pow(2,int(x),p) for x in X],dtype=np.int64); p3=np.array([pow(3,int(y),p) for y in X],dtype=np.int64)
        grid=(p2[:,None]*p3[None,:])%p
        hit=np.zeros((M,M),dtype=bool)
        for f in fs:
            ex,ey,s=forms[f]; c=(pow(2,ex%(p-1),p)*pow(3,ey,p))%p
            hit|=((c*grid+s)%p==0)
        new=(hit&~cov).sum()
        if new: used.append(p)
        cov|=hit
    print(f"  {name}: uncovered {(~cov).sum()} of {M*M} residue pairs ({100*(~cov).mean():.3f}%), primes used {len(used)}")
