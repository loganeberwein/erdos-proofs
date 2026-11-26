# Erdős #364 Pell families. In a triple n, n+1, n+2 of powerful numbers the middle t = n+1 is
# divisible by 4 (two even terms would include one = 2 mod 4), n and n+2 are odd and coprime, so
# t^2 - 1 = n(n+2) is powerful: t^2 - 1 = B Y^2 with B squarefree and B | Y. Conversely, if t is
# powerful, t^2 - 1 = B Y^2 with B | Y and t even, then t-1, t, t+1 are all powerful.
# For every squarefree B in [2, BMAX] this walks all Pell solutions t_k of t^2 - B Y^2 = 1 with
# t_k < 10^DIG and tests the remaining conditions: 4 | t, B | Y, t powerful.
# "t powerful" is tested by small primes p <= PMAX: a p dividing t exactly once rules t out.
# Survivors (all small primes appear at least squared) are printed for an exact follow-up.
import sys, gmpy2
from gmpy2 import mpz, isqrt
BMAX=int(sys.argv[1]); DIG=int(sys.argv[2]); PMAX=int(sys.argv[3]); part=int(sys.argv[4]); nparts=int(sys.argv[5])
primes=[p for p in range(2,PMAX+1) if gmpy2.is_prime(p)]
P=mpz(1)
for p in primes: P*=p
LIM=mpz(10)**DIG
def sqfree(n):
    p=2
    while p*p<=n:
        if n%(p*p)==0: return False
        p+=1
    return True
def fund(D):  # fundamental solution of x^2 - D y^2 = 1 by continued fractions
    a0=isqrt(D); m,d,a=0,1,a0
    h1,h=1,a0; k1,k=0,1
    while h*h-D*k*k!=1:
        m=d*a-m; d=(D-m*m)//d; a=(a0+m)//d
        h1,h=h,a*h+h1; k1,k=k,a*k+k1
    return h,k
def powerful_small(t):
    g=gmpy2.gcd(t,P)
    if g==1: return True
    for p in primes:
        if g%p==0 and t%(p*p)!=0: return False
    return True
tested=0; surv=[]
Bs=[B for B in range(2,BMAX+1) if sqfree(B)]
for i,B in enumerate(Bs):
    if i%nparts!=part: continue
    x1,y1=fund(mpz(B)); x,y=x1,y1
    while x<LIM:
        tested+=1
        if x%4==0 and y%B==0 and powerful_small(x):
            surv.append((B,int(x)))
            print(f"SURVIVOR B={B} t={x}",flush=True)
        x,y=x*x1+B*y*y1, x*y1+y*x1
print(f"part {part}: B in [2,{BMAX}] squarefree, Pell solutions t<10^{DIG} tested={tested}, survivors={len(surv)}",flush=True)
