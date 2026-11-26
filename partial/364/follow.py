# Follow-up for Pell survivors: find a prime p dividing t exactly once (then t is not powerful),
# by trial division with all primes up to PMAX in blocks (gcd with block products).
import sys,re,gmpy2
from gmpy2 import mpz
PMAX=int(sys.argv[2])
for line in open(sys.argv[1]):
    m=re.match(r"SURVIVOR B=(\d+) t=(\d+)",line)
    if not m: continue
    B,t=int(m.group(1)),mpz(m.group(2))
    found=None; p=mpz(2); blk=[]
    q=mpz(1)
    while p<=PMAX and found is None:
        blk.append(p); q*=p
        nxt=gmpy2.next_prime(p)
        if len(blk)==2000 or nxt>PMAX:
            g=gmpy2.gcd(t,q)
            if g>1:
                for r in blk:
                    if g%r==0 and t%(r*r)!=0: found=int(r); break
            blk=[]; q=mpz(1)
        p=nxt
    print(f"B={B} digits={len(str(t))}: "+(f"NOT powerful: prime {found} divides t exactly once" if found else f"undecided up to {PMAX}"),flush=True)
