# Erdős #891, k = 2: find every window [n, n+6) with n <= 10^DIG in which all six integers have at
# most 2 distinct prime factors. Any such window contains its multiple of 6, m0, with omega(m0) <= 2,
# so m0 = 2^a 3^b (a, b >= 1). For every such m0 <= 10^DIG + 5 and each of the six placements of the
# window we try to PROVE some element has omega >= 3:
#   strip primes <= 10^5 (count distinct ones = s, cofactor r);
#   s >= 3, or s == 2 with r > 1  -> omega >= 3 (proved);
#   s == 1 and r > 1: omega >= 3 iff r is not a prime power; we test r = perfect power root, then
#     Miller-Rabin compositeness of the root (composite root => omega(r) >= 2 => omega >= 3, proved);
#   s == 0: omega(r) <= 2 cannot be ruled out cheaply -> element "possible".
# A placement with no proved element is reported (then factored with sympy if small enough).
import sys, gmpy2
from gmpy2 import mpz
from sympy import factorint
DIG=int(sys.argv[1]); LIM=mpz(10)**DIG
SP=[p for p in range(2,100000) if gmpy2.is_prime(p)]
P=mpz(1)
for p in SP: P*=p
def omega_ge3(m):
    s=0; r=mpz(m)
    g=gmpy2.gcd(r,P)
    if g==1:
        SPL=[]
    else:
        SPL=[p for p in SP if g%p==0]
    for p in SPL:
        if r%p==0:
            s+=1
            while r%p==0: r//=p
            if s>=3: return True
    if r==1: return s>=3
    if s>=2: return True
    # r > 1, all prime factors of r > 10^5 (primes below 10^5 were stripped above)
    if r < 10**15:
        return len(factorint(int(m)))>=3
    if s==1:
        for e in range(1,200):
            root,exact=gmpy2.iroot(r,e)
            if exact and gmpy2.is_prime(root): return False   # r = q^e: omega = 2
        # r not a prime power?  composite non-perfect-power with no small factor: if r is prime, omega=2
        if gmpy2.is_prime(r): return False
        # r composite, not a prime power => at least 2 distinct primes => omega >= 3
        return not any(gmpy2.iroot(r,e)[1] and gmpy2.is_prime(gmpy2.iroot(r,e)[0]) for e in range(2,200))
    return None  # s == 0: undecided cheaply
bad=[]; checked=0
a=1
while mpz(2)**a*3<=LIM+5:
    b=1
    while mpz(2)**a*mpz(3)**b<=LIM+5:
        m0=mpz(2)**a*mpz(3)**b; checked+=1
        for j in range(6):
            n=m0-j
            if n<1: continue
            proved=False; und=[]
            for m in range(int(n),int(n)+6):
                if m==m0: continue
                r=omega_ge3(m)
                if r is True: proved=True; break
                if r is None: und.append(m)
            if not proved:
                bad.append((int(n),int(m0),j,und))
        b+=1
    a+=1
print(f"3-smooth multiples of 6 up to 10^{DIG}: {checked}; placements not proved good: {len(bad)}")
for n,m0,j,und in bad: print(f"  window starting n={n} (m0=2^a3^b={m0}, j={j}) undecided elements: {und if und else 'none (all omega<=2 proved)'}")
